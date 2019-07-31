require 'pry'
require 'httparty'
require 'nokogiri'
class Test
	def initialize
		@file= File.read("./vins")
		@vins =	@file.split("\n")
	end
	
	def get_taxonoy
		k=[]
		@vins.each do |i|
		   k << i[0..7]+i[9]+i[10]
		 end 
	    return k
	end
	
	def get_dp_urls
		dp_urls=[]
		@vins.each do |k|
			api_uri= "https://marketcheck-prod.apigee.net/v1/search?api_key=14mBZaYAxBfLSNbL0Z2LlAG3009LMV79&vin=#{k}"
			curl_data = HTTParty.get(api_uri)
			curl_data["listings"].each{|_listing|
				dp_urls << _listing["vdp_url"]
			}
		end
		return dp_urls			
	end
	def get_file
		@expected_count = @vins.size
		binding.pry
		all_taxonomy = get_taxonoy
		f = File.open("./data1.csv","w+")
		dp_urls = get_dp_urls
			for i in 0..@expected_count do
   				f.print(@vins[i] + "," + all_taxonomy[i] + "," + dp_urls[i] + "\n")
			end
		f.close
		puts "done with creating file "
	end
		
	# def curl_page
	# 	dp_url = get_dp_urls
	# 	dp_url.each do |i|
	# 		unparsed_page =HTTPary.get(dp_url) 
	# 		dom = Nokogiri::HTML(unparsed_page)
	# 		binding.pry
	# 	end
	# end
end

o = Test.new
o.get_file

