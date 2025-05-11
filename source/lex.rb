require_relative 'token'

class Lexer
  attr_reader :errors, :ip, :col, :row, :text

  OPERATORS = %w[( ) + - / * , =].freeze

  WHITESPACE = [' ', "\n", "\t"].freeze

  def initialize(text)
    @text = text
    @errors = []
    @ip = 0
    @col = 0
    @row = 1
  end

  def self.lex!(text)
    new(text).lex
  end

  def lex
    tokens = []

    word = ''
    start_pos = [1, 0]

    while current
      word += current

      if OPERATORS.include? current
        # If // -> skip til EOL and go next iteration
        if current == '/' && next_is?('/')
          advance while current != "\n"
          word = ''
          next
        end

        unless word[..-2].empty?
          tokens << new_token(word[..-2], TokenType::Identifier, start_pos)
          start_pos = [row, col]
          word = ''
          next
        end

        tokens << new_token(current, TokenType::Operator, start_pos)
        word = ''
        advance
        start_pos = [row, col]
      else
        unless nonempty?
          tokens << new_token(word.strip, TokenType::Identifier, start_pos) unless WHITESPACE.include?(word)
          start_pos = [row, col]
          word = ''
        end

        advance
      end
    end
    tokens << new_token(word, TokenType::Identifier)

    tokens << new_token(current, TokenType::EOF)

    tokens.map(&:transform!).compact
  end

  def new_token(word, type, pos = nil)
    Token.new(word, type, pos || position)
  end

  def current
    @text[@ip]
  end

  def next_is?(chr)
    @text[@ip + 1] == chr
  end

  def surrounded_by?(chr)
    @text[@ip - 1] == chr ||
      @text[@ip + 1] == chr
  end

  def nonempty?
    current && !WHITESPACE.include?(current)
  end

  def advance
    @ip += 1
    @col += 1

    return unless current == "\n"

    @col = 0
    @row += 1
  end

  def position
    [@row, @col]
  end
end
