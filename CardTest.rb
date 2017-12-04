

def create_deck
	res = []
		def make_suite(suite)
			non_face = [*2..10]
			
			non_face.map! {|x| x.to_s }
			face = ["A","J","Q","K"]
			face.concat(non_face)
			face.map! do |x|
				x+= suite
				# below try making [x.to_s] to make an array with x as a string at index 1
				x = [x, ["|", "\u203E" *8, "|"], ["|#{x}"," "*6, "|"],["|", " "*8, "|"],["|", " "*6, "#{x}|"], ["|", "_"*8, "|"]]
			  end			
			face
		end
	hearts = make_suite("\u2665")
	diamonds = make_suite("\u2666")
	spades = make_suite("\u2660")
	clubs = make_suite("\u2663")
	res.concat(hearts)
	res.concat(diamonds)
	res.concat(spades)
	res.concat(clubs)
	res.shuffle
end

def print_cards(deck)
	deck.each {|card| card[1].each {|x| print x }}
	print "\n"
	deck.each {|card| card[2].each {|x| print x }}
	print "\n"
	deck.each {|card| card[3].each {|x| print x }}
	print "\n"
	deck.each {|card| card[4].each {|x| print x }}
	print "\n"
	deck.each {|card| card[5].each {|x| print x }}
	print "\n"
end


card = [["A\u2665"],[["|", "\u203E"*8, "|"], ["|", "A\u2665", " "*6, "|"],["|"," "*8,"|"],["|", " "*6,"A\u2665","|"],
["|", "_"*8, "|"]]]

card[1][0].each {|x| print x}







