#!/usr/bin/env ruby
# ruby
# frozen_string_literal: true

require 'optparse'
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'tty-prompt', '~> 0.21.0'
  gem 'colorize'
end

require 'tty-prompt'
require 'colorize'

prompt = TTY::Prompt.new(interrupt: :exit)

if ARGV.any?
  if  ARGV.first == 'init'
    if (ARGV.size == 1) || (ARGV[1] == '.')
      p 'create to current path'
      system 'figlet -w 100 -c GITHUB NEW | lolcat -a -d 1 '
    elsif ARGV.size == 2
      p "create to this #{ARGV[1]}"
    else
      prompt.error('🩸 wrong number of argument')
    end
  end

  ARGV.each do |option|
  end
end

OptionParser.new do |parser|
  parser.banner = 'Usage: github-new [--version] [init <path>]'
  parser.on('init', '--init', 'Init app') do |option|
    begin
      # raise 'No User Found for id'
      p option

      # system 'figlet -w 100 -c GITHUB NEW | lolcat -a -d 1 '
      # prompt.select('Choose your destiny?'.colorize(:yellow), %w[Public Private])
    rescue StandardError => e
      prompt.error("🩸 error #{e}")
    end
  end

  parser.on('-c', '--create PATH', 'Create app') do |option|
    p option
    prompt.select('Choose your destiny?'.colorize(:yellow), %w[Public Private])
  end
end.parse!

# TODO:
# - init or create combined with -i (interactive you ask for names and everything)
# - if path is a git ask to push on created repos
# - show progress for create and pushing
# - at the end return new repos url
# - rename remote origin instead of adding
