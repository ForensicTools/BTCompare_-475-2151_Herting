

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


			# Hex dumps a binary file
			# @param in_file [String,File] File the data is coming from
			# @param out_file [String,File] File the hexdump is being written to
			# @param metadata [Hash] Info for user comfort
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
					out_file.puts "-----------------"
					out_file.puts
				end

				# Hexdump
				in_file.rewind
				LINE_SIZE = 16
				internal_offset = 0
				until in_file.eof? do
					word = in_file.read LINE_SIZE

					hex = word.unpack "4H4H4H4H4H4H4H4H"

					ascii = word.gsub( /[[:cntrl:]]/ , '.' )

					line = [ internal_offset.to_s(16), hex, ascii ].flatten
					out_file.printf "%7s: %4s %4s %4s %4s %4s %4s %4s %4s  %16s\n", line
				end


				# Closing files
				in_file.close
				out_file.close
			end
		end
	end
end

