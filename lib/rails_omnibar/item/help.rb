class RailsOmnibar
  def self.add_help(**kwargs)
    add_item Item::Help.new(for_commands: commands, **kwargs)
    self.class
  end

  module Item
    class Help < Base
      def initialize(title: '? - Help', for_commands:, custom_content: nil)
        super title: title, type: :help, modal_html: <<~HTML
          <span>Available actions:<span>
          <ul>
            #{custom_content&.then { |c| "<li>#{c}</li>" } }
            #{for_commands.map do |h|
              "<li><b>#{h.description}</b><br>Example: `#{h.example}`</li>"
            end.join}
          </ul>
        HTML
      end
    end
  end
end
