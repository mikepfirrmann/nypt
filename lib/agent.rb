require 'user_agent'

module Agent
  def self.is_mobile?(request)
    UserAgent.parse(request.user_agent).browser.mobile?
  end
end
