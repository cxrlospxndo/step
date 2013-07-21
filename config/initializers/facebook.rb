if Rails.env.production?
	ENV['facebook-id'] = "250953895009540"
	ENV['facebook-secret'] = "00915a1dd3b4003490d3eeb3932df1a4"
else
	ENV['facebook-id'] = "478281898863951"
	ENV['facebook-secret'] = "f7885011357c9e69d0b0b20b4bea4a63"
end
