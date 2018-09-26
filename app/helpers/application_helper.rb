module ApplicationHelper
  def is_mobile?
    !!request.user_agent.match(/ios|android|mobile/i)
  end
end
