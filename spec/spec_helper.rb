require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'


Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

end

Spork.each_run do
  # This code will be run each time you run your specs.
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.







RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  config.mock_framework = :rspec
  config.mock_with :rspec
  # config.mock_with :flexmock
  # config.mock_with :rr

  config.render_views
  config.include FactoryGirl::Syntax::Methods
  config.include Rails.application.routes.url_helpers
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  #ActiveRecord::Base.logger = Logger.new(STDOUT)
end

class EventualValueMatcher
  def initialize(&block)
    @block = block
  end

  def ==(value)
    @block.call == value
  end
end

def eventual_value(&block)
  EventualValueMatcher.new(&block)
end

class FabricateServices


  def initialize(service_type, success_status, user, total = 60, years = (2011..2012))
    @user = user
    @years = years
    @total = total 
    @service_type = service_type
    @success_status = Service.statuses[success_status]
    @total_created ||= 0

  end


  def project_statuses
    {:pending => 'O-O', :won => 'Urrraahh!', :lost => 'Ay yay yay!'}
  end

  def with_monthly_dist(with_project_statuses = true)
    total_per_year_per_month = (@total / @years.count / 12 )
    @years.step(1) do |year|
      1.upto(12) do |month|  
        if with_project_statuses
          project_statuses.each { |project_status, comment| create_servics(total_per_year_per_month/project_statuses.count, {:project_status => project_status, :comment => comment, :year => year, :month => month}) } 
        else
          create_servics(total_per_year_per_month, {:year => year, :month => month})
        end
      end
    end
    self
  end

  def with_project_statuses
    total_per_project_status_per_year = (@total / 3 / @years.count).round

    @years.step(1) do |year|
      project_statuses.each { |project_status, comment| create_servics(total_per_project_status_per_year, {:project_status => project_status, :comment => comment, :year => year})}
    end
    self
  end

  def create_servics(amount, attributes)
    attributes[:month] ||= (1..12).to_a.sample
    attributes[:comment] ||= 'Test!'
    attributes[:project_status] ||= :pending
    amount.round.times do |time|
      obj = FactoryGirl.create(:service,
                            consultant: @user,
                            service_type: @service_type,
                            success_status: @success_status,
                            start_date: "#{attributes[:year]}-#{attributes[:month]}-#{(1..28).to_a.sample}", 
                            project: FactoryGirl.create(:project, 
                                                        converted: Project.conversion_status[attributes[:project_status]],
                                                        status_comment: attributes[:comment])
                            )
     @total_created += 1
    end

    def total_created
      @total_created
    end
  end
end
