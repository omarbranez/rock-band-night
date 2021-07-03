Rails.application.config.middleware.use OmniAuth::Builder do

    provider :microsoft_live, ENV["LIVE_KEY"], ENV["LIVE_CLIENT_SECRET"]

end