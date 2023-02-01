gem 'rails_omnibar', path: __dir__ + '/../'
gem 'devise'

generate 'model', 'User first_name:string last_name:string admin:boolean --no-test-framework'
generate 'devise:install'
generate 'devise User'

prepend_to_file 'config/application.rb', "require 'devise'\n"

file 'app/lib/my_omnibar.rb',    File.read(__dir__ + '/my_omnibar_template.rb')
file 'app/lib/other_omnibar.rb', File.read(__dir__ + '/other_omnibar_template.rb')

inject_into_class 'app/controllers/application_controller.rb', 'ApplicationController', <<-RUBY
  def index
    render html: (MyOmnibar.render + OtherOmnibar.render)
  end
RUBY

route 'mount RailsOmnibar::Engine => "/rails_omnibar"'
route 'root "application#index"'
route 'get "users/(*path)" => "application#index"'

rake 'db:migrate db:test:prepare'
