

module BTCompare
	module Diff

		# Parent class for Diff objects
		class Diff

			# [String] Working directory for this Diff
			attr_reader @path


			# Parent constructor. Causes a workspace to be created.
			def initialize
				@path = create_tmp_directory
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

		end
	end
end

