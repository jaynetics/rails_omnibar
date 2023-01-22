class RailsOmnibar
  def self.add_item(item)
    items << RailsOmnibar.cast_to_item(item)
    clear_cache
    self.class
  end

  def self.add_items(*args)
    args.each { |arg| add_item(arg) }
    self.class
  end

  def self.cast_to_item(arg)
    case arg
    when Item::Base then arg
    when Hash       then Item::Base.new(**arg)
    else raise(ArgumentError, "expected Item, got #{arg.class}")
    end
  end

  private_class_method\
  def self.items
    @items ||= []
  end
end
