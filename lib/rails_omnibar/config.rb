class RailsOmnibar
  def configure(&block)
    tap(&block)
    self.class
  end

  def auth=(arg)
    config[:auth] = arg.try(:arity) == 0 ? arg : RailsOmnibar.cast_to_proc(arg)
  end
  def auth
    config[:auth]
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
    config[:max_results] = arg
  end
  def max_results
    config[:max_results] || 10
  end

  def modal=(arg)
    config[:modal] = arg
  end
  def modal?
    config.key?(:modal) ? !!config[:modal] : false
  end

  def calculator=(arg)
    config[:calculator] = arg
  end
  def calculator?
    config.key?(:calculator) ? !!config[:calculator] : true
  end

  def hotkey=(arg)
    arg.to_s.size == 1 || raise(ArgumentError, 'hotkey must have length 1')
    config[:hotkey] = arg.to_s.downcase
  end
  def hotkey
    config[:hotkey] || 'k'
  end

  def placeholder=(arg)
    config[:placeholder] = arg
  end
  def placeholder
    return config[:placeholder].presence unless config[:placeholder].nil?

    help_item = items.find { |i| i.type == :help }
    help_item && "Hint: Type `#{help_item.title}` for help"
  end

  private

  def config
    @config ||= {}
  end

  def omnibar_class
    self.class.name || raise(<<~EOS)
      RailsOmnibar subclasses must be assigned to constants, e.g.:

      Foo = Class.new(RailsOmnibar).configure { ... }
    EOS
  end
end
