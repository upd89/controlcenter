class Distribution < ActiveRecord::Base

  # used in api
  def self.get_maybe_create(distro)
    distro_obj = nil
    begin
      self.transaction(isolation: :serializable) do
        distro_obj = self.find_or_create_by(name: distro)
      end
    rescue ActiveRecord::StatementInvalid
      logger.debug("ActiveRecord: StatementInvalid Exception")
      retry
    end
    return distro_obj
  end
  
end
