class RailsOmnibar
  module Command
    class Base
      attr_reader :pattern, :resolver, :description, :example

      def initialize(resolver:, pattern: nil, description: nil, example: nil)
        @pattern = cast_to_pattern(pattern)
        @resolver = RailsOmnibar.cast_to_proc(resolver)
        @description = description
        @example = example
      end

      def call(input, controller:, omnibar:)
        match = pattern.match(input)
        # look at match for highest capturing group or whole pattern
        value = match.to_a.last || raise(ArgumentError, 'input !~ pattern')
        results = resolver.call(value, controller: controller, omnibar: omnibar)
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
    end
  end
end
