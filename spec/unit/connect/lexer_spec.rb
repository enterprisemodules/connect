require 'spec_helper'
require 'connect/parser'
require 'connect/lexer'

RSpec.describe 'Lexer' do

  let(:dsl) { Connect::Dsl.new}

  describe 'comments' do

    context 'with a newline at the end' do
      it 'is recognised' do
        content = <<-EOD
        # This a comment and should do anything
        EOD
        expect(dsl.tokenize(content)).to be_empty
      end
    end

    context 'without a new line at the end' do
      it 'is recognised' do
        content = "# This a comment and should do anything"
        expect(dsl.tokenize(content)).to be_empty
      end
    end
  end

  reserved_words = [
    'into',
    'with',
    'do',
    'iterate',
    'step',
    'end',
    'from',
    'import',
    'to',
    'and',
    'or',
    'include',
  ]

  describe 'reserved words' do
    reserved_words.each do | reserved_word|
      context reserved_word do
        it 'is recognised' do
          tag = reserved_word.upcase.to_sym
          content = <<-EOD
          #{reserved_word}
          EOD
          expect(dsl.tokenize(content)).to eql([[tag, "#{reserved_word}\n"]])
        end
      end

      context "identifier looking like reserved word" do
        it 'is recognised' do
          content = <<-EOD
          #{reserved_word}andmore
          EOD
          expect(dsl.tokenize(content)).to eql([[:IDENTIFIER, "#{reserved_word}andmore" ]])
        end
      end

    end
  end

  # describe 'or sign' do
  #   it 'is recognised' do
  #     content = <<-EOD
  #       ||
  #     EOD
  #     expect(dsl.tokenize(content)).to eql([[:OR, "||" ]])
  #   end
  # end

  describe 'and sign' do
    it 'is recognised' do
      content = <<-EOD
      &&
      EOD
      expect(dsl.tokenize(content)).to eql([[:AND, "&&" ]])
    end
  end



  describe 'booleans' do
    true_values = [
      'TRUE',
      'true',
    ]


    true_values.each do | boolean|
      context boolean do
        it 'is recognised' do
          content = <<-EOD
          #{boolean}
          EOD
          expect(dsl.tokenize(content)).to eql([[:BOOLEAN, true]])
        end
      end
    end

    false_values = [
      'FALSE',
      'false'
    ]

    false_values.each do | boolean|
      context boolean do
        it 'is recognised' do
          content = <<-EOD
          #{boolean}
          EOD
          expect(dsl.tokenize(content)).to eql([[:BOOLEAN, false]])
        end
      end
    end


    describe 'undefs' do
      undefs = [
        'undef',
        'undefined',
        'nil',
      ]

      undefs.each do | undef_str|
        context undef_str do
          it 'is recognised' do
            content = <<-EOD
            #{undef_str}
            EOD
            expect(dsl.tokenize(content)).to eql([[:UNDEF, nil]])
          end
        end
      end
    end

    describe 'integers' do
      context 'regular integers' do
        it 'is recognised' do
          content = <<-EOD
          107272 535335
          EOD
          expect(dsl.tokenize(content)).to eql([[:INTEGER, 107272], [:INTEGER, 535335]])
        end
      end
    end

    describe 'floats' do
      context 'regular floats' do
        it 'is recognised' do
          content = <<-EOD
          10.7272 5.35335
          EOD
          expect(dsl.tokenize(content)).to eql([[:FLOAT, 10.7272], [:FLOAT, 5.35335]])
        end
      end
    end

    describe 'regular expression' do
      it 'is recognised' do
        content = <<-EOD
        /regexp 1.*/
        EOD
        expect(dsl.tokenize(content)).to eql([[:REGEXP, 'regexp 1.*']])
      end
    end

    describe 'strings' do

      context 'double quoted strings' do
        it 'is recognised' do
          content = <<-EOD
          "String '1"  "String 2"
          EOD
          expect(dsl.tokenize(content)).to eql([[:DOUBLE_QUOTED, 'String \'1'], [:DOUBLE_QUOTED, 'String 2']])
        end
      end

      context 'single quoted strings' do
        it 'is recognised' do
          content = <<-EOD
          'String 1'  'String 2'
          EOD
          expect(dsl.tokenize(content)).to eql([[:SINGLE_QUOTED, 'String 1'], [:SINGLE_QUOTED, 'String 2']])
        end
      end


    end

    describe 'identifiers'
    context 'regular ones' do
      it 'is recognised' do
        content = <<-EOD
        bertand3timesernie
        EOD
        expect(dsl.tokenize(content)).to eql([[:IDENTIFIER, 'bertand3timesernie']])
      end
    end

    context 'with underscores' do
      it 'is recognised' do
        content = <<-EOD
        bertand_3_timesernie
        EOD
        expect(dsl.tokenize(content)).to eql([[:IDENTIFIER, 'bertand_3_timesernie']])
      end
    end
  end

  describe 'scopes' do

    context 'regular ones' do
      it 'is recognised' do
        content = <<-EOD
        foo::bar::
          EOD
        expect(dsl.tokenize(content)).to eql([[:SCOPE, 'foo::bar::']])
      end
    end

    context 'top level scope' do
      it 'is recognised' do
        content = <<-EOD
        ::
          EOD
        expect(dsl.tokenize(content)).to eql([[:SCOPE, '::']])
      end
    end


    context 'with underscores' do
      it 'is recognised' do
        content = <<-EOD
        foo_foo::bar_bar::
          EOD
        expect(dsl.tokenize(content)).to eql([[:SCOPE, 'foo_foo::bar_bar::']])
      end
    end

  end

  describe 'punctuation marks' do
    punctuation_marks = [
      '.', '[', ']', '{', '}', '=', '+', '-', '*', '/', '!', '(', ')'
    ]

    punctuation_marks.each do | punctuation_mark|

      context punctuation_mark do
        it "is recognised" do
          content = <<-EOD
          #{punctuation_mark}
          EOD
          expect(dsl.tokenize(content)).to eql([[punctuation_mark, punctuation_mark]])
        end
      end
    end
  end

  context '=>' do
    it 'is recognised' do
      content = <<-EOD
      =>
        EOD
      expect(dsl.tokenize(content)).to eql([[:HASH_ROCKET, '=>']])
    end
  end


  context '..' do
    it 'is recognised' do
      content = <<-EOD
      ..
        EOD
      expect(dsl.tokenize(content)).to eql([[:DOUBLE_DOTS, '..']])
    end
  end


end
