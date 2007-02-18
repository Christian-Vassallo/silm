# DMFI language scripts ported for
# performance and flexibility reasons

require 'rmnx'

class DMFILanguage
	def t str
		return str
	end
end

class SubstitutionLanguage < DMFILanguage
	def lang; {}; end

	def t text
		out = ""
		inEmote = false
		inClear = false
		inSingleClear = false
		# Behaviour:
		# If we are inside * *, then its a emote and is to be written in cleartext
		#   Inside * *, no _ cleartext markers are parsed
		# If we are inside _ _, then its a cleartext passage, and the markers are stripped
		#   Inside _ _, no * emote markers are parsed
		for i in 0...text.size do
			a = text[i, 1]

			if "_" == a
				inClear = !inClear if !inEmote
				next
			end
			if "*" == a
				inEmote = !inEmote if !inClear
			end
			
			# We are in Emote
			if inEmote || inClear || inSingleClear
				out += a
				next
			end

			# We are neither in emote nor cleartext
			out += lang[a].nil? ? a : lang[a]
		end
		out
	end
end

class ElvenLanguage < SubstitutionLanguage
	def lang; { 'K' => 'N', 'V' => 'El', 'v' => 'el', 'k' => 'n', 'L' => 'C', 'W' => 'Am', 'w' => 'am', 'l' => 'c', 'A' => 'Il', 'a' => 'il', 'X' => '\'', 'M' => 'S', 'B' => 'F', 'x' => '\'', 'm' => 's', 'b' => 'f', 'Y' => 'A', 'N' => 'L', 'y' => 'a', 'n' => 'l', 'C' => 'Ny', 'c' => 'ny', 'Z' => 'J', 'O' => 'E', 'D' => 'W', 'z' => 'j', 'o' => 'e', 'd' => 'w', 'E' => 'A', 'P' => 'Ty', 'p'=> 'ty', 'e' => 'a', 'Q' => 'H', 'F' => 'O', 'q' => 'h', 'f' => 'o', 'R' => 'M', 'G' =>'V', 'r' => 'm', 'g' => 'v', 'S' => 'La', 's' => 'la', 'H' => 'Ir', 'h' => 'ir', 'I' => 'E', 'T' => 'An', 't' => 'an', 'i' => 'e', 'U' => 'Y', 'u' => 'y', 'J' =>'Qu', 'j' => 'qu' }; end
end
class DrowLanguage < SubstitutionLanguage
	def lang
		{
		'K' => 'Go', 'V' => 'Er', 'v' => 'el', 'k' => 'go', 'L' => 'C',
		'W' => 'Ky', 'w' => 'ky', 'l' => 'c', 'A' => 'Il', 'a' => 'il',
		'X' => '\'', 'M' => 'Li', 'B' => 'F', 'x' => '\'', 'm' => 'li',
		'b' => 'f', 'Y' => 'A', 'N' => 'L', 'y' => 'a', 'n' => 'sl',
		'C' => 'St', 'c' => 'st', 'Z' => 'P\'', 'O' => 'E', 'D' => 'S',
		'z' => 'p\'', 'o' => 'e', 'd' => 'w', 'E' => 'A', 'P' => 'Ty',
		'p' => 'ty', 'e' => 'a', 'Q' => 'R', 'F' => 'o', 'q' => 'rs',
		'f' => 'o', 'R' => 'M', 'G' => 'V', 'r' => 'm', 'g' => 'v',
		'S' => 'La','s' => 'la', 'H' => 'Ir', 'h' => 'ir', 'I' => 'E',
		'T' => 'An', 't' => 'an', 'i' => 'e\'', 'U' => 'Y', 'u' => 'y',
		'J' => 'Vi', 'j' =>'si'
		}
	end
end
class DraconicLanguage < SubstitutionLanguage
	
	def initialize
		@lex = {}
		a = IO.readlines("lex_draconic.txt")
		a.each do |l|
			if l !~ /^([^ ]+)\t(.+)$/
				puts "Warning: ignoring line %s" % l
				next
			end
			@lex[$1.strip.downcase] = $2.strip.downcase
		end
	end

   def lang; {
                     'A'=>'T', 'a'=>'t', 'B'=>'G', 'b'=>'g',
                     'C'=>'L', 'c'=>'l', 'D'=>'V', 'd'=>'v',
                     'E'=>'R', 'e'=>'r', 'F'=>'C', 'f'=>'c',
                     'G'=>'O', 'g'=>'o', 'H'=>'U', 'h'=>'u',
                     'I'=>'I', 'i'=>'i', 'J'=>'F', 'j'=>'f',
                     'K'=>'Y', 'k'=>'y', 'L'=>'N', 'l'=>'n',
                     'M'=>'J', 'm'=>'j', 'N'=>'A', 'n'=>'a',
                     'O'=>'X', 'o'=>'x', 'P'=>'P', 'p'=>'p',
                     'Q'=>'', 'q'=>'', 'R'=>'e', 'r'=>'e',
                     'S'=>'S', 's'=>'s', 'T'=>'H', 't'=>'h',
                     'U'=>'K', 'u'=>'k', 'V'=>'W', 'v'=>'w',
                     'W'=>'M', 'w'=>'m', 'X'=>'B', 'x'=>'b',
                     'Y'=>'Z', 'y'=>'z', 'Z'=>'D', 'z'=>'d',
#                     '�=>'Kr', ''=>'kr', '�=>'Xr', '�=>'xr',
#                     '�=>'Tr', '�=>'tr'
                     }; end
	
	def t t
		words = t.split(" ")
		out = []
		words.each do |w|
			if @lex[w].nil?
				if w == ""
					out << " "
				else
					out << a = super(w)
				end
			else
				o = @lex[w]
				o[0,1] = o[0,1].upcase if @lex[w][0,1] =~ /[A-Z]/
				out << o
			end
		end
		return out.join(" ")
	end
	
end
class InfernalLanguage < SubstitutionLanguage
	def lang; { 'K' => 'G', 'V' => 'R', 'v' => 'r', 'k' => 'g', 'L' => 'M', 'W' => '\'', 'w' => '\'', 'l' => 'm', 'A' => 'O', 'a' => 'o', 'X' => 'K', 'M' => 'Z', 'B' => 'C', 'x' => 'k', 'm' => 'z', 'b' => 'c', 'Y' => 'I', 'N' => 'R', 'y' => 'i', 'n' => 'r','C' => 'R', 'c' => 'r', 'Z' => 'G', 'O' => 'Y', 'D' => 'J', 'z' => 'g', 'o' => 'y', 'd' => 'j', 'E' => 'A', 'P' => 'K', 'p' => 'k', 'e' => 'a', 'Q' => 'R', 'F' => 'V', 'q' => 'r', 'f' => 'v', 'R' => 'N', 'G' => 'K', 'r' => 'n', 'g' => 'k', 'S' => 'K', 's' => 'k', 'H' => 'R', 'h' => 'r', 'I' => 'Y', 'T' => 'D', 't' => 'd', 'i' => 'y', 'U' => '\'', 'u' => '\'', 'J' => 'Z', 'j' => 'z' }; end
end
class AbyssalLanguage < SubstitutionLanguage
	def lang; { 'V' => 'Ts', 'v' => 'ts', 'k' => 'b', 'K' => 'B', 'w' => 'b', 'l' => 'l', 'A' => 'OO', 'a' => 'oo', 'W' => 'B', 'L' => 'L', 'X' => 'Bb', 'x' => 'bb', 'm' => 'p', 'b' => 'n', 'M' => 'P', 'B' => 'N', 'Y' => 'Ee', 'y' => 'ee', 'n' => 't', 'c' =>'m', 'N' => 'T', 'C' => 'M', 'z' => 't', 'o' => 'e', 'd' => 'g', 'Z' => 'T', 'O' => 'E', 'D' => 'G', 'p' => 'b', 'e' => 'a', 'P' =>'B', 'E' => 'A', 'Q' => 'Ch', 'q' => 'ch', 'f' => 'k', 'F' => 'K', 'r' => 'n', 'g' => 's', 'R' => 'N', 'G' => 'S', 's' => 'm', 'h' => 'd', 'S' => 'M', 'H' => 'D', 't' => 'g', 'I' => 'OO', 'i' => 'oo', 'T' => 'G', 'U' => 'Ae', 'u' => 'ae', 'j' => 'h', 'J' => 'H' }; end
end
class CelestialLanguage < SubstitutionLanguage
	def lang; { 'V' => 'J', 'K' => 'X', 'v' => 'j', 'k' => 'x', 'W' => 'F', 'L' => 'H', 'A' => 'A', 'w' => 'f', 'l' => 'h','a' => 'a', 'X' => 'G', 'M' => 'S', 'B' => 'P', 'x' => 'g', 'm' => 's', 'b' => 'p', 'Y' => 'Z', 'N' => 'C', 'C' => 'V', 'y' => 'z', 'n' => 'c', 'c' => 'v', 'Z' => 'K', 'O' => 'U', 'D' => 'T', 'z' => 'k', 'o' => 'u', 'd' => 't', 'P' => 'Q', 'E' => 'El', 'p' => 'q', 'e' => 'el', 'Q' => 'D', 'F' => 'B', 'q' => 'd', 'f' => 'b', 'R' => 'N', 'G' => 'W', 'r' => 'n', 'g' => 'w', 'S' => 'L', 'H' => 'R', 's' => 'l', 'h' => 'r', 'T' => 'Y', 'I' => 'I', 't' => 'y', 'i' => 'i', 'U' => 'O', 'J' => 'M', 'u' => 'o', 'j' => 'm' }; end
end
class GoblinLanguage < SubstitutionLanguage
	def lang; { 'V' => '', 'K' => 'G', 'v' => '', 'k' => 'g', 'W' => '\'', 'L' => 'M', 'A' => 'U', 'w' => '\'', 'l' => 'm', 'a' => 'u', 'X' => '', 'M' => 'S', 'B' => 'P', 'x' => '', 'm' => 's', 'b' => 'p', 'Y' => 'O', 'N' => '', 'C' => '', 'y' => 'o', 'n' => '', 'c' => '', 'Z' => 'W', 'O' => 'U', 'D' => 'T', 'z' => 'w', 'o' => 'u', 'd' => 't', 'P' => 'B', 'E' => '\'', 'p' => 'b', 'e' => '\'', 'Q' => '', 'F' => 'V', 'q' => '', 'f' => 'v', 'R' => 'N', 'G' => 'K', 'r' => 'n', 'g' => 'k', 'S' => 'K', 'H' => 'R', 's' => 'k','h' => 'r', 'T' => 'D', 'I' => 'O', 't' => 'd', 'i' => 'o', 'U' => 'U', 'J' => 'Z', 'u' => 'u', 'j' => 'z' }; end
end
class DwarfLanguage < SubstitutionLanguage
	def lang; { 'V' => 'G', 'K' => 'G', 'v' => 'g', 'k' => 'g', 'L' => 'N', 'W' => 'Zh', 'w' => 'zh', 'l' => 'n', 'A' => 'Az', 'a' => 'az', 'X' => 'Q', 'M' => 'L', 'x' => 'q', 'm' => 'l', 'B' => 'Po', 'b' => 'po', 'Y' => 'O', 'N' => 'R', 'y' => 'o', 'n' => 'r', 'C'=> 'Zi', 'c' => 'zi', 'Z' => 'J', 'D' => 'T', 'z' => 'j', 'O' => 'Ur', 'o' => 'ur', 'd' => 't', 'E' => 'A', 'P' => 'Rh', 'p'=> 'rh', 'e' => 'a', 'Q' => 'K', 'q' => 'k', 'F' => 'Wa', 'f' => 'wa', 'R' => 'H', 'G' => 'K', 'r' => 'h', 'g' => 'k', 'H' => '\'', 'S' => 'Th', 's' => 'th', 'h' => '\'', 'T' => 'K', 'I' => 'A', 't' => 'k', 'i' => 'a', 'U' => '\'', 'u' => '\'', 'J' => 'Dr', 'j' => 'dr' }; end
end
class GnomeLanguage < SubstitutionLanguage
	def lang; { 'V' => 'J', 'K' => 'G', 'v' => 'j', 'k' => 'g', 'W' => 'F', 'L' => 'M', 'A' => 'Y', 'w' => 'f', 'l' => 'm', 'a'=> 'y', 'X' => 'Q', 'M' => 'S', 'B' => 'P', 'x' => 'q', 'm' => 's', 'b' => 'p', 'Y' => 'O', 'N' => 'H', 'C' => 'L', 'y' => 'o', 'n' => 'h', 'c' => 'l', 'Z' => 'W', 'O' => 'U', 'D' => 'T', 'z' => 'w', 'o' => 'u', 'd' => 't', 'P' => 'B', 'E' => 'A', 'p' => 'b', 'e' => 'a', 'Q' => 'X', 'F' => 'V', 'q' => 'x', 'f' => 'v', 'R' => 'N', 'G' => 'K', 'r' => 'n', 'g' => 'k', 'S' => 'C', 'H' => 'R', 's' =>'c', 'h' => 'r', 'T' => 'D', 'I' => 'E', 't' => 'd', 'i' => 'e', 'U' => 'I', 'J' => 'Z', 'u' => 'i', 'j' => 'z' }; end
end
class HalflingLanguage < SubstitutionLanguage
	def lang; { 'V' => 'F', 'K' => 'G', 'v' => 'f', 'k' => 'g', 'W' => 'Z', 'L' => 'C', 'A' => 'E', 'w' => 'z', 'l' => 'c', 'a' => 'e', 'X' => 'Q', 'M' => 'L', 'B' => 'P', 'x' => 'q', 'm' => 'l', 'b' => 'p', 'Y' => 'A', 'N' => 'R', 'C' => 'S', 'y' => 'a', 'n' => 'r', 'c' => 's', 'Z' => 'J', 'O' => 'Y', 'D' => 'T', 'z' => 'j', 'o' => 'y', 'd' => 't', 'P' => 'B', 'E' => 'I', 'p' => 'b', 'e' => 'i', 'Q' => 'X', 'F' => 'W', 'q' => 'x', 'f' => 'w', 'R' => 'H', 'G' => 'K', 'r' => 'h', 'g' => 'k', 'S' => 'M', 'H' => 'N', 's'=> 'm', 'h' => 'n', 'T' => 'D', 'I' => 'U', 't' => 'd', 'i' => 'u', 'U' => 'O', 'J' => 'V', 'u' => 'o', 'j' => 'v' }; end
end
class OrcLanguage < SubstitutionLanguage
	def lang; { 'V' => 'G', 'K' => 'G', 'v' => 'g', 'k' => 'g', 'W' => 'R', 'L' => 'H', 'w' => 'r', 'l' => 'h', 'A' => 'Ha', 'a' => 'ha', 'X' => 'R', 'M' => 'R', 'B' => 'P', 'x' => 'r', 'm' => 'r', 'b' => 'p', 'Y' => '\'', 'N' => 'K', 'C' => 'Z', 'y' => '\'', 'n' => 'k', 'c' => 'z', 'Z' => 'M', 'O' => 'U', 'D' => 'T', 'z' => 'm', 'o' => 'u', 'd' => 't', 'P' => 'B', 'E' => 'O', 'p' => 'b', 'e'=> 'o', 'Q' => 'K', 'F' => '', 'q' => 'k', 'f' => '', 'R' => 'H', 'G' => 'K', 'r' => 'h', 'g' => 'k', 'S' => 'G', 'H' => 'R', 's' =>'g', 'h' => 'r', 'T' => 'N', 'I' => 'A', 't' => 'n', 'i' => 'a', 'U' => '', 'J' => 'M', 'u' => '', 'j' => 'm' }; end
end

class ThievesCantLanguage < DMFILanguage
	def t txt
		return "" unless txt.size > 1
		return case txt[0,1]
		when /a/i
			"*bedeckt die Augen*"
		when /b/i
			"*verzieht den Mund*"
		when /c/i
			"*hustet*"
		when /d/i
			"*runzelt die Stirn*"
		when /e/i
			"*starrt auf den Boden*"
		when /f/i
			"*zieht eine Augenbraue hoch*"
		when /g/i
			"*sieht nach oben*"
		when /h/i
			"*schaut nachdenklich drein*"
		when /i/i
			"*raekelt sich*"
		when /j/i
			"*reibt sich das Kinn*"
		when /k/i
			"*zieht an einem Ohr*"
		when /l/i
			"*sieht sich um*"
		when /m/i
			"*mmm hmm*"
		when /n/i
			"*nickt*"
		when /o/i
			"*grinst*"
		when /p/i
			"*laechelt*"
		when /q/i
			"*schaudert*"
		when /r/i
			"*rollt mit den Augen*"
		when /s/i
			"*kratzt sich an der Nase*"
		when /t/i
			"*dreht sich ein wenig nach links*"
		when /u/i
			"*betrachtet die Umgebung*"
		when /v/i
			"*faehrt sich mit der Hand durch das Haar*"
		when /w/i
			"*winkt*"
		when /x/i
			"*streckt sich*"
		when /y/i
			"*gaehnt*"
		when /z/i
			"*zuckt mit den Schultern*"
		else
			""
		end
	end

end

class AnimalLanguage < DMFILanguage
	def t t
		return "'" * t.size
	end
end
class LeetLanguage < DMFILanguage
	def t t
		return t.downcase.gsub("e", "3").gsub("a", "4").gsub("s", "5").gsub("t", "7").gsub("l", "1").gsub(" ", "_")
	end
end

class DMLanguage < DMFILanguage
	def t t
 		return "GRR#{"A" * t.size}GH!!!"
	end
end

class DMFIVoiceTranslateCommand < RMNX::Command
	@@lang = {
		"elven" => ElvenLanguage.new,
		"drow" => DrowLanguage.new,
		"draconic" => DraconicLanguage.new,
		"infernal" => InfernalLanguage.new,
		"abyssal" => AbyssalLanguage.new,
		"celestial" => CelestialLanguage.new,
		"goblin" => GoblinLanguage.new,
		"dwarf" => DwarfLanguage.new,
		"gnome" => GnomeLanguage.new,
		"halfling" => HalflingLanguage.new,
		"orc" => OrcLanguage.new,
		"thievescant" => ThievesCantLanguage.new,
		"animal" => AnimalLanguage.new,
		"leet" => LeetLanguage.new,
		"dm" => DMLanguage.new
	}

	def initialize(rmnx)
		super(rmnx, "dmfivoice", proc {|lang, text| dmfi_translate(lang, text)})
	end

	def dmfi_translate(lang, text)
		t = text.gsub(/[\]\}]+$/, "").gsub(/^[\[\{]+/,"")
		if @@lang[lang].nil?
			raise "language not registered"
		end
		return @@lang[lang].t(t)
	end
end
