class RailsOmnibar
  def handle(input, controller)
    handler = commands.find { |h| h.pattern.match?(input) }
    handler&.call(input, controller: controller, omnibar: self) || []
  end

  def command_pattern
    commands.any? ? Regexp.union(commands.map(&:pattern)) : /$NO_COMMANDS/
  end

  def add_command(command)
    check_const_and_clear_cache
    commands << RailsOmnibar.cast_to_command(command)
    self
  end

  def self.cast_to_command(arg)
    case arg
    when Command::Base then arg
    when Hash          then Command::Base.new(**arg)
    else raise(ArgumentError, "expected command, got #{arg.class}")
    end
  end

  def self.cast_to_proc(arg)
    arg = arg.method(:call).to_proc if arg.respond_to?(:call) && !arg.is_a?(Proc)
    arg.is_a?(Proc) && arg.parameters.count { |type, _| type == :req } == 1 ||
      raise(ArgumentError, "must be a proc that takes one positional argument")

    if arg.arity == 1
      # normalize for easier calling
      return ->(v, controller:, omnibar:) { arg.call(v) }
    end

    unsupported = arg.parameters.reject do |type, name|
      type == :req || type == :keyreq && name.in?(%i[controller omnibar])
    end
    unsupported.empty? ||
      raise(ArgumentError, "unsupported proc params: #{unsupported}")

    arg
  end

  private

  def commands
    @commands ||= []
  end
end
