require 'coord2d.rb'
require 'icon.rb'
require 'identicon.rb'

Dir.chdir(File.dirname(__FILE__))

#Catch HTTP request
get '/:hash.png', :provides => :png do |hash|
	icon = Identicon::from_hash hash

	icon.to_png
end

get '/:hash.coords', :provides => :text do |hash|
	icon = Identicon::from_hash hash

	icon.to_coord
end

get '/:hash.json', :provides => :json do |hash|
	icon = Identicon::from_hash hash

	icon.to_a.to_json
end

get '/:name' do |name|
	icon = Identicon.new name

	icon.to_hash
end
