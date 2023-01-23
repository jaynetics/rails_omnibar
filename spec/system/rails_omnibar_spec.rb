require 'rails_helper'

describe RailsOmnibar do
  it 'works' do
    FactoryBot.create(:user, id: 1, first_name: 'John', last_name: 'Doe')
    FactoryBot.create(:user, id: 2, first_name: 'Jane', last_name: 'Doe', admin: true)
    expect(User.pluck(:id).sort).to eq [1, 2] # sanity check

    visit main_app.root_path
    expect(page).to have_selector '#mount-rails-omnibar' # sanity check

    # test visibility toggling with hotkey
    expect(page).not_to have_selector 'input'

    send_keys([:control, 'm']) # custom hotkey, c.f. app_template.rb
    expect(page).to have_selector 'input'

    send_keys([:control, 'm'])
    expect(page).not_to have_selector 'input'

    send_keys([:meta, 'm']) # meta modifier (⌘) should also be supported
    expect(page).to have_selector 'input'

    # test fuzzy search for static items
    type('ou')
    expect(page).to have_content 'boring URL'
    expect(page).to have_content 'important URL'

    type('ori')
    expect(page).to have_content 'boring URL'
    expect(page).not_to have_content 'important URL'

    # test help modal
    expect(page).not_to have_content 'Available actions'
    submit('Help')
    expect(page).to have_content 'Available actions'
    send_keys :escape
    expect(page).not_to have_content 'Available actions'

    # test record search by id
    type('u1')
    expect(page).to have_content 'User#1'
    expect(page).not_to have_content 'User#2'

    type('u2')
    expect(page).to have_content 'User#2'
    expect(page).not_to have_content 'User#1'

    # test record search by custom column
    type('u J') # both usernames start with J
    expect(page).to have_content 'User#1'
    expect(page).to have_content 'User#2'

    type('u Jo')
    expect(page).to have_content 'User#1'
    expect(page).not_to have_content 'User#2'

    type('u Ja')
    expect(page).to have_content 'User#2'
    expect(page).not_to have_content 'User#1'

    # test navigation for item with #url
    submit
    expect(page.current_url).to end_with '/users/2'
    send_keys([:control, 'm']) # make omnibar visible again

    # test generic search and multi-itemization
    type('g foobar')
    expect(page).to have_content 'fake_result_1'
    expect(page).to have_content 'FAKE_RESULT_1'
    expect(page).to have_content 'fake_result_2'
    expect(page).to have_content 'FAKE_RESULT_2'

    # test custom command
    type('count users')
    expect(page).to have_content '2'
  end

  def type(str)
    find('input').set(str)
  end

  def submit(str = nil)
    str.present? && type(str)
    sleep(0.1) # wait a tiny bit for the omnibar results to appear
    send_keys(:return)
  end
end
