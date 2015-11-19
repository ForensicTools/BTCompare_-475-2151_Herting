

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

				process
			end

			private

			# Processes the carving of the data
			def process
				log = BTCompare::LOG

				log.info "Beginning to process a direct diff."
				log.info "File 1: #{@torrent_file_1.filename}"
				log.info "File 2: #{@torrent_file_2.filename}"

				log.debug "Opening file 1"
				source_1 = File.open @torrent_file_1.contains, 'rb'

				log.debug "Opening file 2"
				source_2 = File.open @torrent_file_2.contains, 'rb'
				
				log.debug "Making directories"
				Dir.mkdir( File.join( @path, '1' ))
				Dir.mkdir( File.join( @path, '1', 'bin' ))
				Dir.mkdir( File.join( @path, '2' ))
				Dir.mkdir( File.join( @path, '2', 'bin' ))

				bin_files = []

				log.debug "Beginning bin carving"
				@parent.offsets.each do |id, offset|
					chunk_path = File.join( @path, "1", "bin", id.to_s )
					@created_files.push chunk_path
					bin_files.push chunk_path
					File.open( chunk_path, 'w' ) do |file|
						if carve( source_1, offset, @torrent_file_1.piece_length, file ) then
							log.debug "Wrote #{offset} to #{chunk_path}"
						else
							log.warn "Carve has noticed difference in piece_length and written length"
						end
					end

					chunk_path = File.join( @path, "2", "bin", id.to_s )
					@created_files.push chunk_path
					bin_files.push chunk_path
					File.open( chunk_path, 'w' ) do |file|
						if carve( source_2, offset, @torrent_file_2.piece_length, file ) then
							log.debug "Wrote #{offset} to #{chunk_path}"
						else
							log.warn "Carve has noticed difference in piece_length and written length"
						end
					end
				end
				log.debug "Finished with bin carving"

				log.debug "Closing file 1"
				source_1.close
				log.debug "Closing file 2"
				source_2.close


				log.debug "Processing hexdump"

				log.debug "Making Directories"
				Dir.mkdir( File.join( @path, "1", "hex" ))
				Dir.mkdir( File.join( @path, "2", "hex" ))
			
				log.debug "Converting to hexdump"	
				bin_files.each do |bin_file|
					hex_file = bin_file.split( File::SEPARATOR )[2] = "hex"
					hex_file = File.join(hex_file)

					hexdump bin_file, hex_file
				end
				log.debug "Hexdump finished"

				log.info "Direct diff processing finished" 
			end
		end
	end
end

