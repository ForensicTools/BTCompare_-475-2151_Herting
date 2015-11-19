
module BTCompare

	# Holds the result of a comparison. When Result is created its
	# variables are writable. It is strongly encouraged that developers
	# using this class run the method lock on the object as soon as
	# the data has been set in the object.
	class Result

		# Files have same piece count
		attr_accessor :same_piece_count


		# Contains piece ids of differences
		attr_accessor :difference_ids


		# @param parent [Comparison] Parent of the result
		def initialize parent
			@parent = parent
			@same_piece_count = nil
			@difference_ids = nil
		end


		# Locks instance variables for the object
		def lock
			self.instance_eval do 
				undef :same_piece_count=
				undef :difference_ids=
			end
		end
	end
end

