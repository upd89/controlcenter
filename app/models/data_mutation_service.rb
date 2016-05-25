#used from API
class DataMutationService 

    def self.register(data)
        System.get_maybe_create(data)
        return { status: "OK" }
    end

    def self.updateSystemHash(urn, data)
      currentSys = System.where(urn: urn)[0]
      currentSys.update_last_seen()
      currentSys.apply_properties(data)
      currentSys.save()

      unknownPackages = []
      knownPackages = []
      stateAvailable = ConcretePackageState.first

      data["packageUpdates"].each do |updHash|
        if PackageVersion.exists?( sha256: updHash )
          knownPackages.push( updHash )
          pkgVersion = PackageVersion.where( sha256: updHash )[0]
          ConcretePackageVersion.create_new(pkgVersion, currentSys, stateAvailable)
        else
          unknownPackages.push( updHash )
        end
      end
      currentSys.save()

      if unknownPackages.length > 0
        return { status: "infoIncomplete", knownPackages: knownPackages }
      elsif currentSys.concrete_package_versions.where(concrete_package_state: ConcretePackageState.where(name: "Available")[0]).count != data["updCount"]
        return { status: "countMismatch", knownPackages: knownPackages }
      else
        return { status: "OK", knownPackages: knownPackages  }
      end
    end

    def self.updateSystem(urn, data)
      stateAvailable = ConcretePackageState.first
      error = false
      unknownPackages = false

      currentSys = System.where(urn: urn)[0]
      currentSys.update_last_seen()
      currentSys.apply_properties(data)
      error = true unless currentSys.save()

      data["packageUpdates"].each do |update|
        if !Package.exists?( name: update['name'] )
          unknownPackages = true
        else
          pkg = Package.where( name: update['name'] )[0]
          newVersion = update['candidateVersion']

          pkgVersion = PackageVersion.get_maybe_create(newVersion, pkg)

          if newVersion['sha256'] == update['baseVersionHash']
            # this is a base_version already, don't do anything
          elsif PackageVersion.exists?( sha256: update['baseVersionHash'] )
            pkgVersion.base_version = PackageVersion.where( sha256: update['baseVersionHash'] )[0]
            error = true unless pkgVersion.save()
          else
            # send pkgUnknown because the base version of this package is unknown
            unknownPackages = true
          end

          if newVersion['repository']
            pkgVersion.repository = Repository.get_maybe_create(newVersion['repository'])
          end

          if currentSys.os
            pkgVersion.distribution = Distribution.get_maybe_create(currentSys.os)
          end
          error = true unless pkgVersion.save()

          # should alredy be set by creating the package version
          #pkg.package_versions << pkgVersion
          #error = true unless pkg.save()

          ConcretePackageVersion.create_new(pkgVersion, currentSys, stateAvailable)
        end
      end

      if error
        return { status: "ERROR" }
      elsif unknownPackages
        return { status: "pkgUnknown" }
      elsif currentSys.concrete_package_versions.where(concrete_package_state: ConcretePackageState.where(name: "Available")[0]).count != data["updCount"]
        return { status: "countMismatch" }
      else
        return { status: "OK" }
      end
    end

    def self.refreshInstalledHash(urn, data)
      unknownPackages = []
      knownPackages = []
      error = false
      stateInstalled = ConcretePackageState.last

      currentSys = System.where(urn: urn)[0]
      currentSys.update_last_seen()

      # for each hash, check if this corresponds to a known version
      data["packages"].each do |pkgHash|
        if PackageVersion.exists?( sha256: pkgHash )
          pkgVersion = PackageVersion.where( sha256: pkgHash )[0]
          ConcretePackageVersion.create_new(pkgVersion, currentSys, stateInstalled)

          knownPackages.push( pkgHash )
        else
          unknownPackages.push( pkgHash )
        end
      end

      if error
        return { status: "ERROR" }
      elsif unknownPackages.length > 0
        return { status: "infoIncomplete", knownPackages: knownPackages }
      elsif currentSys.packages.count != data["pkgCount"]
        return { status: "countMismatch", knownPackages: knownPackages  }
      else
        return { status: "OK", knownPackages: knownPackages  }
      end
    end

end
