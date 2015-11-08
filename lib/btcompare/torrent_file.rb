

require 'bencode'

module BTCompare
	class TorrentFile

		# @param filename [String] Path to torrent file
		def initialize filename
			@filename = filename
			
			@data = BEncode::load(File.open( filename, 'r' ))
			
		end


	end
end

