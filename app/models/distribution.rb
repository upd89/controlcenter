class Distribution < ActiveRecord::Base

  # used in api
  def self.get_maybe_create(distro)
    if exists?(name: distro)
      distro_obj = where(name: distro)[0]
    else
      distro_obj = create(name: distro)
    end
    return distro_obj
  end

end
