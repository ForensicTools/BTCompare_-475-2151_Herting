

module BTCompare
	module Diff

		# Contains and process a direct diff
		class Direct < Diff

			# Creates a new Direct diff
			# @param parent [BTCompare::Result] Parent of the diff
			# @param torrent_file_1 [BTCompare::TorrentFile] Torrent file 1
			# @param torrent_file_2 [BTCompare::TorrentFile] Torrent file 2
			def initialize parent, torrent_file_1, torrent_file_2
				super parent, torrent_file_1, torrent_file_2

			end

			private

			# Processes the carving of the data
			def process
				source_1 = File.open @torrent_file_1.contains, 'rb'
				source_2 = File.open @torrent_file_2.contains, 'rb'
				
				Dir.mkdir( File.join( @path, '1' ))
				Dir.mkdir( File.join( @path, '1', 'bin' ))
				Dir.mkdir( File.join( @path, '2' ))
				Dir.mkdir( File.join( @path, '2', 'bin' ))

				bin_files = []

				@parent.offsets do |id, offset|
					chunk_path = File.join( @path, "1", "bin", id.to_s )
					@created_files.push chunk_path
					bin_files.push chunk_path
					File.open( chunk_path, 'w' ) do |file|
						carve source_1, offset, @torrent_file_1.piece_length, file
					end

					chunk_path = File.join( @path, "2", "bin", id.to_s )
					@created_files.push chunk_path
					bin_files.push chunk_path
					File.open( chunk_path, 'w' ) do |file|
						carve source_2, offset, @torrent_file_2.piece_length, file
					end
				end

				source_1.close
				source_2.close
			end
		end
	end
end

