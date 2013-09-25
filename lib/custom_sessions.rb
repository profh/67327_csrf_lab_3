module CustomSessions
  def change_session_id
    cookies.delete :session_id
    session[:level] = params[:level].to_i
    case params[:level].to_i
    when 0
      cookies[:session_id] = "SESS-#{request.remote_ip}".chomp
    when 1
      cookies[:session_id] = Base64.encode64("SESS-#{request.remote_ip}".chomp)
    when 2
      cookies[:session_id] = "#{ActiveSupport::SecureRandom.hex(2)}#{request.remote_ip}#{Time.now.to_i}"
    else
      cookies[:session_id] = "#{ActiveSupport::SecureRandom.hex(32)}#{Base64.encode64(request.remote_ip).chomp}"
    end
  end
end