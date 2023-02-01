class RailsOmnibar
  def add_item(item)
    check_const_and_clear_cache
    items << RailsOmnibar.cast_to_item(item)
    self
  end

  def add_items(*args)
    args.each { |arg| add_item(arg) }
    self
  end

  def self.cast_to_item(arg)
    case arg
    when Item::Base then arg
    when Hash       then Item::Base.new(**arg)
    else raise(ArgumentError, "expected Item, got #{arg.class}")
    end
  end

  private

  def items
    @items ||= []
  end
end
