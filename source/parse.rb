class Parser
  attr_accessor :tokens

  class ParserItem
    attr_accessor :type, :token, :children

    def initialize(type, token, children = [])
      @type = type
      @token = token
      @children = children
    end

    def to_s(indent = "\t", is_last: true)
      marker = is_last ? '└───' : '├───'

      last_child = children.last

      str = "#{indent}#{marker}#{type}"
      str += " #{token.value}\n" unless children.nil?

      indent += is_last ? '    ' : '│   '
      children.each do |child|
        str += child.to_s(indent, is_last: child == last_child)
      end

      str
    end

    def eval!
      if type == ParserItemType::Atom
        token.value.to_i
      else
        lhs = children.first.eval!
        rhs = children.last.eval!

        puts IR::Generator.arithmetic_operation(token, lhs, rhs)
        exec_operator(token.value, [lhs, rhs])
      end
    end

    def exec_operator(operator, operands)
      case operator
      when '+', '-', '/', '*'
        operands.reduce(operator.to_sym)
      else
        eputs("Can't handle operator #{operator}")
      end
    end
  end

  ParserItemType = enum %w[
    Atom
    Operator
  ]

  def initialize(tokens)
    @tokens = tokens
    @ip = 0
  end

  def self.parse!(tokens)
    new(tokens).parse
  end

  def parse
    construct_expression_by_binding_power
  end

  def construct_expression_by_binding_power(base_binding_power = 0)
    lhs = if current.type == TokenType::Number
            ParserItem.new(ParserItemType::Atom, current)
          # elsif current.type == TokenType::Identifier
          #   todo! if peek(-1).type == TokenType::Keyword

          #   if peek.type == TokenType::Equals
          #     advance
          #     children = construct_expression_by_binding_power
          #     ParserItem.new(ParserItemType::Assignment, current, children)

          #   end
          else
            eputs("Bad token \"#{current.value}\"", current.position)
          end
    advance

    loop do
      if current.type == TokenType::EOF
        break
      elsif [
        TokenType::Plus,
        TokenType::Minus,
        TokenType::Star,
        TokenType::Slash
      ].include? current.type
        current
      else
        eputs("bad token \"#{current}\"")
      end

      from_left, from_right = infix_binding_power

      break if from_left < base_binding_power

      op = current
      advance
      rhs = construct_expression_by_binding_power(from_right)
      lhs = ParserItem.new(ParserItemType::Operator, op, [lhs, rhs])
    end

    lhs
  end

  def infix_binding_power
    case current.value
    when '+', '-'
      [1, 2]
    when '*', '/'
      [3, 4]
    when '='
      [10, -1]
    else
      eputs("Unknown operator \"#{current.value}\"")
    end
  end

  def advance
    @ip += 1
  end

  def peek(offset = 1)
    @tokens[@ip + offset]
  end

  def current
    @tokens[@ip]
  end
end
