require 'rubygems'
require 'redcarpet'

class Commonplace
	attr_accessor :dir
	
	# initialize our wiki class
	def initialize(dir)
		@dir = dir
	end
	
	# checks if our directory exists
	def valid?
		File.directory? dir
	end
	
	# returns a raw list of files in our wiki directory, sans . and ..
	def files
		# if the directory doesn't exist, we bail out with a nil
		return nil unless File.directory? dir
		
		f = Dir.entries(dir)
		f.delete(".")
		f.delete("..")

		return f
	end
	
	def nameforfilename(filename)
		filename.chomp(".md").gsub('_', ' ').capitalize
	end
	
	# returns an array of known pages
	def list
		files.map! { |filename|
			{:title => nameforfilename(filename), :link => filename.chomp(".md")}
		}
	end
	
	# reads the raw contents of a given file
	def read(filename)
		file = dir + '/' + filename + '.md'
		
		# bail out if the file doesn't exist
		return nil unless File.exists? file
		
		# return the file contents if the file exists
		file = File.new file
		return file.read		
	end
	
	# returns a page instance for a given filename
	def page(filename)
		content = read(filename)
		return nil if content.nil?
		return Page.new(content, filename)
	end	
end

class Page
	attr_accessor :name
	
	def initialize(content, filename)
		@content = content # the raw page content
		@name = filename.gsub('_', ' ').capitalize
	end
	
	# return html for markdown formatted page content
	def content
		return Redcarpet.new(@content).to_html
	end
	
	# return raw page content
	def raw
		return @content
	end
end