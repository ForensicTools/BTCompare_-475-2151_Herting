
module BTCompare
	module Diff

		# Module included by BTCompare::Diff::Diff when 
		# networkize method is run. Overwrites other
		# methods to add jobs to the worker queue.
		module NetworkDiff

			# Creates a carve job in the master's job queue.
			# @param [File] in_file File data is coming from
			# @param [Integer] offset Starting offset
			# @param [Integer] length Length of chunk
			# @param [File] out_file File data is going to
			# @todo Write method
			def carve in_file, offset, length, out_file
				return false
			end

		end
	end
end

