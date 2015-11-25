

require 'bencode'

module BTCompare

	# Holds data about an individual torrent file.
	class TorrentFile

		# Raw data created parsed from the torrent file
		attr_reader :data


		# File name of the torrent file
		attr_reader :filename


		# Contains the filenames of the contents of the torrent.
		attr_reader :contains


		# [Integer] Contains the length of a piece
		attr_reader :piece_length


		# Is this torrent file a multi file torrent
		attr_reader :multi_file


		# @param filename [String] Path to torrent file
		# @raise [UnsupportedFeature] Multi file torrents are not supported 
		#   yet. Come Back Later.
		def initialize filename
			@filename = filename
			
			@data = BEncode::load(File.open( filename, 'r' ))

			if @data['info'].has_key? 'files' then
				@multi_file = true
				raise UnsupportedFeature
				exit 1
			else
				@multi_file = false
			end

			@contains = @data['info']['name']
			@piece_length = @data['info']['piece length']
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

		
		# Created based on ( length / piece length ).ceil
		# @return [Fixnum] Number of peices
		def piece_count 
			return ( @data['info']['length'] / @data['info']['piece length'] ).ceil
		end


		# Invalidates cached data
		def invalidate_cache
			@individual_pieces = nil
		end


		# Checks to see if contains is found
		# in current directory.
		# @return [Boolean] True if found.
		def contains_found?
			File.exist? @contains
		end
	end
end

