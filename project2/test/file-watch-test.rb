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
    @error = 0.05
  end
  
  def teardown
    Dir.chdir(@wd)
    FileUtils.rm_rf(@testdir)
    puts "Done!"
  end
  
  def test_create
    assert(!File.exist?('test_create'))
    
    pid = fork {
    fw = FileWatch.new('create', @waittime, 'test_create') do
      printf "saw create\n"
    end
    
    assert fw.files.include?('test_create')
    fw.start
    assert_equal fw.mode, 'create'
    assert_equal fw.time, @waittime
    }
    Process.detach(pid)

    sleep(1)
    
    File.open('test_create', "w").close; puts "\ncreated file\n"
    assert(File.exist?('test_create'))
        puts "wait for #{@waittime} seconds";
    @waittime.times do |t|
    printf "#{t} "; sleep(1.00)
    end




  end
  
  def test_alter
    f= File.new('test_alter', "w").close
    
    pid = fork {
    fw = FileWatch.new('alter', @waittime, 'test_alter') do
      printf "alter success\n"
    end
    
    assert fw.files.include?('test_alter')
    
    fw.start
    
    assert_equal fw.mode, 'alter'
    assert_equal fw.time, @waittime
    }
    
    sleep(1)
    File.open('test_alter', "w") {|file| file.write("test text")}; puts "\naltered file\n";
    puts "wait for #{@waittime} seconds";
    @waittime.times do |t|
    printf "#{t} "; sleep(1.00)
    end


  end

  def test_destroy

    f= File.new('test_destroy', "w").close

    pid = fork {
    fw = FileWatch.new('destroy', @waittime, 'test_destroy') do
      printf "Saw delete\n"
      t2 = Time.now
    end
    
    assert fw.files.include?('test_destroy')
    
    fw.start
    
    assert_equal fw.mode, 'destroy'
    assert_equal fw.time, @waittime
    }
    
    sleep(1)
    FileUtils.rm('test_destroy'); printf "\ndestroyed file\n";
    puts "wait for #{@waittime} seconds";
    @waittime.times do |t|
    printf "#{t} "; sleep(1.00)
    end
    


  end

end
  
    