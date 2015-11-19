

module BTCompare
	
	# Exception thrown when an invalid diff type is selected
	# in BTCompare::Result.diff
	class InvalidDiffType < Exception
	end


	# Exception thrown when an unacceptable arg type has
	# been handed to a method
	class UnacceptableArgType < Exception
	end
end

