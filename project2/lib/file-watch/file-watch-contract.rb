require 'test/unit/assertions'

module ContractFileWatch
  include Test::Unit::Assertions

  
  def pre_FileWatch(mode, duration, *files)
    assert(mode.respond_to?(:to_s) && !mode.strip.empty?)
    assert(duration.respond_to? :to_i)
    files.each do |f|
      assert(f.respond_to?(:to_s) && !f.strip.empty?, "file strings cannot be empty")
    end
  end
  
  def post_FileWatch(mode, duration, *files)
    # Action should appear when files are modified accordingly
  end
end
