require 'jsonpath'
require 'pry'
require 'httparty'
require 'nokogiri'

class Extractor
	def initialize()
		@hints = File.read("./hints/1.json")
		@url="https://www.rugeschevrolet.com/VehicleDetails/new-2020-Chevrolet-Silverado_1500-Crew_Cab_Standard_Box_4_Wheel_Drive_LTZ-Millbrook-NY/3485844463"
	end
	def extract_data
		extractor = JSON.parse(@hints)
		response = HTTParty.get(@url)
		dom = Nokogiri::HTML(response)
		field_data = dom.xpath(extractor["hints"]["model"]["xpath"])
		binding.pry
		model_data = field_data.text.scan(Regexp.new(extractor["hints"]["model"]["regex"])).flatten.first.scan(/\w+/)[0]
		make_data = field_data.text.scan(Regexp.new(extractor["hints"]["make"]["regex"])).flatten.first.scan(/\w+/)[0]
		year_data = field_data.text.scan(Regexp.new(extractor["hints"]["year"]["regex"])).flatten.first.scan(/\d{4}/)[0].to_s
		binding.pry
	end
end
obj = Extractor.new
obj.extract_data
