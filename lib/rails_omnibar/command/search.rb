class RailsOmnibar
  def self.add_search(**kwargs)
    add_command Command::Search.new(**kwargs)
  end

  def self.add_record_search(**kwargs)
    add_command Command::RecordSearch.new(**kwargs)
  end

  module Command
    # Generic search.
    class Search < Base
      def initialize(finder:, itemizer:, **kwargs)
        finder   = cast_to_proc(finder, 1)
        itemizer = cast_to_proc(itemizer, 1)
        resolver = ->(value, omnibar) do
          findings = finder.call(value)
          findings = Array(findings) unless findings.respond_to?(:first)
          findings.first(omnibar.max_results).map(&itemizer)
        end

        super(resolver: resolver, **kwargs)
      end
    end

    # ActiveRecord-specific search.
    class RecordSearch < Search
      def initialize(model:, columns: :id, pattern: nil, finder: nil, itemizer: nil, example: nil)
        # casting and validations
        model = model.to_s.classify.constantize unless model.is_a?(Class)
        model < ActiveRecord::Base || raise(ArgumentError, 'model: must be a model')
        columns = Array(columns).map(&:to_s)
        columns.present? || raise(ArgumentError, 'columns: must be given')
        columns.each { |c| c.in?(model.column_names) || raise(ArgumentError, "bad column #{c}") }

        # default finder, uses LIKE/ILIKE for non-id columns
        finder ||= ->(q) do
          return model.none if q.blank?

          columns.inject(model.none) do |rel, col|
            rel.or(col =~ /id$/ ? model.where(col => q) :
                                  model.where("#{col} #{RailsOmnibar.like} ?", "%#{q}%"))
          end
        end

        # default itemizer
        itemizer ||= ->(record) do
          {
            title: "#{record.class.name}##{record.id}",
            url:   "/#{model.model_name.route_key}/#{record.to_param}",
          }
        end

        super(
          description: "Find #{model.name} by #{columns.join(' OR ')}".tr('_', ' '),
          example:     example,
          pattern:     pattern,
          finder:      finder,
          itemizer:    itemizer,
        )
      end
    end
  end

  def self.like
    @like ||= ActiveRecord::Base.connection.adapter_name =~ /^post|pg/i ? 'ILIKE' : 'LIKE'
  end
end
