#!/usr/bin/env ruby

require "optparse"
require "rainbow/ext/string"
require_relative "lib/btcompare.rb"

BITS_PER_HASH = 160

AVAILABLE_ACTIONS = [
	:info,
	:diff
]


options = {}
OptionParser.new do |opts|
	opts.banner = "Usage: btcompare.rb [options]"

	opts.on '--file-1 NAME', 'First Torrent File (Required)' do |file_1|
		options[:file_1] = file_1

		unless File.exist? file_1 then
			puts "#{file_1} not found."
			exit 2
		end
	end

	opts.on '--file-2 NAME', "Second Torrent File" do |file_2|
		options[:file_2] = file_2

		unless File.exist? file_2 then
			puts "#{file_2} not found."
			exit 2
		end
	end

	opts.on( 
					'--action NAME',
					AVAILABLE_ACTIONS, 
					"Select an action to perform (Required)", 
					"  (#{AVAILABLE_ACTIONS.join( ', ' )})"
					) do |action|
		options[:action] = action
	end

	opts.on '-h', '--help', "Show this help message" do |h|
		puts opts
		exit
	end

end.parse!

# Show a basic help error
def show_error
	puts "Use -h for help"
	exit 1
end

# Process --action info
def print_info options
	path = options[:file_1]

	print "Viewing file: ".color :cyan
	puts path.color :magenta

	tf = BTCompare::TorrentFile.new path

	data = tf.data

	print "File contains: ".color :cyan
	puts tf.contains.color :magenta

	print "Length of file: ".color :cyan
	puts data['info']['length'].to_s.color :magenta

	print "Piece Length: ".color :cyan
	puts data['info']['piece length'].to_s.color :magenta

	calc_pieces = ( data['info']['length'] / data['info']['piece length'] ).ceil
	pieces = tf.individual_pieces.length
	calc_hash_len = calc_pieces * BITS_PER_HASH / 8
	hash_len = data['info']['pieces'].length

	print "Calculated piece count: ".color :cyan
	puts calc_pieces.to_s.color :magenta

	print "Expected piece count: ".color :cyan
	puts pieces.to_s.color :magenta

	print "Calculated piece count equals expected: ".color :cyan
	puts "true".color( :green ) if calc_pieces == pieces
	puts "false".color( :red ) unless calc_pieces == pieces

	print "Calculated length of hash: ".color :cyan
	puts calc_hash_len.to_s.color :magenta

	print "Length of hash: ".color :cyan
	puts ( hash_len ).to_s.color :magenta

	print "Length and expected length match: ".color :cyan
	puts "true".color( :green ) if hash_len == calc_hash_len
	puts "false".color( :red ) unless hash_len == calc_hash_len

	print "Confirm all pieces are proper length: ".color :cyan
	pass = true
	tf.individual_pieces.each do |p|
		pass = false unless p.length == 40
	end
	puts "pass".color( :green ) if pass
	puts "fail".color( :red ) unless pass

	print "Contains found: ".color :cyan
	puts "true".color( :green ) if tf.contains_found?
	puts "false".color( :red ) unless tf.contains_found?
end


def compare_direct options
	tf1 = options[:file_1]
	tf2 = options[:file_2]

	print "Comparing ".color :cyan
	print tf1.color :magenta
	print " to ".color :cyan
	puts tf2.color :magenta

	tf1 = BTCompare::TorrentFile.new tf1
	tf2 = BTCompare::TorrentFile.new tf2
	comp = BTCompare::Comparison.new tf1, tf2
	result = comp.result

	print "Pieces of ".color :cyan
	print tf1.filename.color :magenta
	print ": ".color :cyan
	puts tf1.piece_count.to_s.color :magenta

	print "Pieces of ".color :cyan
	print tf2.filename.color :magenta
	print ": ".color :cyan
	puts tf2.piece_count.to_s.color :magenta

	print "Files have the same number of pieces: ".color :cyan
	puts "true".color( :green ) if result.same_piece_count
	puts "false".color( :red ) unless result.same_piece_count

	print "Number of pieces different: ".color :cyan
	puts result.difference_ids.length.to_s.color :magenta

	print "Contains found for ".color :cyan
	print tf1.filename.color :cyan
	print ": ".color :cyan
	puts "true".color( :green ) if tf1.contains_found?
	puts "false".color( :red ) unless tf1.contains_found?

	print "Contains found for ".color :cyan
	print tf2.filename.color :cyan
	print ": ".color :cyan
	puts "true".color( :green ) if tf2.contains_found?
	puts "false".color( :red ) unless tf2.contains_found?

	print "Diff types available: ".color :cyan
	puts result.diff_types.join(', ').color :green unless result.diff_types.include? :notAvailable
	puts result.diff_types.join(', ').color :red if result.diff_types.include? :notAvailable


	if result.diff_types.include? :direct then
		print "Creating Direct Diff... ".color :cyan
		diff = result.diff :direct
		puts "DONE".color :green
		`meld #{diff.path}/1/hex #{diff.path}/2/hex`
	end
end

# Check for valid --action
unless options.has_key? :action then
	puts "--action is required"
	show_error
end

# Check for 'valid' --file-1
unless options.has_key? :file_1 then
	puts "--file-1 is required"
	show_error
end


if ( options[:action] == :diff ) and ( not options.has_key? :file_2 ) then
	puts "--file-2 is required for this action"
	show_error
end


case options[:action]
when :info
	print_info options

when :diff
	compare_direct options

end



