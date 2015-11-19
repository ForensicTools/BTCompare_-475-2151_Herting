

module BTCompare
	module Diff

		# Parent class for Diff objects
		class Diff

			private

			# Creates a temporary directory for storing diffs
			# @return [String] Path for the directory
			#   created.
			def create_tmp_directory
				path = "tmp.#{Random.new.rand(100000..999999)}"
				Dir.mkdir path
				return path
			end

		end
	end
end

