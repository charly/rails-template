# be rake rails:template LOCATION=~/Projects/templates/rails.rb

if yes?("add default gems to Gemfile (y/n) ?")
  gem 'inherited_resources'
  gem 'has_scope'
  #gem "nokogiri" # for scraping
  gem 'kronic'
  gem 'andand'
  ## view
  gem 'haml'

  gem_group :assets do
    # gem 'sass-rails',   '~> 3.0'
    gem 'bourbon'
    gem "omnigrid", :git => "git://github.com/charly/omnigrid.git"
    gem "haml-rails", :git => "git://github.com/charly/haml-rails.git"
    gem "backbonify"
    gem 'handlebars_assets'
    gem 'haml_assets'

    #gem 'coffee-rails', '~> 3.2.1'

    # See https://github.com/sstephenson/execjs#readme for more supported runtimes
    # gem 'therubyracer'

    # gem 'uglifier', '>= 1.0'
  end


  ## development
  gem_group :development do
    gem "method_lister"
    gem "thin"
    gem "quiet_assets"
  end

  gem_group :test do
    #gem "autotest"
    #gem "autotest-fsevent", :require => 'autotest/fsevent'
    gem "rspec-rails", "~>2.6"
    gem "factory_girl_rails"
    gem "database_cleaner"
    gem "jasmine", "1.1.2"
  end
end


file ".rvmrc", "rvm ree"

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


if yes?("Generate omnigrid (y/n) ?")
  generate("omnigrid:install")
  generate("omnigrid:theme")
end

if yes?("Backbonify Rails (y/n) ?")
  say("TODO")
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
run "rm app/views/layouts/application.html.erb"
say "!!!!!!! DONE !!!!!!!!"







