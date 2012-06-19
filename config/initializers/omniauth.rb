if Rails.env.production?
	ENV['facebook-id'] = "250953895009540"
	ENV['facebook-secret'] = "00915a1dd3b4003490d3eeb3932df1a4"
else
	ENV['facebook-id'] = "478281898863951"
	ENV['facebook-secret'] = "f7885011357c9e69d0b0b20b4bea4a63"
end
#Si ocurre el sgt error Koala::Facebook::APIError 
#HTTP 500: Response body: {"error":{"message":"No node specified","type":"Exception"
#falta especificar los permisos

Rails.application.config.middleware.use OmniAuth::Builder do

	#provider :twitter, "", ""
	provider :facebook, ENV['facebook-id'], ENV['facebook-secret']
	#provider :google_oauth2, "", "", {}
end

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}