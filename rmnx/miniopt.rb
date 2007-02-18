require 'shellwords'

class MiniOpt
        OPT_REGEX = /^--?([a-z0-9_-]+)/i

        def self.parse opts, str
                return {}, [] if str.nil?

                opt = {}
                opts.each do |v|
                        if v[-1] == ?=
                                opt[v[0..-2]] = true
                        else
                                opt[v] = false
                        end
                end

                # Split string
                sstr = Shellwords.shellwords(str)

                # Get options
                res = {}
                i = 0
                while i < sstr.length
                        if sstr[i] == '--'
                                i += 1
                                break
                        end
                        if sstr[i] =~ OPT_REGEX
                                if !opt.has_key?($1)
                                        i += 1
                                        next
                                end
                                res[$1] = true
                                if opt[$1]
                                        i += 1
                                        res[$1] = sstr[i]
                                end
                                i += 1
                        else
                                break
                        end
                end
                return [res, sstr[i..-1]]
        end
end

