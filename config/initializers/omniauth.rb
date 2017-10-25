Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.staging? || Rails.env.staging?
    provider :github, ENV["HEROKU_GITHUB_CLIENT_ID"], ENV["HEROKU_GITHUB_CLIENT_SECRET"], scope: "user:email"
  else
    provider :github, ENV["GITHUB_CLIENT_ID"], ENV["GITHUB_CLIENT_SECRET"], scope: "user:email"
  end
end
