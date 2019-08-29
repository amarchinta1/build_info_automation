require 'pry'
require 'httparty'
require 'logger'
require 'good_print'
require 'jsonpath'
class Test
	def initialize
		
		@hints = File.read("./hints/1.json")
		@makes_file = File.read("./make")
		@makes = @makes_file.split("\n")
	end
	
	def getting_heading
		log = Logger.new(STDOUT)
		extractor = JSON.parse(@hints)
		log.info("reading all vins ..")
		vins = File.read("./vins").split("\n")
		headings=Array.new
		listings_make =Array.new
		year=[]
		data=[]
		vins.each do |k|
			log.info("Getting info of #{k} From Search Api")
	    		api_uri= "https://marketcheck-prod.apigee.net/v1/search?api_key=14mBZaYAxBfLSNbL0Z2LlAG3009LMV79&vin=#{k}"
				curl_data = HTTParty.get(api_uri)
				curl_data["listings"].each{|_listing|
					@makes.each do |__make|
						if _listing["heading"].include?(__make)
							listings_make << __make
							year << _listing["heading"].scan(Regexp.new(extractor["hints"]["year"]["regex"])).flatten.first
						end
					end
					headings << _listing["heading"]
				}
		end
		data= [ listings_make, headings, year]
		binding.pry
		return data
	end

end


obj = Test.new

obj.getting_heading
