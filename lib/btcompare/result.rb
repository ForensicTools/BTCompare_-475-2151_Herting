

module BTCompare
	class Result

		# Files have same piece count
		attr_accessor :same_piece_count


		# @param parent [Comparison] Parent of the result
		def initialize parent
			@parent = parent
			@same_piece_count = nil
		end

	end
end

