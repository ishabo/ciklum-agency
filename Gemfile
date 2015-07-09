source 'https://rubygems.org'
ruby '2.2.1'

gem 'rails'
gem 'bootstrap-sass', '2.1'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker'
gem 'will_paginate', '3.0.5'
gem 'bootstrap-will_paginate', '0.0.6'
gem 'jquery-rails', '2.0.2'
gem "haml-rails"
gem "fancybox-rails"
gem "highcharts-rails", "~> 2.3.3.1"
gem 'tinymce-rails'
gem "pony", "~> 1.4"
gem 'jquery-ui-rails'
gem "jquery-ui-themes"
git 'git://github.com/rweng/jquery-datatables-rails.git' do
  gem 'jquery-datatables-rails'
end
gem "json", "1.8.3"
gem 'coffee-rails'
gem 'rb-readline'
gem 'protected_attributes'

group :development, :test do

  gem 'spring'
  gem 'sqlite3'
  gem 'rspec-rails', :require => false 
  gem 'rspec-collection_matchers'
  gem 'spork'  
  gem 'guard'
  gem 'guard-rspec', :require => false 
  gem 'guard-livereload'
  gem 'guard-spork'
  gem 'childprocess'
  gem 'to_factory'
  #gem 'growl_notify'
  #gem 'ruby_gntp'
  #gem 'growl'
  #gem 'ruby-debug19'
  gem "reek", "~> 1.3.2" 

  gem 'web-console'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring


  #gem "ZenTest"
  #gem "autotest-rails"
  #gem "autotest-growl"
  #gem "autotest-fsevent"
  #gem "redgreen"
  #gem 'linecache19', '0.5.12', :path => "~/.rvm/gems/ruby-1.9.3-p448/gems/linecache19-0.5.12/"
  #gem 'turn'

end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'uglifier', '1.2.3'
end

group :test do
  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git'
  gem 'factory_girl_rails'
  gem 'cucumber'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'rspec-rails-mocha', '~> 0.3.1', :require => false
  gem 'rspec-activemodel-mocks'
  # gem 'rb-fsevent', '0.9.1', :require => false
end

group :test, :development, :production do
  gem 'mysql2'
end
group :production do
  #gem 'pg'
end