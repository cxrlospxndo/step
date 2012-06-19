if Rails.env.production?
	ENV['facebook-id'] = "272946046069969"
	ENV['facebook-secret'] = "7061d23e054ae2a04c7b3d0faa1604e0"
else
	ENV['facebook-id'] = "478281898863951"
	ENV['facebook-secret'] = "f7885011357c9e69d0b0b20b4bea4a63"
end
