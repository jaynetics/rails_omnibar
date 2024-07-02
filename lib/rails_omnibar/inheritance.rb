class RailsOmnibar
  def self.inherited(subclass)
    bar1 = singleton
    bar2 = subclass.send(:singleton)
    %i[@commands @config @items].each do |ivar|
      bar2.instance_variable_set(ivar, bar1.instance_variable_get(ivar).dup)
    end
  end
end
