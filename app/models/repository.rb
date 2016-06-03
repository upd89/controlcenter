class Repository < ActiveRecord::Base
  def full_name
      origin + " " + archive + " " + component
  end

  # used in api
  def self.get_maybe_create(rep)
    repo_obj = nil
    begin
      self.transaction(isolation: :serializable) do
        repo_obj = self.find_or_create_by(
          archive: rep['archive'],
          origin: rep['origin'],
          component: rep['component']
        )
      end
    rescue ActiveRecord::StatementInvalid
      logger.debug("ActiveRecord: StatementInvalid Exception")
      retry
    end
    return repo_obj
  end
  
end
