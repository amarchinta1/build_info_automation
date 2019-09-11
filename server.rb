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
		@model_file=File.read("./model.csv")
		@models=@model_file.split("\n"):
		@makes = @makes_file.split("\n")
		@vins =	@file.split("\n")
	end
	
	def get_taxonoy
		log=Logger.new(STDOUT)	
		k=[]
		@vins.each{|i|
		log.info("Generating taxonomy vin for #{i}")
		   k << i[0..7]+i[9]+i[10]
		}
	    return k
	end

	
	def get_headings
    	log = Logger.new(STDOUT)
		extractor = JSON.parse(@hints)
		log.info("reading all vins ..")
		vins = File.read("./vins").split("\n")
		headings=Array.new
		listings_make = Array.new
		year=[]
		data=[]
		vins.each{ |k|
			log.info("Getting info of #{k} From Search Api")
	    	api_uri= "https://marketcheck-prod.apigee.net/v1/search?api_key=14mBZaYAxBfLSNbL0Z2LlAG3009LMV79&vin=#{k}"
			curl_data = HTTParty.get(api_uri) rescue nil		
			curl_data["listings"].each{ |_listing|
				@makes.each{|__make|
		   			if (_listing["heading"].include?(__make)){
					 	listings_make << __make 
						year 	 << _listing["heading"].scan(Regexp.new(extractor["hints"]["year"]["regex"])).flatten.first       						end
				  		headings << _listing["heading"]
				  		dp_urls  << _listing["vdp_url"]
				  	}
				}
			}
		}
		
		data =[year, listings_make, headings,dp_urls]
		return data
	end

	# def get_dp_urls
	# 		log=Logger.new(STDOUT)	
	# 		dp_urls=[]
	# 			@vins.each{ |k|
	# 		       log.info("Getting dp_url of #{k} from Search API")
	# 			 	api_uri= "https://marketcheck-prod.apigee.net/v1/search?api_key=14mBZaYAxBfLSNbL0Z2LlAG3009LMV79&vin=#{k}"
	# 				curl_data = HTTParty.get(api_uri)
	# 				curl_data["listings"].each{|_listing|
	# 					dp_urls << _listing["vdp_url"] rescue nil
	# 				}
	# 			}
	# 	return dp_urls
	# end

	def get_file
		log=Logger.new(STDOUT)	
		@expected_count = @vins.size
		log.info("Expected count is - #{@expected_count}")
		all_taxonomy = get_taxonoy
		f = File.open("./11-9.csv","w+")
		log.info("generated file for - #{@date}")
		headings = get_headings
		binding.pry
		dp_urls = get_dp_urls
			for i in 0..@expected_count do
   				f.print(@vins[i] + "," + all_taxonomy[i] + "," + headings[0][i] + "," + headings[1][i] + "," + headings[2][i] + "," + headings[3][i] + "\n")
			end
		f.close
		puts "done with creating file "
	end	
end


o = Test.new
o.get_file
