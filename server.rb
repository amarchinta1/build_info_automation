require 'pry'
require 'httparty'
require 'nokogiri'
require 'jsonpath'
require 'logger'
class Test
	def initialize
		log=Logger.new(STDOUT)	
		@file = File.read("./vins")
		@hints = File.read("./hints/1.json")
		@makes_file = File.read("./make")
		@makes = @makes_file.split("\n")
		@vins =	@file.split("\n")
	end
	
	def get_taxonoy
		log=Logger.new(STDOUT)	
		k=[]
		@vins.each do |i|
		log.info("Generating taxonomy vin for #{i}")
		   k << i[0..7]+i[9]+i[10]
		 end 
	    return k
	end
	
	def get_headings
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

	def get_dp_urls
	log=Logger.new(STDOUT)	
		dp_urls=[]
		@vins.each do |k|
	       log.info("Getting dp_url of #{k} from Search API")
		 api_uri= "https://marketcheck-prod.apigee.net/v1/search?api_key=14mBZaYAxBfLSNbL0Z2LlAG3009LMV79&vin=#{k}"
			curl_data = HTTParty.get(api_uri)
			curl_data["listings"].each{|_listing|
				dp_urls << _listing["vdp_url"]
			}
		end
		return dp_urls
	end

	def get_file
		log=Logger.new(STDOUT)	
		@expected_count = @vins.size
		log.info("Expected count is - #{@expected_count}")
		all_taxonomy = get_taxonoy
		f = File.open("./test.csv","w+")
		log.info("generated file for - #{@date}")
		headings = get_headings
		dp_urls =get_dp_urls
		binding.pry
			for i in 0..@expected_count do
   			f.print(@vins[i] + "," + all_taxonomy[i] + "," + headings[2][i] + "," + headings[0][i] + "," + headings[1][i] + "," + dp_urls[i] + "\n")
			end
		f.close
		puts "done with creating file "
	end	

end

o = Test.new
o.get_file

