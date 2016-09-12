# be rake rails:template LOCATION=~/Projects/rails-template/template3.rb
# http://www.rubydoc.info/github/wycats/thor/Thor/Actions

def self.source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

def self.homepage(default = false)
  if default or yes?("Start a new home#page (y/n) ?")
    route "root 'home#index'"
    self.file "app/controllers/home_controller.rb", <<-CTRL.strip_heredoc
      class HomeController < ApplicationController
        def index(); end
      end
      CTRL
    file "app/views/home/index.html.haml", ".row home"
  end
end

def self.bootstrap_layout(default = false)
  if default or yes?("Do you want a bootstrap layout instead of a default (y/n) ?")
    copy_file "files/application.bootstrap.html.haml", "app/views/layouts/application.html.haml"
  else
    copy_file "files/application.bare.html.haml", "app/views/layouts/application.html.haml"
  end
end

if true
  file ".ruby-version", "2.2"
  run "rm app/views/layouts/application.html.erb"
  inside "app/assets" do
    # run "rm app/views/layouts/application.html.erb"
    run 'mv stylesheets/application.css stylesheets/application.scss'
  end
end


#-----------------------
#
#    SHIT STARTS HERE
#
#-----------------------
template_choice = ask("do you want [1]:bare app, [2]:default app or [3]:custom app ?")

default = template_choice == "2" ? true : false


#-----------------------
#
#      1. BARE APP
#
#-----------------------
if template_choice == "1"
  say ""
  bootstrap_layout(true)
  homepage(true)
  gem "haml-rails"
  gem 'bootstrap-sass'
  import = <<-BOOT

@import "bootstrap-sprockets";
@import "bootstrap";
BOOT
  append_to_file "app/assets/stylesheets/application.scss", import
end

#-----------------------
#
#   2. TRUE RAILS APP
#
#-----------------------
if template_choice == "2"

  bootstrap_layout(default)
  homepage(default)
  run "echo 'vendor/ruby/\n.DS_Store' >> .gitignore"

  if default || yes?("append generators configuration to application.rb (y/n) ?")
    config = <<-END
      # Configure generators values.
      # Many other options are available, be sure to check the documentation.
      config.generators do |g|
        g.orm             :active_record
        g.template_engine :haml
        g.test_framework  :test_unit, fixture: false, view_specs: false
        g.assets          false
        g.stylesheets     false
        g.helper          false
      end
    END
    insert_into_file "config/application.rb", config, after: "class Application < Rails::Application\n"
  end

  run("cat Gemfile")
  if default || yes?("Do you want nicely configured Gemfile or Rail's default (y/n) ?")
    run("mv Gemfile Gemfile.default_rails")
    copy_file "files/Gemfile", "Gemfile"
  end


  if yes?("run the bundle install (y/n) ?")
    say "installing all the gems...."
    run "bundle install --path vendor"
    run "bundle package"
    # run "bundle --binstubs"
  end
end



if yes?("Do more stuff : rspec, create db, scaffolds (y/n) ?")
  if yes?("Generate RSPEC (y/n) ?")
    generate("rspec:install")
  end

  if yes?("Create some database (y/n) ?")
    run "bin/rake db:create"
  end

  if yes?("Care for some angular (y/n) ?")
    file "app/assets/javascripts/application.js", "//require angular\n"
  end

  while yes?("scaffold some (y/n) ?") do
    say("Thing name fee:decimal position_id:integer category:belongs_to admin:true expected_at:date")
    generate("scaffold")
  end
end

# say "Cleaning some cruft..."
# run "rm public/index.html"
say "!!!!!!! DONE !!!!!!!!"
say "----------------------------------------------------------------------"
say "To re-apply this template :"
say "be rake rails:template LOCATION=~/Projects/rails-template/template3.rb"
say "http://www.rubydoc.info/github/wycats/thor/Thor/Actions"
say "If you haven't yet remember to 'bundle --path vendor' the 1st time:"
say "bundle --path vendor && bundle package"
say "----------------------------------------------------------------------"

