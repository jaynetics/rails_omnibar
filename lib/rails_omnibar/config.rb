class RailsOmnibar
  cattr_writer(:modal) { false }
  def self.modal?
    !!@@modal
  end

  cattr_writer(:calculator) { true }
  def self.calculator?
    !!@@calculator
  end

  cattr_reader(:hotkey) { 'k' }
  def self.hotkey=(arg)
    arg.to_s.size == 1 || raise(ArgumentError, 'hotkey must have length 1')
    @@hotkey = arg.to_s.downcase
  end

  cattr_writer(:placeholder)
  def self.placeholder
    return @@placeholder.presence unless @@placeholder.nil?

    help_item = items.find { |i| i.type == :help }
    help_item && "Hint: Type `#{help_item.title}` for help"
  end
end
