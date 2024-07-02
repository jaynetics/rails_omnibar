require 'rails_helper'

describe RailsOmnibar do
  it 'inherits commands from a parent class' do
    bar1 = Class.new(RailsOmnibar).configure do |c|
      c.add_command(pattern: /foo1/, resolver: ->(_){})
    end
    bar2 = Class.new(bar1).configure do |c|
      c.add_command(pattern: /foo2/, resolver: ->(_){})
    end
    bar3 = Class.new(bar2).configure do |c|
      c.add_command(pattern: /foo3/, resolver: ->(_){})
    end

    commands = ->(bar) do
      bar.send(:singleton).send(:commands).map { |c| c.pattern.source }
    end

    expect(commands.call(bar1)).to eq ['foo1']
    expect(commands.call(bar2)).to eq ['foo1', 'foo2']
    expect(commands.call(bar3)).to eq ['foo1', 'foo2', 'foo3']

    # later changes to commands should not affect child classes
    bar1.add_command(pattern: /foo1B/, resolver: ->(_){})
    expect(commands.call(bar1)).to eq ['foo1', 'foo1B']
    expect(commands.call(bar2)).to eq ['foo1', 'foo2']
    expect(commands.call(bar3)).to eq ['foo1', 'foo2', 'foo3']
  end

  it 'inherits configuration from a parent class' do
    bar1 = Class.new(RailsOmnibar).configure do |c|
      c.max_results = 7
      c.placeholder = 'hi'
      c.hotkey = 'j'
    end
    bar2 = Class.new(bar1).configure do |c|
      c.max_results = 8
    end
    bar3 = Class.new(bar2).configure do |c|
      c.hotkey = 'k'
    end

    config = ->(bar) { bar.send(:singleton).send(:config) }

    expect(config.call(bar1)).to eq(max_results: 7, placeholder: 'hi', hotkey: 'j')
    expect(config.call(bar2)).to eq(max_results: 8, placeholder: 'hi', hotkey: 'j')
    expect(config.call(bar3)).to eq(max_results: 8, placeholder: 'hi', hotkey: 'k')

    # later changes to config should not affect child classes
    bar1.placeholder = 'bye'
    expect(bar1.placeholder).to eq 'bye'
    expect(bar2.placeholder).to eq 'hi'
    expect(bar3.placeholder).to eq 'hi'
  end

  it 'inherits items from a parent class' do
    bar1 = Class.new(RailsOmnibar).configure do |c|
      c.add_item(title: 'foo1', url: 'bar1')
    end
    bar2 = Class.new(bar1).configure do |c|
      c.add_item(title: 'foo2', url: 'bar2')
    end
    bar3 = Class.new(bar2).configure do |c|
      c.add_item(title: 'foo3', url: 'bar3')
    end

    items = ->(bar) { bar.send(:singleton).send(:items).map(&:title) }

    expect(items.call(bar1)).to eq ['foo1']
    expect(items.call(bar2)).to eq ['foo1', 'foo2']
    expect(items.call(bar3)).to eq ['foo1', 'foo2', 'foo3']

    # later changes to items should not affect child classes
    bar1.add_item(title: 'foo1B', url: 'bar1B')
    expect(items.call(bar1)).to eq ['foo1', 'foo1B']
    expect(items.call(bar2)).to eq ['foo1', 'foo2']
    expect(items.call(bar3)).to eq ['foo1', 'foo2', 'foo3']
  end
end
