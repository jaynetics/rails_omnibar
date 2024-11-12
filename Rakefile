require 'rake'
require 'bundler/gem_tasks'
require 'rubygems/package_task'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new
task default: [:compile_js, :generate_spec_app, :spec]

desc 'Compile the JavaScript'
task :compile_js do
  sh 'npm run build'
end

desc 'Generate a dummy rails app for testing'
task :generate_spec_app do
  sh 'rm -rf spec/dummy'
  sh *%w[
    rails new spec/dummy
    --template=spec/templates/app_template.rb
    --skip-action-cable
    --skip-action-mailbox
    --skip-action-text
    --skip-active-job
    --skip-active-storage
    --skip-asset-pipeline
    --skip-bootsnap
    --skip-bundle
    --skip-git
    --skip-hotwire
    --skip-javascript
    --skip-jbuilder
    --skip-keeps
    --skip-listen
    --skip-spring
    --skip-system-test
    --skip-test
    --skip-turbolinks
    --skip-webpack
  ]
end

# ensure fresh js is compiled when packaging the gem
task build: [:compile_js]

desc 'Launch server of spec/dummy app'
task :s do
  sh 'spec/dummy/bin/rails s'
end

desc 'Use local modified omnibar2 dependency'
task :dev_js do
  sh <<~SH
    npm --prefix ../omnibar2 run build &&
    rm -rf node_modules/omnibar2 &&
    cp -r ../omnibar2 ./node_modules &&
    rm -rf ./node_modules/omnibar2/node_modules &&
    rake compile_js
  SH
end
