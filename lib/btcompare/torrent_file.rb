

require 'bencode'

module BTCompare
	class TorrentFile

		# Raw data created parsed from the torrent file
		attr_reader :data

		# File name of the torrent file
		attr_reader :filename

		# @param filename [String] Path to torrent file
		def initialize filename
			@filename = filename
			
			@data = BEncode::load(File.open( filename, 'r' ))
			
		end


	end
end

