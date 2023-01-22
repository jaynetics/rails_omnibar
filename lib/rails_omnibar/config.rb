class RailsOmnibar
  def self.max_results=(arg)
    arg.is_a?(Integer) && arg > 0 || raise(ArgumentError, 'max_results must be > 0')
    @max_results = arg
  end
  def self.max_results
    @max_results || 10
  end

  singleton_class.attr_writer :modal
  def self.modal?
    instance_variable_defined?(:@modal) ? !!@modal : false
  end

  singleton_class.attr_writer :calculator
  def self.calculator?
    instance_variable_defined?(:@calculator) ? !!@calculator : true
  end

  def self.hotkey
    @hotkey || 'k'
  end
  def self.hotkey=(arg)
    arg.to_s.size == 1 || raise(ArgumentError, 'hotkey must have length 1')
    @hotkey = arg.to_s.downcase
  end

  singleton_class.attr_writer :placeholder
  def self.placeholder
    return @placeholder.presence unless @placeholder.nil?

    help_item = items.find { |i| i.type == :help }
    help_item && "Hint: Type `#{help_item.title}` for help"
  end
end
