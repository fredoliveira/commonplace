require 'lib/commonplace'

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
		@w.read('testfile').should == nil
	end
	
	it "should return contents of a file when accessing an existing file" do
		@w.read('test').should == "Test file - don't change these contents."
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
end