
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


		# Lists available types of diffs available
		# to use on these torrent files.
		# @return [Array<Symbol>] :notAvailable If torrent files are
		#   deemed too different to consider for diffing.
		def diff_types
			available = []

			if @parent.file_1.contains_found? and @parent.file_2.contains_found? then
				available.push :direct
			end


			if available.empty? then
				available.push :notAvailable
			end
			return available
		end


		# Gets the byte offset for the pieces that are different.
		# @return [Hash<Integer,Integer>] Piece id => offset within file
		def offsets
			to_return = {}
			piece_length = @parent.file_1.piece_length
			@difference_ids.each do |id|
				to_return[id] = id * piece_length
			end
			return to_return
		end
	end
end

