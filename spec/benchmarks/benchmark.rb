require_relative '../rails_helper'
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'benchmark-ips', require: 'benchmark/ips'
end

BenchmarkBar = Class.new(RailsOmnibar).configure do |c|
  100.times { c.add_item(title: rand.to_s, url: rand.to_s) }
  10.times { c.add_command(description: rand.to_s, pattern: /#{rand}/, example: rand.to_s, resolver: ->(_){}) }
end

Benchmark.ips do |x|
  x.report('render') { BenchmarkBar.render } # ~3k ips
end
