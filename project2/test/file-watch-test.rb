require 'test/unit'
require 'fileutils'

require_relative '../lib/file-watch/file-watch'


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
    Dir.chdir(@wd)
    FileUtils.rm_rf(@testdir)
    puts "Done!"
  end
  
  def test_create
    block_ran = false
    t1,t2=0,0
    assert(!File.exist?('test_create'))
    
    fw = FileWatch.new('create', @waittime, 'test_create') do
      block_ran = true
      printf "create success\n"
    end

    assert fw.files.include?('test_create')
    
    fw.start
    
    assert_equal fw.mode, 'create'
    assert_equal fw.time, @waittime
    assert (fw.threads[0].alive?)

    sleep(1)
    
    File.open('test_create', "w").close; puts 'created file';
    assert(File.exist?('test_create'))
    sleep(@waittime)
    assert block_ran, "Block didn't run in create"

  end
  
  def test_alter
    block_ran = false
    t1,t2=0,0
    f= File.new('test_alter', "w").close

    fw = FileWatch.new('alter', @waittime, 'test_alter') do
      block_ran = true
      printf "alter success\n"
    end
    
    assert fw.files.include?('test_alter')
    
    fw.start
    
    assert_equal fw.mode, 'alter'
    assert_equal fw.time, @waittime
    assert (fw.threads[0].alive?)
    
    sleep(1)
    File.open('test_alter', "w") {|file| file.write("test text")}; puts 'altered file';
    sleep(@waittime)
    assert block_ran, "Block didn't run in alter"

  end

  def test_destroy
    block_ran = false
    t1,t2=0,0
    f= File.new('test_destroy', "w").close

    fw = FileWatch.new('destroy', @waittime, 'test_destroy') do
      block_ran = true
      printf "delete success\n"
    end
    
    assert fw.files.include?('test_destroy')
    
    fw.start
    
    assert_equal fw.mode, 'destroy'
    assert_equal fw.time, @waittime
    assert (fw.threads[0].alive?)
    
    sleep(1)
    FileUtils.rm('test_destroy'); puts 'destroyed file';
    sleep(@waittime)
    assert block_ran, "Block didn't run in delete"

  end

end
  
    