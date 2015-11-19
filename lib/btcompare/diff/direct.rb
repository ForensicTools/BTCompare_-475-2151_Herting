

module BTCompare
	module Diff

		# Contains and process a direct diff
		class Direct < Diff

			# Creates a new Direct diff
			# @param parent [BTCompare::Result] Parent of the diff
			def initialize parent
				super parent

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

