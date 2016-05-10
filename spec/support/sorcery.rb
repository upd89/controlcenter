module Sorcery
  module TestHelpers
    module Rails
      module Integration
        def login_user_post(email, password)
          page.driver.post(user_sessions_url, { username: email, password: password})
        end
      end
    end
  end
end
