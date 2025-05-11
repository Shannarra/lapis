require 'pry'

require_relative 'source/asm'
require_relative 'source/lex'
require_relative 'source/parse'
require_relative 'source/ir/generator'

def main
  generator = IR::Generator

  txt = File.open('examples/print.lp').read
  tokens = Lexer.lex!(txt)
#  tree = Parser.parse! tokens, generator

  tokens2 = Lexer.lex!("1 + 2 * 3 * 4 * 3 - 54 + 8789 / 4")
  tree = Parser.parse! tokens2

  puts tree
  puts tree.eval!
  #  asm = ASM.generate(args)

  #  File.open('lapis.asm', 'w') do |f|
  #    f.write asm
  #  end
end

main
