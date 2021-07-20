Rails.application.config.middleware.use OmniAuth::Builder do

    provider :microsoft_live, ENV["LIVE_KEY"], ENV["LIVE_CLIENT_SECRET"]
    provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"]

end

OmniAuth.config.allowed_request_methods = %i[get]