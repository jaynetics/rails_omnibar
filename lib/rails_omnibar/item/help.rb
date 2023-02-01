class RailsOmnibar
  def add_help(**kwargs)
    add_item Item::Help.new(for_commands: commands, **kwargs)
  end

  module Item
    class Help < Base
      def initialize(title: 'Help', for_commands:, custom_content: nil, icon: 'question', suggested: true)
        super title: title, suggested: suggested, icon: icon, type: :help, modal_html: <<~HTML
          <span>Usage:<span>
          <ul>
            <li>Type a few letters to get results</li>
            <li>Use the arrow keys (↑/↓) on your keyboard to select a result</li>
            <li>Hit Enter to open a result</li>
            <li>Hit Escape to close</li>
          </ul>
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
