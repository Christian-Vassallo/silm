#!/usr/bin/env nwn-dsl

# VarTable:·
#   type: :list
#     value:·
#       - !nwn-lib.elv.es,2008-12/struct·
#           __struct_id: 0
#               Name: {type: :cexostr, value: color}
#                   Type: {type: :dword, value: 1}
#                       Value: {type: :int, value: 169}
#


for f in ARGV do
  g = need f, :git
  vt = g['VarTable'] || g.add_list('VarTable', [])
  nx = false
  vt.v.each {|e|
    next unless e / 'Name$' == "always_explored"
    nx=true
    break
  }
  next if nx

  vt.v << Gff::Struct.new(0) do |str|
    str.add_cexostr 'Name', 'always_explored'
    str.add_dword 'Type', 1
    str.add_int 'Value', 1
  end
  save g
end
