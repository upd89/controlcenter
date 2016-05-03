module Api::V2
  class ApiController < ApplicationController
    protect_from_forgery with: :null_session

    before_action :require_valid_json

    def require_valid_json
      unless JSON.parse( request.body.read)
        render json: { status: "ERROR" }
        return
      end
    end

    def check_mandatory_json_params( data, params=[""] )
      error = false
      params.each do |param|
        error = true unless data.keys.include?(param)
      end
      return error
    end

    def apply_system_properties( sys, data )
      sys.name = data["name"] if data["name"]
      sys.urn = data["urn"] if data["urn"]
      sys.os = data["os"] if data["os"]
      sys.address = data["address"] if data["address"]
      sys.reboot_required = data["rebootRequired"] if data["rebootRequired"]
      sys.last_seen = DateTime.now
    end

    # v2/register
    def register
      data = JSON.parse request.body.read

      if check_mandatory_json_params(data, ["name", "urn", "os", "address", "certificate"]) || System.exists?(:urn => data["urn"])
        render json: { status: "ERROR" }
        return
      end

      newSys = System.new
      apply_system_properties( newSys, data )
      newSys.system_group = SystemGroup.first
      newSys.last_seen = DateTime.now

      if newSys.save()
        render json: { status: "OK" }
      else
        render json: { status: "ERROR" }
      end
    end

    # v2/system/:urn/notify-hash
    def updateSystemHash
      data = JSON.parse request.body.read

      if check_mandatory_json_params(data, ["updCount", "packageUpdates"]) || !System.exists?(urn: params[:urn])
        render json: { status: "ERROR" }
        return
      end

      currentSys = System.where(urn: params[:urn])[0]

      unknownPackages = []
      knownPackages = []
      stateAvailable = ConcretePackageState.first

      data["packageUpdates"].each do |updHash|
        if PackageVersion.exists?( sha256: updHash )
          knownPackages.push( updHash )

          pkgVersion = PackageVersion.where( sha256: updHash )[0]

          # only create new CPV if it doesn't already exist!
      	  if ConcretePackageVersion.exists?( package_version: pkgVersion, system: currentSys )
       	    # If it exists, set its state to Available
       	    assoc = ConcretePackageVersion.where( package_version: pkgVersion, system: currentSys )[0]
            assoc.concrete_package_state = stateAvailable
            assoc.save()
          else
            assoc = ConcretePackageVersion.new
            assoc.system = currentSys
            assoc.concrete_package_state = stateAvailable
            assoc.package_version = pkgVersion
            assoc.save()

            currentSys.concrete_package_versions << assoc
          end
        else
          unknownPackages.push( updHash )
        end
      end
      currentSys.save()

      if unknownPackages.length > 0
        render json: { status: "infoIncomplete", knownPackages: knownPackages }
      else
        if currentSys.concrete_package_versions.count != data["updCount"]
          render json: { status: "countMismatch", knownPackages: knownPackages }
        else
          render json: { status: "OK", knownPackages: knownPackages  }
        end
      end
    end

    # v2/system/:urn/notify
    def updateSystem
      data = JSON.parse request.body.read

      if check_mandatory_json_params(data, ["updCount", "packageUpdates"]) || !System.exists?(urn: params[:urn])
        render json: { status: "ERROR" }
        return
      end

      stateAvailable = ConcretePackageState.first
      error = false
      unknownPackages = false

      currentSys = System.where(urn: params[:urn])[0]
      apply_system_properties( currentSys, data )
      error = true unless currentSys.save()


      data["packageUpdates"].each do |update|
        # best case: CC already knows the version that's available
        if PackageVersion.exists?( sha256: update['sha256'] )
          pkgVersion = PackageVersion.where( sha256: update['sha256'] )[0]

          # TODO: refactor CPV creation (DRY yo)
          # only create new CPV if it doesn't already exist!
          if ConcretePackageVersion.exists?( package_version: pkgVersion, system: currentSys )
            # If it exists, set its state to Available
            assoc = ConcretePackageVersion.where( package_version: pkgVersion, system: currentSys )[0]
            assoc.concrete_package_state = stateAvailable
            error = true unless assoc.save()
          else
            assoc = ConcretePackageVersion.new
            assoc.system = currentSys
            assoc.concrete_package_state = stateAvailable
            assoc.package_version = pkgVersion
            error = true unless assoc.save()

            currentSys.concrete_package_versions << assoc
            error = true unless currentSys.save()
          end
        else
          # 2nd best option: specific version is unknown, but package itself is known
          if Package.exists?( name: update['name'] )
            pkg = Package.where( name: update['name'] )[0]

            pkgVersion = PackageVersion.new
            pkgVersion.sha256 = update['sha256'] if update['sha256']
            pkgVersion.version = update['version'] if update['version']
            pkgVersion.architecture = update['architecture'] if update['architecture']
            pkgVersion.package = pkg

            if update['sha256'] == update['baseVersion']
              # this is a base_version
            elsif PackageVersion.exists?( sha256: update['baseVersion'] )
              pkgVersion.base_version = PackageVersion.where( sha256: update['baseVersion'] )[0]
	            else
              # send pkgUnknown!
              unknownPackages = true
            end

            if update['repository']
              rep = update['repository']
              if Repository.exists?( archive: rep['archive'], origin: rep['origin'], component: rep['component'] )
                currentRepo = Repository.where( archive: rep['archive'], origin: rep['origin'], component: rep['component'] )[0]
              else
                currentRepo = Repository.create(archive: rep['archive'], origin: rep['origin'], component: rep['component'] )
              end
              pkgVersion.repository = currentRepo
            end

            # TODO: refactor distro handling
            if currentSys.os
              if Distribution.exists?(name: currentSys.os)
                dist = Distribution.where(name: currentSys.os)[0]
              else
                dist = Distribution.create(name: currentSys.os)
              end
              pkgVersion.distribution = dist
            end
            error = true unless pkgVersion.save()

            pkg.package_versions << pkgVersion
            error = true unless pkg.save()

            # only create new CPV if it doesn't already exist!
            if ConcretePackageVersion.exists?( package_version: pkgVersion, system: currentSys )
              # If it exists, set its state to Available
              assoc = ConcretePackageVersion.where( package_version: pkgVersion, system: currentSys )[0]
              assoc.concrete_package_state = stateAvailable
              error = true unless assoc.save()
       	    else
      	      assoc = ConcretePackageVersion.new
              assoc.system = currentSys
              assoc.concrete_package_state = stateAvailable
              assoc.package_version = pkgVersion
              error = true unless assoc.save()

              currentSys.concrete_package_versions << assoc
              error = true unless currentSys.save()
            end

          else
            # send pkgUnknown!
            unknownPackages = true
          end
        end
      end

      if error
        render json: { status: "ERROR" }
      elsif unknownPackages
        render json: { status: "pkgUnknown" }
      elsif currentSys.concrete_package_versions.count != data["updCount"]
        render json: { status: "countMismatch" }
      else
        render json: { status: "OK" }
      end
    end

    # v2/system/:urn/refresh-installed-hash
    def refreshInstalledHash
      data = JSON.parse request.body.read

      if check_mandatory_json_params(data, ["pkgCount", "packages"]) || !System.exists?(:urn => params["urn"])
        render json: { status: "ERROR" }
        return
      end

      unknownPackages = []
      knownPackages = []
      error = false
      stateInstalled = ConcretePackageState.last

      currentSys = System.where(urn: params[:urn])[0]
      error = true unless currentSys.save()

      # for each hash, check if this corresponds to a known version
      data["packages"].each do |pkgHash|
        if PackageVersion.exists?( sha256: pkgHash )
          pkgVersion = PackageVersion.where( sha256: pkgHash )[0]

          # create CPV if not existing
          if ConcretePackageVersion.exists?( package_version: pkgVersion, system: currentSys )
            # If it exists, set its state to Installed
            assoc = ConcretePackageVersion.where( package_version: pkgVersion, system: currentSys )[0]
            assoc.concrete_package_state = stateInstalled
            error = true unless assoc.save()
          else
            assoc = ConcretePackageVersion.create({
              :system => currentSys,
              :concrete_package_state => stateInstalled,
              :package_version => pkgVersion
            })

            currentSys.concrete_package_versions << assoc
            error = true unless currentSys.save()
          end
          knownPackages.push( pkgHash )
        else
          unknownPackages.push( pkgHash )
        end
      end

      if error
        render json: { status: "ERROR" }
      elsif unknownPackages.length > 0
        render json: { status: "infoIncomplete", knownPackages: knownPackages }
      elsif currentSys.packages.count != data["pkgCount"]
        render json: { status: "countMismatch", knownPackages: knownPackages  }
      else
        render json: { status: "OK", knownPackages: knownPackages  }
      end
    end

    # v2/system/:urn/refresh-installed
    def refreshInstalled
      data = JSON.parse request.body.read

      if check_mandatory_json_params(data, ["pkgCount", "packages"]) || !System.exists?(:urn => params["urn"])
        render json: { status: "ERROR" }
        return
      end

      error = false
      stateInstalled = ConcretePackageState.last
      currentSys = System.where(urn: params[:urn])[0]

      if currentSys.os
        if Distribution.exists?(name: currentSys.os)
          dist = Distribution.where(name: currentSys.os)[0]
        else
          dist = Distribution.create(name: currentSys.os)
        end
      end

      data["packages"].each do |package|
        # best case: we know the package (by name)
        if Package.exists?( name: package['name'] )
          currentPkg = Package.where( name: package['name'] )[0]
          # update package information if specified
          currentPkg.section  = package['section']  if package['section']
          currentPkg.homepage = package['homepage'] if package['homepage']
          currentPkg.summary  = package['summary']  if package['summary']
          error = true unless currentPkg.save()
        else
          # creating package
          currentPkg = Package.create( {
                 :name         =>  package['name'],
                 :section      =>  package['section'],
                 :homepage     =>  package['homepage'],
                 :summary      =>  package['summary']
          } )
        end

        # check if specified version exists
        if PackageVersion.exists?(package: currentPkg, sha256: package['sha256'])
          pkgVersion = PackageVersion.where(package: currentPkg, sha256: package['sha256'])[0]
          pkgVersion.version      = package['version']      if package['version']
          pkgVersion.architecture = package['architecture'] if package['architecture']
        else
          pkgVersion = PackageVersion.create({
             :package      => currentPkg,
             :version      => package['version'],
             :sha256       => package['sha256'],
             :architecture => package['architecture']
          })
        end

        # this is already the base version of baseVersion's hash is the same as this version's
        if package['baseVersion'] != pkgVersion.sha256
          if PackageVersion.exists?(sha256: package['baseVersion'])
            pkgVersion.base_version = PackageVersion.where(sha256: package['baseVersion'])[0]
            error = true unless pkgVersion.save()
          else
            error = true
            # TODO - what now?
          end
        end

        # set or update distro
        if dist
          pkgVersion.distribution = dist
          error = true unless pkgVersion.save()
        end

        # set or update repository
        if package['repository']
          rep = package['repository']
          if Repository.exists?( archive: rep['archive'], origin: rep['origin'], component: rep['component'] )
            currentRepo = Repository.where( archive: rep['archive'], origin: rep['origin'], component: rep['component'] )[0]
          else
            currentRepo = Repository.create(archive: rep['archive'], origin: rep['origin'], component: rep['component'] )
          end
          pkgVersion.repository = currentRepo
          error = true unless pkgVersion.save()
        end

        # create CPV if not existing
        if ConcretePackageVersion.exists?( package_version: pkgVersion, system: currentSys )
          # If it exists, set its state to Installed
          assoc = ConcretePackageVersion.where( package_version: pkgVersion, system: currentSys )[0]
          assoc.concrete_package_state = stateInstalled
          error = true unless assoc.save()
        else
          assoc = ConcretePackageVersion.create({
            :system => currentSys,
            :concrete_package_state => stateInstalled,
            :package_version => pkgVersion
          })

          currentSys.concrete_package_versions << assoc
          error = true unless currentSys.save()
        end

      end

      if error
        render json: { status: "ERROR" }
      elsif currentSys.packages.count != data["pkgCount"]
        render json: { status: "countMismatch" }
      else
        render json: { status: "OK" }
      end
    end

    # v2/task/:id/notify
    def updateTask
      data = JSON.parse request.body.read
      error = false

      if check_mandatory_json_params(data, ["state", "log"]) || !Task.exists?(params[:id])
        render json: { status: "ERROR" }
        return
      end

      task = Task.find(params[:id])
      state = TaskState.where(:name => data["state"] ).first
      if state
        task.task_state = state
        # TODO + log
        error = true unless task.save()
      end

      if error
        render json: { status: "ERROR" }
      else
        render json: { status: "OK"  }
      end

    end
  end
end
