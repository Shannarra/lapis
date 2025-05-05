require_relative '../util'

class Token
  attr_accessor :value, :type, :position

  KEYWORDS = %w[
    extern
    def
    end
  ].freeze

  def initialize(value, type, position)
    @value = value
    @type = type
    @position = position
  end

  def to_s
    "Token[:#{type}](#{position.first}:#{position.last}) = #{value}"
  end

  def transform!
    case type
    when TokenType::Identifier
      return if value.empty?

      if numeric?(value.chars.first) && !numeric?(value)
        eputs "Invalid identifier token \"#{value}\" at #{position}"
      elsif numeric?(value)
        self.type = TokenType::Number
        return self
      end

      self.type = TokenType::Keyword if KEYWORDS.include?(value)
    when TokenType::Number
      self.value = value.to_i
    when TokenType::Operator
      match_operator!
    else
      self
    end

    self
  end

  def numeric?(str)
    str.chars.all? do |x|
      /[0-9]/.match?(x)
    end
  end

  def match_operator!
    case value
    when '+' then self.type = TokenType::Plus
    when '-' then self.type = TokenType::Minus
    when '/' then self.type = TokenType::Slash
    when '*' then self.type = TokenType::Star
    when '(' then self.type = TokenType::OpenParenthesis
    when ')' then self.type = TokenType::CloseParenthesis
    when ',' then self.type = TokenType::Comma
    else
      eputs "Unexpected operator found #{self}"
    end
  end
end

TokenType = enum %w[
  Number
  Whitespace
  Plus
  Minus
  Star
  DoubleStar
  Slash
  OpenParenthesis
  CloseParenthesis
  Bad
  EOF
  Identifier
  Operator
  Keyword
  Comma
]
