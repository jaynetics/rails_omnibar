class RailsOmnibar
  def self.handle(input)
    commands.find { |h| h.pattern.match?(input) }&.then { |h| h.call(input, self) } || []
  end

  def self.command_pattern
    commands.any? ? Regexp.union(commands.map(&:pattern)) : /$NO_COMMANDS/
  end

  def self.add_command(command)
    commands << RailsOmnibar.cast_to_command(command)
    clear_cache
    self
  end

  def self.cast_to_command(arg)
    case arg
    when Command::Base then arg
    when Hash          then Command::Base.new(**arg)
    else raise(ArgumentError, "expected command, got #{arg.class}")
    end
  end

  private_class_method\
  def self.commands
    @commands ||= []
  end
end
