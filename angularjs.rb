# be rake rails:template LOCATION=~/Projects/rails-template/angularjs.rb

name = ask("what angulars resource would you like to create ?")

names = name.pluralize
name  = name.singularize

say name
say names
say name.camelize

exit if yes?("exit ?")

inside "app/assets/javascripts/angular" do
  file "controllers/#{name}_controller", <<-CODE
#
app.controller('#{name}', function(){


})
CODE
end