

module BTCompare

	# Actor that runs a comparison on two different TorrentFiles.
	class Comparison

		# [TorrentFile] File 1 of the comparison
		attr_reader :file_1


		# [TorrentFile] File 2 of the comparison
		attr_reader :file_2


		# Creates a new comparison
		# @param tf1 [TorrentFile,String] First file for comparison
		# @param tf2 [TorrentFile,String] Second file for comparison
		# @raise [UnaccaptableArgType] if argument class is wrong
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
				raise UnacceptableArgType
			end

			
			case tf2
			when String
				@file_2 = TorrentFile.new tf2

			when TorrentFile
				@file_2 = tf2

			else
				raise UnaccaptableArgType
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

