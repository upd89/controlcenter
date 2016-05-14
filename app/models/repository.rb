class Repository < ActiveRecord::Base
  def full_name
      origin + " " + archive + " " + component
  end
end
