class RailsOmnibar
  module Item
    class Base
      attr_reader :title, :url, :modal_html, :type

      def initialize(title:, url: nil, modal_html: nil, type: :default)
        title.class.in?([String, Symbol]) && title.present? || raise(ArgumentError, 'title: must be a String')
        url.present? && modal_html.present? && raise(ArgumentError, 'use EITHER url: OR modal_html:')

        @title      = title
        @url        = url
        @modal_html = modal_html
        @type       = type
      end

      def as_json(*)
        { title: title, url: url, modalHTML: modal_html, type: type }
      end
    end
  end
end
