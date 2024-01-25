# template for dummy rails app used in specs

gem 'rails_omnibar', path: __dir__ + '/../../'
gem 'devise'
gem 'activeadmin'

insert_into_file 'config/application.rb', <<~RUBY, after: /action_mailer.*\n/
  require 'action_mailer/railtie' # needed to make devise work
  require 'devise'
  require 'sprockets/railtie' # needed to make activeadmin work
RUBY

# https://github.com/activeadmin/activeadmin/pull/7235#issuecomment-1000823435
insert_into_file 'config/environments/test.rb', 'false # ', after: /config.eager_load *=/

generate 'model', 'User first_name:string last_name:string admin:boolean --no-test-framework'
generate 'devise:install'
generate 'devise User'
generate 'active_admin:install --skip-users'

insert_into_file 'config/initializers/active_admin.rb', <<-RUBY, after: "|config|\n"
  config.load_paths = [File.join(Rails.root, 'app/lib/aa')]
RUBY

file 'app/lib/my_omnibar.rb',    File.read(__dir__ + '/my_omnibar_template.rb')
file 'app/lib/other_omnibar.rb', File.read(__dir__ + '/other_omnibar_template.rb')
file 'app/lib/aa/users.rb',      File.read(__dir__ + '/user_resource_template.rb')

inject_into_class 'app/controllers/application_controller.rb', 'ApplicationController', <<-RUBY
  def index
    render html: (MyOmnibar.render + OtherOmnibar.render)
  end
RUBY

route 'mount RailsOmnibar::Engine => "/rails_omnibar"'
route 'root "application#index"'
route 'get "users/(*path)" => "application#index"'

rake 'db:migrate db:test:prepare'
