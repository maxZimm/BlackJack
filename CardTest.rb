

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
			  end			
			face
		end
end

card = [["A\u2665"],[["|", "\u203E"*8, "|"], ["|", "A\u2665", " "*6, "|"],["|"," "*8,"|"],["|", " "*6,"A\u2665","|"],
["|", "_"*8, "|"]]]

card[1][0].each {|x| print x}
