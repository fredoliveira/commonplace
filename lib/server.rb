require File.join(File.dirname(__FILE__), 'commonplace')
require 'rubygems'
require 'sinatra'
require 'erb'
require 'yaml'

class CommonplaceServer < Sinatra::Base	
	# move these to a config?
	config = YAML::load(File.open("config/commonplace.yml"))
	set :sitename, config['sitename']
	set :dir, config['wikidir']

	before do
		@wiki = Commonplace.new(options.dir)
	end
	
	# show the homepage
	get '/' do
		show('home')
	end
	
	get '/special/list' do
		@name = "Known pages"
		@pages = @wiki.list
		erb :list
	end

	# show everything else
	get '/*' do
		show(params[:splat].first)
	end

	# returns a given page (or file) inside our repository
	def show(name)
		if !@wiki.valid?
			status 500
			@name = "Wiki directory not found"
			@error = "We couldn't find the wiki directory your configuration is pointing to.<br/>Fix that, then come back - we'll be happier then."
			erb :error500
		else
			if page = @wiki.page(name)
				# may success come to those who enter here.
				@name = page.name
				@content = page.content
				erb :show
			else
				status 404
				@name = "404: Page not found"
				erb :error404
			end
		end
	end
end