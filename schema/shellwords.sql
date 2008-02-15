create function shellwords_as_array(varchar) returns varchar[] as
$_$
	line = args[0].lstrip
	words = []
	until line.empty?
		field = ''
		loop do
			if line.sub!(/\A"(([^"\\]|\\.)*)"/, '') then
				snippet = $1.gsub(/\\(.)/, '\1')
			elsif line =~ /\A"/ then
				raise ArgumentError, "Unmatched double quote: #{line}"
			elsif line.sub!(/\A'([^']*)'/, '') then
				snippet = $1
			elsif line =~ /\A'/ then
				raise ArgumentError, "Unmatched single quote: #{line}"
			elsif line.sub!(/\A\\(.)?/, '') then
				snippet = $1 || '\\'
			elsif line.sub!(/\A([^\s\\'"]+)/, '') then
				snippet = $1
			else
				line.lstrip!
				break
			end
			field.concat(snippet)
		end
		words.push(field)
	end
	words
$_$
language 'plruby';

create function shellwords_as_table(varchar) returns setof varchar as
$_$
	
	i = PL.context || 1
	vl = shellwords_as_array(args[0])[i - 1]
	PL.context = i + 1
	vl
$_$
language 'plruby';
