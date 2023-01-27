require 'rails_helper'

describe RailsOmnibar::Item::Base do
  describe '#icon=' do
    it 'can be set' do
      item = RailsOmnibar::Item::Base.new(title: 'foo', url: 'bar', icon: :cog)
      expect(item.icon).to eq 'cog'
    end

    it 'raises for unknown icons' do
      expect do
        RailsOmnibar::Item::Base.new(title: 'foo', url: 'bar', icon: :bog)
      end.to raise_error ArgumentError
    end

    it 'has VALID_ICONS matching the supported ones' do
      js = RailsOmnibar::Engine.root.join('javascript/src/icon.tsx')
      supported = File.read(js).scan(/name === "([^"]+)"/).flatten.compact
      expect(supported).to contain_exactly(*RailsOmnibar::Item::Base::VALID_ICONS)
    end
  end
end
