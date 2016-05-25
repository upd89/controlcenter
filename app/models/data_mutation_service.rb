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

end
