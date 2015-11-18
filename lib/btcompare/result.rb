

module BTCompare
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

	end
end

