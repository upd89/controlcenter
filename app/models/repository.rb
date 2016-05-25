class Repository < ActiveRecord::Base
  def full_name
      origin + " " + archive + " " + component
  end

    # used in api
    def self.get_maybe_create(rep)
        if exists?( archive: rep['archive'], origin: rep['origin'], component: rep['component'] )
            repo_obj = where( archive: rep['archive'], origin: rep['origin'], component: rep['component'] )[0]
        else
            repo_obj = create(archive: rep['archive'], origin: rep['origin'], component: rep['component'] )
        end
        return repo_obj
    end


end
