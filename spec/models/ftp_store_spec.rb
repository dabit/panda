require File.join( File.dirname(__FILE__), "..", "spec_helper" )


describe "FTPStore" do
  before :all do
    @store = FTPStore.new
    #@file = File.new('/tmp/file.txt', 'w+')
    #@file.puts('This is a test file')
    @file = File.open('/tmp/file.txt', 'r')
  end
  
  describe "set" do
    it "should upload a file to FTP" do
      File.exists?(@file).should be_true
      @store.set(File.basename(@file.path), @file.path).should be_true
    end
  end
  
  describe "get" do
    it "should retrieve a file from FTP" do
      @store.get(File.basename(@file.path), @file.path).should be_true
    end
  end
  
  describe "delete" do
    it "should delete the file on FTP" do
      @store.delete(File.basename(@file.path)).should be_true
    end
  end
  
  describe "url" do
    Panda::Config.use do |p|
      p[:videos_domain] = "videos.pandastream.com"
    end
    
    it "should return the file url" do
      @store.url(File.basename(@file.path)).
        should == ("http://videos.pandastream.com/#{File.basename(@file.path)}")
    end
  end
end
