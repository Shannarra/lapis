require 'spec_helper'

RSpec.describe Lexer do # rubocop:disable Metrics/BlockLength
  let(:text) do
    ''
  end

  subject { Lexer }

  describe 'when an empty string is passed' do
    it 'handles it without fail' do
      expect do
        subject.lex!(text)
      end.not_to raise_error
    end
  end

  describe 'when provided basic block' do # rubocop:disable Metrics/BlockLength
    let(:text_with_comments) do
      <<TEXT
      extern printf
      extern exit

      def main
      	//050468asd

      	printf('%s', 69)

      	printf(420)// Hello world, i'm a comment

      	exit(0)
      end
TEXT
    end

    let(:tokens) do
      [
        Token.new('extern', TokenType::Keyword,          [1, 5]),
        Token.new('printf', TokenType::Identifier,       [1, 12]),
        Token.new('extern', TokenType::Keyword,          [2, 6]),
        Token.new('exit', TokenType::Identifier, [2, 13]),
        Token.new('def', TokenType::Keyword, [4, 6]),
        Token.new('main', TokenType::Identifier, [4, 10]),
        Token.new('printf', TokenType::Identifier, [7, 7]),
        Token.new('(', TokenType::OpenParenthesis, [7, 14]),
        Token.new('\'%s\'', TokenType::Identifier, [7, 15]),
        Token.new(',', TokenType::Comma, [7, 19]),
        Token.new('69', TokenType::Number, [7, 20]),
        Token.new(')', TokenType::CloseParenthesis, [7, 23]),
        Token.new('printf', TokenType::Identifier, [9, 7]),
        Token.new('(', TokenType::OpenParenthesis, [9, 14]),
        Token.new('420', TokenType::Number, [9, 15]),
        Token.new(')', TokenType::CloseParenthesis, [9, 18]),
        Token.new('exit', TokenType::Identifier, [11, 7]),
        Token.new('(', TokenType::OpenParenthesis, [11, 12]),
        Token.new('0', TokenType::Number,           [11, 13]),
        Token.new(')', TokenType::CloseParenthesis, [11, 14]),
        Token.new('end', TokenType::Keyword, [12, 6]),
        Token.new(nil, TokenType::EOF, [13, 1])
      ]
    end

    context 'then creates tokens' do
      it 'raises no errors and returns a valid tokens list' do
        items = []
        expect do
          items = subject.lex!(text_with_comments)
        end.not_to(raise_error)
        expect(items).to be_an_instance_of(Array)
        expect(items.count).to eq 22

        tokens.each_with_index do |token, idx|
          expected_token = items[idx]
          expect(token.value).to eq(expected_token.value)
          expect(token.type).to eq(expected_token.type)
          expect(token.position).to eq(expected_token.position)
        end
      end
    end
  end
end
