require 'mkmf'

RbConfig::MAKEFILE_CONFIG['CC'] = ENV['CC'] if ENV['CC']

extension_name = 'delay'

#unless pkg_config('delay.c')
#    raise "library_to_link_to not found"
#end

#have_func('useful_function', 'library_to_link_to/lib.h')
#have_type('useful_type', 'library_to_link_to/lib.h')

create_header
create_makefile(extension_name)