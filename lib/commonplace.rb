#encoding: UTF-8

require 'rubygems'
require 'redcarpet'
require 'find'

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
		
		list = []
		add_file_links(dir, list)
		
		list
	end
	
	def add_file_links(directory, list)
		entries = Dir.entries(directory)
		entries.delete_if { |e| e.start_with?('.') || e.start_with?('..')}
		
		list << directory if entries.count > 0
		
		dirs = entries.select { |e| File.directory? File.join(directory, e) }
		files = entries.select { |e| File.file? File.join(directory, e) }
		files.reject! {|e| !e.end_with? '.md'}
		files.map! do |e| 
			File.join(directory, e)
		end
		list.concat files
		
		if dirs
			dirs.each { |sub_dir| add_file_links(File.join(directory, sub_dir), list) }
		end
		
		list
	end
	
	# returns an array of known pages
	def list
		files.map! { |filename|
			if File.file? filename
				{:dir => false, :title => file_to_pagename(filename), :link => filename.split('/').drop(1).join('/').chomp(".md")}
			else
				entry_for_directory(filename)
			end
		}
	end
	
	def entry_for_directory(dirname)
		splits = dirname.split('/')
		if splits.count == 1
			{:dir => true, :top_level => true, :title => "Home"}
		else
			splits_without_root = splits.slice(1, splits.length - 1)
			title = splits_without_root.join(" » ")
			{:dir => true, :top_level => false, :title => title, :link => splits_without_root.join('/')}
		end
	end
	
	# converts a pagename into the permalink form
	def get_permalink(pagename)
		pagename.gsub(" ", "_").downcase
	end
	
	# converts a permalink to the full page name
	def get_pagename(permalink)
		permalink.gsub('_', ' ').capitalize
	end
	
	# converts a pagename into the full filename
	def get_filename(pagename)
		get_permalink(pagename) + ".md"
	end
	
	# converts a filename into a page title
	def file_to_pagename(filename)
		filename.split('/').last.chomp(".md").gsub('_', ' ').capitalize
	end
		
	# returns a page instance for a given filename
	def page(permalink)
		file = dir + '/' + permalink + '.md'
		dir_path = dir + '/' + permalink
		# check if this is a directory path
		if File.directory?(dir_path)
			return Folder.new(dir_path, self)
		elsif File.exists? file
			# check if we can read content, return nil if not
			content = File.new(file, :encoding => "UTF-8").read
			return nil if content.nil?
			
			# return a new Page instance
			return Page.new(content, permalink, self)
		end
		nil
	end

	# create a new page and return it when done
	def save(filename, content)
		# FIXME - if the file exists, this should bail out
		
		# write the contents into the file
		file = dir + '/' + filename + '.md'
		f = File.new(file, "w")
		f.write(content)
		f.close
		
		# return the new file
		return page(filename)
	end
end

class Folder
	attr_accessor :name, :content, :permalink

	def initialize(path, wiki)
		@path = path
		splits = path.split('/')
		@name = splits.last
		@permalink = splits.slice(1, splits.length - 1).join('/')
	end

	def content
		list = []
		Dir.glob("#{@path}/*.md") do |file|
			filename = file.split('/').last.chomp('.md')
			list << "- <a class=\"internal\" href=\"/#{@permalink + '/' + filename}\">" + filename.gsub('_', ' ') + "</a>"
		end
		Redcarpet.new(list.join("\n")).to_html.to_s
	end
end

class Page
	attr_accessor :name, :permalink
	
	def initialize(content, filename, wiki)
		@content = content # the raw page content
		@permalink = filename
		@name = filename.gsub('_', ' ').capitalize
		@wiki = wiki
	end
	
	# return html for markdown formatted page content
	def content
		return Redcarpet.new(parse_links(@content)).to_html
	end
	
	# return raw page content
	def raw
		return @content
	end
	
	# looks for links in a page's content and changes them into anchor tags
	def parse_links(content)
		return content.gsub(/\[\[(.+?)\]\]/m) do
			name = $1
			permalink = name.downcase.gsub(' ', '_')
			display_name = name.split('/').last
			
			if @wiki.page(permalink)
				"<a class=\"internal\" href=\"/#{permalink}\">" + display_name + '</a>'
			else 
				"<a class=\"internal new\" href=\"/#{permalink}\">" + display_name + '</a>'
			end
		end.to_s
	end	
end
