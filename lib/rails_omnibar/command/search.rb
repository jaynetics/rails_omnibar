class RailsOmnibar
  def add_search(**kwargs)
    add_command Command::Search.new(**kwargs)
  end

  def add_record_search(**kwargs)
    add_command Command::RecordSearch.new(**kwargs)
  end

  module Command
    # Generic search.
    class Search < Base
      def initialize(finder:, itemizer:, **kwargs)
        finder   = RailsOmnibar.cast_to_proc(finder)
        itemizer = RailsOmnibar.cast_to_proc(itemizer)

        resolver = ->(value, controller:, omnibar:) do
          findings = finder.call(value, controller: controller, omnibar: omnibar)
          findings = Array(findings) unless findings.respond_to?(:first)

          findings.first(omnibar.max_results).flat_map do |finding|
            itemizer.call(finding, controller: controller, omnibar: omnibar)
          end
        end

        super(resolver: resolver, **kwargs)
      end
    end

    # ActiveRecord-specific search.
    class RecordSearch < Search
      def initialize(model:, columns: :id, pattern: nil, finder: nil, itemizer: nil, example: nil, if: nil)
        # casting and validations
        model = model.to_s.classify.constantize unless model.is_a?(Class)
        model < ActiveRecord::Base || raise(ArgumentError, 'model: must be a model')
        columns = Array(columns).map(&:to_s)
        columns.present? || raise(ArgumentError, 'columns: must be given')
        columns.each { |c| c.in?(model.column_names) || raise(ArgumentError, "bad column #{c}") }

        description = "Find #{model.name}"
        description += " by #{columns.join(' OR ')}" unless finder

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
          description: description,
          example:     example,
          pattern:     pattern,
          finder:      finder,
          itemizer:    itemizer,
          if:          binding.local_variable_get(:if),
        )
      end
    end
  end

  def self.like
    @like ||= ActiveRecord::Base.connection.adapter_name =~ /^post|pg/i ? 'ILIKE' : 'LIKE'
  end
end
