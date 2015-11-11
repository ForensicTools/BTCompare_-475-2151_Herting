

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

			@individual_peices = nil
		end

		# Generates individual peices if not alreaded found.
		# Caches data once created. Immediately returns array
		# if already generated.
		# @return array of individual SHA1 hashes from torrent file
		def individual_peices
			unless @individual_peices == nil then
				return @individual_peices
			end
			
			@individual_peices = @data['info']['peices'].scan /.{20}/

			return @individual_peices 
		end


	end
end

