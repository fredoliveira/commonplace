require_relative File.join('../lib', 'commonplace')
require_relative File.join('../lib', 'server')
require 'rack/test'

describe Commonplace do
	before(:each) do
		@w = Commonplace.new('spec/testwiki')
	end
		
	it "check returns true for an existing directory" do
		@w.valid?.should == true
	end
	
	it "check returns false for a non-existing directory" do
		w = Commonplace.new('spec/testdir')
		w.valid?.should == false
	end
	
	it "returns empty array for an empty directory" do
		# create a new directory
		Dir.mkdir('spec/testdir2')
		w = Commonplace.new('spec/testdir2')
		w.list.should == []
		
		# remove directory
		Dir.rmdir('spec/testdir2')
	end
	
	it "should return nil when accessing a non-existing file" do
		@w.page('testfile').should == nil
	end
	
	it "should return contents of a file when accessing an existing file" do
		@w.page('test').raw.should == "Test file - don't change these contents."
		@w.page('test').content.should == "<p>Test file - don't change these contents.</p>\n"
	end
	
	it "should return a Page instance when a valid page is requested" do
		@w.page('test').class.should == Page
	end
	
	it "should return valid raw content for an existing page" do
		@w.page('test').raw.should == "Test file - don't change these contents."
	end
	
	it "should return a capitalized, underscore free title based on the file name" do
		@w.page('test_spaces').name.should == "Test spaces"
	end
	
	it "should work out of the box" do
		w = Commonplace.new("wiki")
		w.valid?.should == true
		w.page('home').name.should == "Home"
		w.page('markdown_test').name.should == "Markdown test"
	end
	
	it "should save a page correctly" do
		@w.save('savetest', "This is a test save").class.should == Page
		@w.page('savetest').raw.should == "This is a test save"
	end
	
	it "should convert pages to files and back" do
		fwd = @w.get_permalink("This is a test page name")
		fwd.should == "this_is_a_test_page_name"
		rev = @w.get_pagename(fwd)
		rev.should == "This is a test page name"
		@w.get_filename("This is a test page name").should == "this_is_a_test_page_name.md"
	end
	
	it "should look for links in double square brackets and create anchor tags" do
		@w.page('linktest').content.should == "<p><a class=\"internal\" href=\"/test\">Test</a></p>\n"
	end
	
	it "should highlight links to pages that don't exist with the correct class" do
		@w.page('linktest2').content.should == "<p><a class=\"internal new\" href=\"/non_existing_page\">Non existing page</a></p>\n"
	end
end

describe CommonplaceServer do
	include Rack::Test::Methods
	
	def app
		CommonplaceServer
	end
	
	it "renders the homepage successfully" do
		get '/'
		last_response.should be_ok
	end
	
	it "renders an existing page successfully" do
		get '/home'
		last_response.should be_ok
	end
	
	it "returns a 404 when trying to view a page that doesnt exist" do
		get '/anonexistingpagehopefully'
		last_response.should_not be_ok
		last_response.status.should == 404
	end

	it "renders the edit page for an existing page successfully" do
		get '/p/home/edit'
		last_response.should be_ok
	end

	it "returns a 404 when trying to edit a page that doesnt exist" do
		get '/p/anonexistingpagehopefully/edit'
		last_response.should_not be_ok
		last_response.status.should == 404
	end
	
	it "renders the page list successfully" do
		get '/list'
		last_response.should be_ok
	end
	
	it "renders the new page successfully" do
		get '/p/new'
		last_response.should be_ok
	end
	
	it "renders the new page for a specific page successfully" do
		get '/p/new/anonexistingpagehopefully'
		last_response.should be_ok
	end
end