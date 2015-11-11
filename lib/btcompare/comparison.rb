

module BTCompare
	class Comparison


		# Creates a new comparison
		# @param tf1 [TorrentFile,String] First file for comparison
		# @param tf2 [TorrentFile,String] Second file for comparison
		# @raise [RuntimeError] if argument class is wrong
		def initialize tf1, tf2

			@file_1 = nil
			@file_2 = nil


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

	end
end

