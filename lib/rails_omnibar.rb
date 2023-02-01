require 'rails'

Dir[File.join(__dir__, 'rails_omnibar', '**', '*.rb')].sort.each { |f| require(f) }

class RailsOmnibar
  singleton_class.delegate(*public_instance_methods(false), to: :singleton)

  def self.singleton
    @singleton ||= new
  end
  private_class_method :singleton
  private_class_method :new
end
