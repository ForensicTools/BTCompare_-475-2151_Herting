
require 'syslog/logger'
require_relative 'btcompare/torrent_file.rb'
require_relative 'btcompare/comparison.rb'
require_relative 'btcompare/result.rb'
require_relative 'btcompare/diff.rb'

# Library used for comparing two different .torrent files.
module BTCompare

	# Syslog::Logger object for logging
	LOG = Syslog::Logger.new 'btcompare'
end


