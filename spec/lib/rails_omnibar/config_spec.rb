require 'rails_helper'

TestBar = Class.new(RailsOmnibar)

describe RailsOmnibar do
  subject { TestBar }

  it 'has a configurable max_results' do
    expect(subject.max_results).to eq 10
    subject.max_results = 5
    expect(subject.max_results).to eq 5
    expect { subject.max_results = 0 }.to raise_error(ArgumentError)
    expect { subject.max_results = '5' }.to raise_error(ArgumentError)
    expect { subject.max_results = 5.0 }.to raise_error(ArgumentError)
  end

  it 'has a configurable hotkey' do
    expect(subject.hotkey).to eq 'k'
    subject.hotkey = 'z'
    expect(subject.hotkey).to eq 'z'
    subject.hotkey = 'K' # should be downcased
    expect(subject.hotkey).to eq 'k'
    expect { subject.hotkey = '' }.to raise_error(ArgumentError)
    expect { subject.hotkey = 'kk' }.to raise_error(ArgumentError)
  end

  it 'has a configurable rendering' do
    expect(subject.modal?).to eq false
    subject.modal = true
    expect(subject.modal?).to eq true
    subject.modal = false
    expect(subject.modal?).to eq false
  end

  it 'has a configurable calculator' do
    expect(subject.calculator?).to eq true
    subject.calculator = false
    expect(subject.calculator?).to eq false
    subject.calculator = true
    expect(subject.calculator?).to eq true
  end

  it 'has a configurable placeholder' do
    expect(subject.placeholder).to eq nil
    subject.placeholder = 'foo'
    expect(subject.placeholder).to eq 'foo'
    # falls back to help item hint if help item exists
    subject.add_help(title: 'REEE')
    expect(subject.placeholder).to eq 'foo'
    subject.placeholder = nil
    expect(subject.placeholder).to eq 'Hint: Type `REEE` for help'
    subject.placeholder = false
    expect(subject.placeholder).to eq nil
  end

  it 'raises when trying to configure or render from an anonymous class' do
    klass = Class.new(RailsOmnibar)
    expect { klass.configure {} }.to raise_error(/constant/)
    expect { klass.add_item(title: 'a', url: 'b') }.to raise_error(/constant/)
    expect { klass.render }.to raise_error(/constant/)
  end
end
