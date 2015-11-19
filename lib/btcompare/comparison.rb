

module BTCompare

	# Actor that runs a comparison on two different TorrentFiles.
	class Comparison


		# Creates a new comparison
		# @param tf1 [TorrentFile,String] First file for comparison
		# @param tf2 [TorrentFile,String] Second file for comparison
		# @raise [RuntimeError] if argument class is wrong
		def initialize tf1, tf2

			@file_1 = nil
			@file_2 = nil
			@result = nil


			case tf1
			when String
				@file_1 = TorrentFile.new tf1

			when TorrentFile
				@file_1 = tf1

			else
				raise "tf1 is wrong type of file"
			end

			
			case tf2
			when String
				@file_2 = TorrentFile.new tf2

			when TorrentFile
				@file_2 = tf2

			else
				raise "tf2 is wrong type of file"
			end
		end


		# Runs the comparison
		# @return [Result] The result of the comparison
		def result
			unless @result == nil then
				return @result
			end

			@result = Result.new self

			@result.same_piece_count = ( @file_1.piece_count == @file_2.piece_count )


			difference_ids = []
			shortest = [ @file_1.piece_count, @file_2.piece_count ].sort.first
			shortest.times do |i|
				unless @file_1.individual_pieces[i] == @file_2.individual_pieces[i] then
					difference_ids.push i
				end
			end
			@result.difference_ids = difference_ids

			@result.lock
			return @result
		end


		# Invalidates cached data
		def invalidate_cache
			@result = nil
		end
	end
end

