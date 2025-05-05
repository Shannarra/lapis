require 'pry'

require_relative 'source/asm'
require_relative 'source/lex'

def main
  txt = File.open('examples/print.lp').read
  tokens = Lexer.lex!(txt)

  puts tokens

  #  asm = ASM.generate(args)

  #  File.open('lapis.asm', 'w') do |f|
  #    f.write asm
  #  end
end

main
