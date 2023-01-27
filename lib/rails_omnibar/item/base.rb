class RailsOmnibar
  module Item
    class Base
      attr_reader :title, :url, :icon, :modal_html, :suggested, :type

      def initialize(title:, url: nil, icon: nil, modal_html: nil, suggested: false, type: :default)
        url.present? && modal_html.present? && raise(ArgumentError, 'use EITHER url: OR modal_html:')

        @title      = validate_title(title)
        @url        = url
        @icon       = validate_icon(icon)
        @modal_html = modal_html
        @suggested  = !!suggested
        @type       = type
      end

      def as_json(*)
        { title: title, url: url, icon: icon, modalHTML: modal_html, suggested: suggested, type: type }
      end

      private

      def validate_title(title)
        return title if title.class.in?([String, Symbol]) && title.present?

        raise(ArgumentError, 'title: must be a String')
      end

      def validate_icon(icon)
        return nil if icon.blank?
        return icon.to_s if icon.to_s.in?(VALID_ICONS)

        raise ArgumentError, "#{icon} not in valid icons: #{VALID_ICONS}"
      end

      VALID_ICONS = %w[
        arrows
        cloud
        cog
        dev
        document
        home
        question
        search
        sparkle
        user
        wallet
        x
      ]
    end
  end
end
