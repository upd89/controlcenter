#used from API
class DataMutationService

  def self.find_and_mark_outdated_packages( hashList, currentList  )
    cpv_state_outdated = ConcretePackageState.where(name: "Outdated")[0]

    leftOverCPVs = currentList.reject{ |upd8| hashList.include? upd8.package_version.sha256 }

    leftOverCPVs.each do |leftie|
      leftie.concrete_package_state = cpv_state_outdated
      leftie.save()
    end
  end

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
    cpv_state_avail = ConcretePackageState.where(name: "Available")[0]

    data["packageUpdates"].each do |updHash|
      if PackageVersion.exists?( sha256: updHash )
        knownPackages.push( updHash )
        pkgVersion = PackageVersion.where( sha256: updHash )[0]
        ConcretePackageVersion.create_new(pkgVersion, currentSys, cpv_state_avail)
      else
        unknownPackages.push( updHash )
      end
    end
    currentSys.save()

    # full update, most likely after a countMismatch.
    if data["updCount"] == data["packageUpdates"].length
      find_and_mark_outdated_packages( data["packageUpdates"], currentSys.get_installable_CPVs )
    end

    if unknownPackages.length > 0
      return { status: "infoIncomplete", knownPackages: knownPackages }
    elsif currentSys.get_installable_CPVs.count != data["updCount"]
      return { status: "countMismatch", knownPackages: knownPackages }
    else
      return { status: "OK", knownPackages: knownPackages  }
    end
  end

  def self.updateSystem(urn, data)
    error = false
    unknownPackages = false
    cpv_state_avail = ConcretePackageState.where(name: "Available")[0]

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

        ConcretePackageVersion.create_new(pkgVersion, currentSys, cpv_state_avail)
      end
    end

    # full update, most likely after a countMismatch.
    if data["updCount"] == data["packageUpdates"].length
      hashArray = data["packageUpdates"].map{ |pkg| (pkg["candidateVersion"])["sha256"] }

      find_and_mark_outdated_packages( hashArray, currentSys.get_installable_CPVs )
    end

    if error
      return { status: "ERROR" }
    elsif unknownPackages
      return { status: "pkgUnknown" }
    elsif currentSys.get_installable_CPVs.count != data["updCount"]
      return { status: "countMismatch" }
    else
      return { status: "OK" }
    end
  end

  def self.refreshInstalledHash(urn, data)
    unknownPackages = []
    knownPackages = []
    error = false
    cpv_state_installed = ConcretePackageState.where(name: "Installed")[0]

    currentSys = System.where(urn: urn)[0]
    currentSys.update_last_seen()

    # for each hash, check if this corresponds to a known version
    data["packages"].each do |pkgHash|
      if PackageVersion.exists?( sha256: pkgHash )
        pkgVersion = PackageVersion.where( sha256: pkgHash )[0]
        ConcretePackageVersion.create_new( pkgVersion, currentSys, cpv_state_installed )

        knownPackages.push( pkgHash )
      else
        unknownPackages.push( pkgHash )
      end
    end

    # full update, most likely after a countMismatch.
    if data["pkgCount"] == data["packages"].length
      find_and_mark_outdated_packages( data["packages"], currentSys.get_installed_cpvs )
    end

    if error
      return { status: "ERROR" }
    elsif unknownPackages.length > 0
      return { status: "infoIncomplete", knownPackages: knownPackages }
    elsif currentSys.get_installed_cpvs.count != data["pkgCount"]
      return { status: "countMismatch", knownPackages: knownPackages  }
    else
      return { status: "OK", knownPackages: knownPackages  }
    end
  end

  def self.refreshInstalled(urn, data)
    currentSys = System.where(urn: urn)[0]
    currentSys.update_last_seen()
    error = false
    cpv_state_installed = ConcretePackageState.where(name: "Installed")[0]

    if currentSys.os
        dist = Distribution.get_maybe_create( currentSys.os )
    end

    data["packages"].each do |package|
      currentPkg = Package.get_maybe_create(package)
      installedVersion = package['installedVersion']
      pkgVersion = PackageVersion.get_maybe_create( installedVersion, currentPkg )

      # set or update distro
      if dist
        pkgVersion.distribution = dist
        error = true unless pkgVersion.save()
      end

      # set or update repository
      if installedVersion['repository']
        pkgVersion.repository = Repository.get_maybe_create(installedVersion['repository'])
        error = true unless pkgVersion.save()
      end

      ConcretePackageVersion.create_new( pkgVersion, currentSys, cpv_state_installed )

      if !package['isBaseVersion']
        baseVersionJSON = package['baseVersion']

        baseVersion = PackageVersion.get_maybe_create( baseVersionJSON, currentPkg )

        pkgVersion.base_version = baseVersion
        error = true unless pkgVersion.save()

        # set or update distro
        if dist
            baseVersion.distribution = dist
            error = true unless baseVersion.save()
        end

        # set or update repository
        if baseVersionJSON['repository']
            baseVersion.repository = Repository.get_maybe_create( baseVersionJSON['repository'] )
            error = true unless baseVersion.save()
        end

        ConcretePackageVersion.create_new( baseVersion, currentSys, cpv_state_installed )

        pkgVersion.base_version = baseVersion
        error = true unless pkgVersion.save()

      end

    end

    # full update, most likely after a countMismatch.
    if data["pkgCount"] == data["packages"].length
      hashArray = data["packages"].map{ |pkg| (pkg["installedVersion"])["sha256"] }

      find_and_mark_outdated_packages( hashArray, currentSys.get_installed_cpvs )
    end

    if error
      return { status: "ERROR" }
    elsif currentSys.get_installed_cpvs.count != data["pkgCount"]
      return { status: "countMismatch" }
    else
      return { status: "OK" }
    end
  end

  def self.updateTask(taskid, data)
    error = false
    task = Task.find(taskid)
    state = TaskState.where(:name => data["state"] ).first
    if state
      task.task_state = state
      # TODO + log
    end

    if data["log"]
      task.task_execution = TaskExecution.create(log: data["log"] )
    end

    if data["state"].downcase == "done"
      pkg_state = ConcretePackageState.where(name: "Installed").first
    else
      pkg_state = ConcretePackageState.where(name: "Available").first
    end

    task.concrete_package_versions.each do |cpv|
      cpv.concrete_package_state = pkg_state
      error = true unless cpv.save()
    end

    error = true unless task.save()

    if error
      return { status: "ERROR" }
    else
      return { status: "OK"  }
    end
  end

end
