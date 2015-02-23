require 'spec_helper'
require 'wannabe_bool'
require 'dsl/lexer'

RSpec.describe 'Lexer' do

	let(:dsl) { Dsl.new}

	it 'skips comments' do
		content = <<-EOD
		# This a comment and should do anything
		EOD
		expect(dsl.tokenize(content)).to be_empty
	end

	reserved_words = [
		'do',
		'end',
		'from',
		'to',
		'include',
	]

	reserved_words.each do | reserved_word| 
		it "Recognises reserved word #{reserved_word}" do
			tag = reserved_word.upcase.to_sym
			content = <<-EOD
			 #{reserved_word} 
			EOD
			expect(dsl.tokenize(content)).to eql([[tag, reserved_word]])
		end
	end

	booleans = [
		'TRUE',
		'true',
		'FALSE',
		'false'
	]

	booleans.each do | boolean| 
		it "Recognises boolean #{boolean}" do
			content = <<-EOD
			 #{boolean} 
			EOD
			expect(dsl.tokenize(content)).to eql([[:BOOLEAN, boolean.to_b]])
		end
	end

	undefs = [
		'undef',
		'undefined',
		'nil',
	]

	undefs.each do | undef_str| 
		it "Recognises #{undef_str} as undefined" do
			content = <<-EOD
			 #{undef_str} 
			EOD
			expect(dsl.tokenize(content)).to eql([[:UNDEF, nil]])
		end
	end

	it 'recognises integers' do
		content = <<-EOD
		107272 535335
		EOD
		expect(dsl.tokenize(content)).to eql([[:INTEGER, 107272], [:INTEGER, 535335]])
	end

	it 'recognises floats' do
		content = <<-EOD
		10.7272 5.35335
		EOD
		expect(dsl.tokenize(content)).to eql([[:FLOAT, 10.7272], [:FLOAT, 5.35335]])
	end

	it 'recognises strings' do
		content = <<-EOD
		"String '1"  'String 2'
		EOD
		expect(dsl.tokenize(content)).to eql([[:STRING, 'String \'1'], [:STRING, 'String 2']])
	end

	it 'recognises a hash rocket' do
		content = <<-EOD
		=>
		EOD
		expect(dsl.tokenize(content)).to eql([[:HASH_ROCKET, '=>']])
	end

	it 'recognises an identifier' do
		content = <<-EOD
		bertand3timesernie
		EOD
		expect(dsl.tokenize(content)).to eql([[:IDENTIFIER, 'bertand3timesernie']])
	end

	it 'recognises a scope' do
		content = <<-EOD
		foo::bar::
		EOD
		expect(dsl.tokenize(content)).to eql([[:SCOPE, 'foo::bar::']])
	end

	describe ' selectors' do

		it 'recognises an array selector' do
			content = <<-EOD
			[10]
			EOD
			expect(dsl.tokenize(content)).to eql([[:SELECTOR, '[10]']])
		end


		it 'recognises a method selector' do
			content = <<-EOD
			.first
			EOD
			expect(dsl.tokenize(content)).to eql([[:SELECTOR, '.first']])
		end


		it 'recognises a complex selector' do
			content = <<-EOD
			[10].first[20]
			EOD
			expect(dsl.tokenize(content)).to eql([[:SELECTOR, '[10].first[20]']])
		end


	end


	punctuation_marks = [
		'.', '[', ']', '{', '}', '=', '+', '-', '*', '/', '!', '(', ')'
	]

	punctuation_marks.each do | punctuation_mark|

		it "passes puntuation mark #{punctuation_mark} as text" do
			content = <<-EOD
			 #{punctuation_mark}
			EOD
			expect(dsl.tokenize(content)).to eql([[punctuation_mark, punctuation_mark]])
		end
	end


end