class RailsOmnibar
  def self.cast_to_condition(arg)
    case arg
    when nil, true, false then arg
    else
      arg.try(:arity) == 0 ? arg : RailsOmnibar.cast_to_proc(arg)
    end
  end

  def self.evaluate_condition(condition, context:, omnibar:)
    case condition
    when nil, true then true
    when false     then false
    else
      context || raise(<<~EOS)
        Missing context for condition, please render the omnibar with `.render(self)`
      EOS
      if condition.try(:arity) == 0
        context.instance_exec(&condition)
      elsif condition.respond_to?(:call)
        condition.call(context, controller: context, omnibar: omnibar)
      else
        raise("unsupported condition type: #{condition.class}")
      end
    end
  end
end
