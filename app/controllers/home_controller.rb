class HomeController < ApplicationController

  def index
  end

  def results
  	if !params[:term].blank? && !params[:address].blank?

	  	#clears any previous 
		  @restaurants = Restaurant.all
		  @restaurants.destroy_all

    	query = { 
				"term" => params[:term],
				"location" => params[:address],
				"limit" => 18,
				"radius" => 20000,  
			}

			headers = { 
			    "authorization" => "Bearer #{ENV['yelp_token']}",
			}

			response = HTTParty.get("https://api.yelp.com/v3/businesses/search",
			    :query => query,
			    :headers => headers
			)

			#Let figure out how many result came back and 
			length = response["businesses"].length
			count = 0

			#Loop through our response array of hashes and send the records to our database
	  	while count < length do
				@restaurants = Restaurant.create(name: response["businesses"][count]["name"], rating: response["businesses"][count]["rating"], address: response["businesses"][count]["location"]["address1"], address2: response["businesses"][count]["location"]["address2"], address3: response["businesses"][count]["location"]["address3"], city: response["businesses"][count]["location"]["city"], phone: response["businesses"][count]["display_phone"], price: response["businesses"][count]["price"], url: response["businesses"][count]["url"], image: response["businesses"][count]["image_url"] )
				count += 1
			end
			@restaurants = Restaurant.all
		else
	    redirect_to root_path, notice: 'You must provide a food choice and location to eat!'
		end	
	end

  def test
  	#This is where we build our response, hard coding the values for term and location.  
  	#Our yelp_token is safe in application.yml

		query = { 
		  "term" => "greek",
		  "location" => "Atlanta,GA",
		}

		headers = { 
		  "authorization" => "Bearer #{ENV['yelp_token']}",
		}

		response = HTTParty.get("https://api.yelp.com/v3/businesses/search", 
		  :query => query,
		  :headers => headers
		)

		#Let figure out how many result came back and 
		length = response["businesses"].length

		count = 0

		@results = []

		while count < length do

      puts response["businesses"][count]["name"], response["businesses"][count]["location"]["display_address"], response["businesses"][count]["display_phone"], response["businesses"][count]["rating"]
		
			count += 1
		end
  end
end
