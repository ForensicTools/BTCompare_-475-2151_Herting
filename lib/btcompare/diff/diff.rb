

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
				@created_files = []
			end


			# Networkize the diff
			# @param [BTCompare::Network::Master] master Master object
			def networkize master
				@master = master
				include NetworkDiff
			end


			private

			# Creates a temporary directory for storing diffs
			# @return [String] Path for the directory
			#   created.
			def create_tmp_directory
				path = random_name
				while File.exists? path do 
					path = random_name
				end

				Dir.mkdir path
				return path
			end


			# Generates a random name for a file or directory
			# @return [String] random name
			def random_name
				sprintf "tmp.%06d", Random.new.rand(0..999999)
			end


			# Carves out a chunk of a file.
			# @param in_file [File, String] File data is coming from
			# @param offset [Integer] Starting offset
			# @param length [Integer] Length of chunk
			# @param out_file [File, String] File data is going to
			# @return [Boolean] If length == number of bytes written
			# @raise [UnacceptableArgType] If an arg type is not acceptable 
			def carve in_file, offset, length, out_file
				close_in_file = false
				close_out_file = false
				# Opening in_file 
				case in_file
				when String
					in_file = File.open in_file, 'rb'
					close_in_file = true
				when File
				else
					raise UnacceptableArgType
				end

				# Opening out_file
				case out_file
				when String
					out_file = File.open out_file, 'w'
					close_out_file = true
				when File
				else
					raise UnacceptableArgType
				end

				in_file.seek offset, :SET
				block = in_file.read length
				to_return = length == out_file.write( block )

				if close_in_file then
					in_file.close
				end

				if close_out_file then
					out_file.close
				end

				return to_return
			end


			# Hex dumps a binary file
			# @param in_file [String,File] File the data is coming from
			# @param out_file [String,File] File the hexdump is being written to
			# @param metadata [Hash<String, String>] Info for user comfort
			# @raise [UnacceptableArgType] If an arg type is not acceptable 
			def hexdump in_file, out_file, metadata=nil
				# Opening in_file
				case in_file
				when String
					in_file = File.open in_file, 'rb'
				when File
				else
					raise UnacceptableArgType
				end

				# Opening out_file
				case out_file
				when String
					out_file = File.open out_file, 'w'
				when File
				else
					raise UnacceptableArgType
				end

				# Write out metadata
				unless metadata == nil then
					metadata.each do |key, value|
						out_file.puts "#{key}: #{value}"
					end

					out_file.puts
					out_file.puts "-" * 63
					out_file.puts
				end

				# Hexdump
				in_file.rewind
				line_size = 16
				internal_offset = 0
				until in_file.eof? do
					word = in_file.read line_size

					hex = word.unpack "H4" * ( line_size / 2 )

					ascii = word.gsub( /[^\x20-\x7E]/ , '.' )

					line = [ internal_offset.to_s(16), hex, ascii ].flatten
					out_file.printf("%5s: %4s %4s %4s %4s %4s %4s %4s %4s %16s\n", 
													line[0],
													line[1],
													line[2],
													line[3],
													line[4],
													line[5],
													line[6],
													line[7],
													line[8],
													line[9]
												 )
					internal_offset += line_size
				end


				# Closing files
				in_file.close
				out_file.close
			end
		end
	end
end

