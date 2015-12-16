
require 'socket'
require 'thread'

module BTCompare
	module Network

		# Describes the Master Server
		class Master

			# Array of worker nodes.
			attr_reader :workers

			# Creates a new Master Server
			# @option opts [Integer] :port (5643) Port to listen on
			def initialize opts = {}
				# Set defaults
				opts[:port] = 5643 unless opts.has_key? :port

				# Define default instance variables
				@workers = []
				@queue = Queue.new

				# Open server
				@server = TCPServer.open opts[:port]

				# Create thread to accept connections
				Thread.start do 
					client = @server.accept
					workerConnection = WorkerConnection.new self, client
					@workers.push workerConnection
				end
			end


			# Close down the server
			def close
				@workers.each do |x|
					x.close
					@workers.delete x
				end

				@server.close
				@server = nil
			end
		end
	end
end

