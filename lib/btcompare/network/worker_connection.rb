
module BTCompare
	module Network
		
		# Master Side description of a worker
		class WorkerConnection

			# Creates a master side representation of a worker
			# @param [BTCompare::Network::Master] parent Master that owns this worker
			# @param [TCPSocket] socket Connection to the worker
			def initialize parent, socket
				@parent = parent
				@socket = socket
				
				@thread = Thread.new do

				end
			end


			# Closes down the connection to the worker
			def close
				@thread.stop
				@thread = nil

				@socket.close
				@socket = nil
			end
		end
	end
end

