require 'test/unit'
require 'fileutils'
require_relative '../lib/file-watch'


class FileWatchTest < Test::Unit::TestCase
  
  def setup
    @testdir = 'tempdir'
    Dir.mkdir(@testdir)
    @wd = Dir.pwd
    Dir.chdir(@testdir)
    @waittime = 5 #seconds
    @block_ran = nil;
  end
  
  def teardown
    FileUtils.rm_rf('*')
    Dir.chdir(@wd)
    FileUtils.rm_rf(@testdir)
    puts "Done!"
  end
  
  def test_create
    block_ran = false
    assert(!File.exist?('test_create'))
    fw = FileWatch.new('create', @waittime, 'test_create') do
      block_ran = true
      puts "create success"
      
    end

    assert fw.files.include?('test_create')
    
    fw.start
    
    assert_equal fw.mode, 'create'
    assert_equal fw.time, @waittime
    assert (fw.threads[0].alive?)

    sleep(@waittime)
    File.open('test_create', "w").close
    assert(File.exist?('test_create'))
    sleep(@waittime+1)

    assert block_ran, "Block didn't run in create"
    assert (!fw.threads[0].alive?)
  end
  
  def test_alter
    block_ran = false
    f= File.new('test_alter', "w").close
    fw = FileWatch.new('alter', @waittime, 'test_alter') do
      block_ran = true
      puts "alter success"
    end
    assert fw.files.include?('test_alter')
    
    fw.start
    
    assert_equal fw.mode, 'alter'
    assert_equal fw.time, @waittime
    assert (fw.threads[0].alive?)
    sleep(@waittime)
    File.open('test_alter', "w") {|file| file.write("test text")}
    sleep(@waittime)
    assert block_ran, "Block didn't run in alter"

  end
#
#  def test_destroy
#  end
end
  
    