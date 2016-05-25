#used from API
class DataMutationService 

    def self.register(data)
        system = System.get_maybe_create(data)
        return { status: "OK" }
    end

end
