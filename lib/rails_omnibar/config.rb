class RailsOmnibar
  def configure(&block)
    check_const_and_clear_cache
    tap(&block)
  end

  attr_reader :auth
  def auth=(arg)
    @auth = arg.try(:arity) == 0 ? arg : RailsOmnibar.cast_to_proc(arg)
  end
  def authorize(controller)
    if auth.nil?
      true
    elsif auth.arity == 0
      controller.instance_exec(&auth)
    else
      auth.call(controller, controller: controller, omnibar: self)
    end
  end

  def max_results=(arg)
    arg.is_a?(Integer) && arg > 0 || raise(ArgumentError, 'max_results must be > 0')
    @max_results = arg
  end
  def max_results
    @max_results || 10
  end

  attr_writer :modal
  def modal?
    instance_variable_defined?(:@modal) ? !!@modal : false
  end

  attr_writer :calculator
  def calculator?
    instance_variable_defined?(:@calculator) ? !!@calculator : true
  end

  def hotkey
    @hotkey || 'k'
  end
  def hotkey=(arg)
    arg.to_s.size == 1 || raise(ArgumentError, 'hotkey must have length 1')
    @hotkey = arg.to_s.downcase
  end

  attr_writer :placeholder
  def placeholder
    return @placeholder.presence unless @placeholder.nil?

    help_item = items.find { |i| i.type == :help }
    help_item && "Hint: Type `#{help_item.title}` for help"
  end

  private

  def omnibar_class
    self.class.name || raise(<<~EOS)
      RailsOmnibar subclasses must be assigned to constants
      before configuring or rendering them. E.g.:

      Foo = Class.new(RailsOmnibar)
      Foo.configure { ... }
    EOS
  end
end
