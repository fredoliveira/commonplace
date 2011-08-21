require 'commonplace'
require 'rubygems'
require 'sinatra'
require 'erb'

class CommonplaceServer < Sinatra::Base
	# move these to a config?
	set :sitename, 'Hexagon'
	set :description, 'Personal wiki / Fred Oliveira'
	set :dir, '~/Documents/Dropbox/wiki' # path to the wiki directory
	
	# show the homepage
	get '/' do
		show('home')
	end
	
	get '/special/list' do
		wiki = Commonplace.new(options.dir) # DRY up
		@content = wiki.list
		erb :show
	end

	# show everything else
	get '/*' do
		show(params[:splat].first)
	end

	# returns a given page (or file) inside our repository
	def show(name)
		wiki = Commonplace.new(options.dir)
		
		if page = wiki.page(name)
			@name = page.name
			@content = page.content
			erb :show
		else
			halt 404
		end
	end
end