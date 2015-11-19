

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
				@parent.offsets do |id, offset|

				end
			end
		end
	end
end

