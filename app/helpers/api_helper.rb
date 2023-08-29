module ApiHelper
  def current_user
    user = nil
    authorize_header = request.headers['Authorization']

    if authorize_header
      token = authorize_header.split.last
      user = User.find_by(auth_token: token)
    end

    user
  end
end
