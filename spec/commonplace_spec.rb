require '../commonplace.rb'

describe Commonplace do
	before(:each) do
		@w = Commonplace.new('testwiki')
	end
	
	it "returns nil for a non-existing directory" do
		w = Commonplace.new('testdir')
		w.list.should == nil
	end
	
	it "returns empty array for an empty directory" do
		# create a new directory
		Dir.mkdir('testdir2')
		w = Commonplace.new('testdir2')
		w.list.should == []
		
		# remove directory
		Dir.rmdir('testdir2')
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
end