

module BTCompare
	module Diff

		# Parent class for Diff objects
		class Diff

			# [String] Working directory for this Diff
			attr_reader :path


			# Parent result that created this Diff
			attr_reader :parent


			# Parent constructor. Causes a workspace to be created.
			# @param parent [BTCompare::Result] the Result object that
			#   created this Diff
			# @param torrent_file_1 [BTCompare::TorrentFile] Torrent File 1
			# @param torrent_file_2 [BTCompare::TorrentFile] Torrent File 2
			def initialize parent, torrent_file_1, torrent_file_2
				@parent = parent
				@torrent_file_1 = torrent_file_1
				@torrent_file_2 = torrent_file_2

				@path = create_tmp_directory
			end


			private

			# Creates a temporary directory for storing diffs
			# @return [String] Path for the directory
			#   created.
			def create_tmp_directory
				path = "tmp.#{Random.new.rand(100000..999999)}"
				Dir.mkdir path
				return path
			end


			# Carves out a chunk of a file.
			# @param in_file [File] File data is coming from
			# @param offset [Integer] Starting offset
			# @param length [Integer] Length of chunk
			# @param out_file [File] File data is going to
			# @return [Boolean] If length == number of bytes written
			def carve in_file, offset, length, out_file
				in_file.seek offset, :SET
				block = in_file.read length
				length == out_file.write( block )
			end
		end
	end
end

