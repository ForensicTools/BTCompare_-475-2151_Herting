
require 'socket'

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

				# Open server
				@server = TCPServer.open opts[:port]

				Thread.start do 
					client = @server.accept
				end


			end
		end
	end
end

