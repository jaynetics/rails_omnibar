class RailsOmnibar
  module Command
    class Base
      attr_reader :pattern, :resolver, :description, :example

      def initialize(pattern:, resolver:, description: nil, example: nil)
        @pattern = cast_to_pattern(pattern)
        @resolver = cast_to_proc(resolver, 2)
        @description = description
        @example = example
      end

      def call(input, omnibar = nil)
        match = pattern.match(input)
        # look at match for highest capturing group or whole pattern
        value = match.to_a.last || raise(ArgumentError, 'input !~ pattern')
        results = resolver.call(value, omnibar)
        results = results.try(:to_ary) || [results]
        results.map { |e| RailsOmnibar.cast_to_item(e) }
      end

      private

      def cast_to_pattern(arg)
        regexp =
          case arg
          when Regexp   then arg
          when String   then /^#{Regexp.escape(arg)}.+/
          when NilClass then /.+/
          else raise ArgumentError, "pattern can't be a #{arg.class}"
          end

        regexp
      end

      def cast_to_proc(arg, arity)
        arg = arg.is_a?(Proc) ? arg : arg.method(:call).to_proc
        arg.is_a?(Proc) && arg.arity == arity ||
          raise(ArgumentError, "arg must be a Proc with arity #{arity}")
        arg
      end
    end
  end
end
