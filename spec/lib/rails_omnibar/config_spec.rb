require 'rails_helper'

describe RailsOmnibar do
  subject { Class.new(RailsOmnibar) }

  it 'has a configurable hotkey' do
    expect(subject.hotkey).to eq 'k'
    subject.hotkey = 'z'
    expect(subject.hotkey).to eq 'z'
    subject.hotkey = 'K' # should be downcased
    expect(subject.hotkey).to eq 'k'
  end

  it 'has a configurable rendering' do
    expect(subject.modal?).to eq true
    subject.modal = false
    expect(subject.modal?).to eq false
    subject.modal = true
    expect(subject.modal?).to eq true
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
end
