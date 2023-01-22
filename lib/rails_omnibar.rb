require 'rails'

Dir[File.join(__dir__, 'rails_omnibar', '**', '*.rb')].sort.each { |f| require(f) }

class RailsOmnibar
  singleton_class.alias_method :configure, :tap
  singleton_class.undef_method :new
end
