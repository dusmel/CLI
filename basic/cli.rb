#!/usr/bin/env ruby
# ruby
# frozen_string_literal: true

require 'optparse'
require 'bundler/inline'

# adding dependencies without having to have a separate file
gemfile do
  source 'https://rubygems.org'
  gem 'tty-prompt', '~> 0.21.0'
  gem 'colorize'
  gem 'tty-box'
end
require 'tty-prompt'
require 'tty-box'
require 'colorize'

prompt = TTY::Prompt.new(interrupt: :exit)

OptionParser.new do |parser|
  parser.on('init', '--init', 'Init app') do
    system 'figlet -w 100 -c Basic   CLI | lolcat -a -d 1 '
    prompt.select('Choose your destiny?'.colorize(:yellow), %w[Scorpion Kano Jax])
  end

  parser.on('-p', '--prompt', 'diffent type of prompt') do
    # *- ruby CLI

    # ! (*) Prompt user ( ask question )

    # ? -> prompt with question inline
    name = prompt.ask('What is your name?', default: ENV['USER'])
    p name

    # ? -> Yes or no question
    prompt.yes?('Do you like Ruby?')

    # ? -> type password
    prompt.mask('What is your secret?')

    # ? -> arrow up/down select
    prompt.select('Choose your destiny?', %w[Scorpion Kano Jax])

    # ? -> select multiple with space
    choices = %w[vodka beer wine whisky bourbon]
    prompt.multi_select('Select drinks?', choices)

    # ? -> put a number to select
    prompt.enum_select('Select an editor?', choices)
  end

  parser.on('-c', '--complex', 'The name of the person') do
    # ? -> validate input and customize message
    answer = prompt.ask('What is your email address?') do |q|
      q.required true
      q.validate(/\A\w+@\w+\.\w+\Z/, 'Invalid email address')
      q.modify :capitalize
    end
    p answer

    # ? -> convert input >> (https://github.com/piotrmurach/tty-prompt#211-convert)
    answer = prompt.ask('Provide digit') do |q|
      # q.convert(:float, 'Wrong value of %{value} for %{type} conversion')
      # or
      q.convert :float
      q.messages[:convert?] = 'Wrong value of %{value} for %{type} conversion'
    end
    p answer

    # ? -> format input >> (https://github.com/piotrmurach/tty-prompt#211-convert)
    # * :trim     # remove whitespace from both ends of the input
    # * :strip    # same as :trim
    # * :chomp    # remove whitespace at the end of input
    # * :collapse # reduce all whitespace to single character
    # * :remove   # remove all whitespace
    # * :up # change to upper case
    # * :down       # change to small case
    # * :capitalize # capitalize each word

    answer = prompt.ask('Capitalize text:') do |q|
      q.modify :trim, :collapse, :capitalize
    end
    p answer

    # ? -> select with disable
    prompt.select('What size?') do |menu|
      menu.choice 'small', 1
      menu.choice 'medium', 2, disabled: '(out of stock)'
      menu.choice 'large', 3
    end

    # ? -> suggest close match of input
    prompt.suggest('sta', %w[stage stash commit branch])
  end

  parser.on('-s', '--slider', 'Slider input') do
    # ? -> slider that can be changed with arrow keys
    prompt.slider('Volume', max: 100, step: 5, default: 75, format: '🔇:slider 🔊 %d%%')
  end

  parser.on('-o', '--okay', 'Success message') do
    # ? -> success message
    prompt.ok('✨ success message')
  end

  parser.on('-e', '--error', 'Error message') do
    # ? -> error message
    prompt.error('🩸 error')
  end

  parser.on('-r', '--response', 'Respond with key events') do
    # ? -> error message
    prompt.yes?('Are you Human?') do |q|
      q.suffix 'Yup/nope'
      prompt.on(:keydown) do |key|
        prompt.trigger(:keydown)
        p 'okay' if key.value == 'y'
      end
    end
  end

  parser.on('-x', '--xcolor', 'Colors') do
    # ? -> all colors
    String.colors.each { |color| puts color.to_s.colorize(color) }
  end

  parser.on('-b', '--box', 'Colors') do
    # ? -> box
    box = TTY::Box.frame(
      width: 30,
      height: 10,
      align: :center,
      padding: 3
    ) do
      'Drawing'.colorize(:yellow)
    end
    print box
  end
end.parse!
