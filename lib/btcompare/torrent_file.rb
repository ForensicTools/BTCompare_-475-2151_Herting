

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

			@individual_pieces = nil
		end

		# Generates individual pieces if not alreaded found.
		# Caches data once created. Immediately returns array
		# if already generated.
		# @return array of individual SHA1 hashes from torrent file
		def individual_pieces
			unless @individual_pieces == nil then
				return @individual_pieces
			end
			
			@individual_pieces = @data['info']['pieces'].unpack( "H*" ).first.scan /.{40}/m

			return @individual_pieces 
		end


	end
end

