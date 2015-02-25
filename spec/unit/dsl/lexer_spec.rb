require 'spec_helper'
require 'wannabe_bool'
require 'dsl/lexer'

RSpec.describe 'Lexer' do

  let(:dsl) { Dsl.new}

  describe 'comments' do

    context 'with a newline at the end'
    it 'is recognised' do
      content = <<-EOD
      # This a comment and should do anything
      EOD
      expect(dsl.tokenize(content)).to be_empty
    end

    context 'without a new line at the end'
    it 'is recognised' do
      content = "# This a comment and should do anything"
      expect(dsl.tokenize(content)).to be_empty
    end
  end

  reserved_words = [
    'do',
    'end',
    'from',
    'to',
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

  describe 'booleans' do
    booleans = [
      'TRUE',
      'true',
      'FALSE',
      'false'
    ]

    booleans.each do | boolean|
      context boolean do
        it 'is recognised' do
          content = <<-EOD
          #{boolean}
          EOD
          expect(dsl.tokenize(content)).to eql([[:BOOLEAN, boolean.to_b]])
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

    describe 'strings' do

      context 'regular strings' do
        it 'is recognised' do
          content = <<-EOD
          "String '1"  'String 2'
          EOD
          expect(dsl.tokenize(content)).to eql([[:STRING, 'String \'1'], [:STRING, 'String 2']])
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

    context 'with underscores' do
      it 'is recognised' do
        content = <<-EOD
        foo_foo::bar_bar::
          EOD
        expect(dsl.tokenize(content)).to eql([[:SCOPE, 'foo_foo::bar_bar::']])
      end
    end

  end

  describe ' selectors' do

    context 'array selector' do
      it 'is recognised' do
        content = <<-EOD
        [10]
        EOD
        expect(dsl.tokenize(content)).to eql([[:SELECTOR, '[10]']])
      end
    end

    context 'method selector' do
      it 'is recognised' do
        content = <<-EOD
        .first
        EOD
        expect(dsl.tokenize(content)).to eql([[:SELECTOR, '.first']])
      end
    end

    context 'complex selector' do
      it 'is recognised' do
        content = <<-EOD
        [10].first[20]
        EOD
        expect(dsl.tokenize(content)).to eql([[:SELECTOR, '[10].first[20]']])
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

end
