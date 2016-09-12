# be rake rails:template LOCATION=~/Projects/rails-template/template2.rb

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

copy_file "files/application.html.haml", "#{Rails.root}/app/views/layouts/application.html.haml"


if yes?("add default gems (y/n) ?")

  gem "angularjs-rails"
  gem 'bootstrap-sass'
  gem 'haml'
  gem 'inherited_resources'

  ## development
  gem_group :development do
    gem "pry-rails"
    gem "thin"
  end

  gem_group :test do
    gem "rspec-rails"
  end
end


if yes?("add cool gems (y/n) ?")
  gem 'siphon', git: 'git://github.com/charly/siphon.git'
  gem 'nexter', git: 'git://github.com/charly/nexter.git'
  gem 'ransack'

  gem "nokogiri" # for scraping

  #activerecord
  gem "active_model_serializers"
  gem "will_paginate"
  gem "state_machine"
  gem "awesome_nested_set"
  gem "acts_as_list"
end

file ".ruby-version", "2.0.0"

if yes?("run the bundle install (y/n) ?")
  say "installing all the gems...."
  run "bundle install --path vendor"
  run "echo 'vendor/ruby/' >> .gitignore"
  run "bundle package"
  run "bundle --binstubs"
end

if yes?("append generators configuration to application.rb (y/n) ?")
  config = <<-END
    # Configure generators values. Many other options are available, be sure to check the documentation.
    config.generators do |g|
      g.orm             :active_record
      g.template_engine :haml
      g.test_framework  :rspec, :fixture => false, :view_specs => false
      g.assets          false
      g.stylesheets     false
      g.helper          false
    end
  END
  insert_into_file "config/application.rb", config, :after => "class Application < Rails::Application\n"
end


if yes?("Generate RSPEC (y/n) ?")
  generate("rspec:install")
end

while yes?("scaffold some (y/n) ?") do
  say("Thing name fee:decimal position_id:integer category:belongs_to admin:true expected_at:date")
  #generate("scaffold")
end

say "Cleaning some cruft..."
run "rm public/index.html"
inside 'app' do
  run "rm views/layouts/application.html.erb"
end
say "!!!!!!! DONE !!!!!!!!"







