require 'rails_helper'

describe RailsOmnibar::VERSION do
  it 'is valid' do
    expect(subject).to match(/\A\d+\.\d+\.\d+\z/)
  end
end
