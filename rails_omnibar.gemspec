lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require_relative 'lib/rails_omnibar/version'

Gem::Specification.new do |spec|
  spec.name          = 'rails_omnibar'
  spec.version       = RailsOmnibar::VERSION
  spec.authors       = ['Janosch Müller']
  spec.summary       = 'Omnibar for Rails'
  spec.description   = 'Omnibar for Rails'
  spec.homepage      = 'https://github.com/jaynetics/rails_omnibar'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0") + %w[javascript/compiled.js]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.7'

  spec.add_dependency 'js_regex'
  spec.add_dependency 'rails', ['>= 6.0', '< 8.0']

  spec.add_development_dependency 'capybara', '~> 3.0'
  spec.add_development_dependency 'devise', '~> 4.8'
  spec.add_development_dependency 'factory_bot_rails', '~> 6.0'
  spec.add_development_dependency 'puma', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec-rails', '~> 5.0'
  spec.add_development_dependency 'sqlite3', '>= 1.3.6'
  spec.add_development_dependency 'webdrivers', '~> 5.0'
end
