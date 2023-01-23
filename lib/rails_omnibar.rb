require 'rails'

Dir[File.join(__dir__, 'rails_omnibar', '**', '*.rb')].sort.each { |f| require(f) }

class RailsOmnibar
  def self.configure(&block)
    @singleton = block_given? ? new.tap(&block) : new
  end
  private_class_method :new

  singleton_class.delegate(*public_instance_methods(false), to: :singleton)

  private_class_method\
  def self.singleton
    @singleton || raise("Please `.configure' your omnibar first")
  end
end
