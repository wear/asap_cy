# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
 RAILS_GEM_VERSION = '2.3.3' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require 'crack/xml'
require 'rmmseg/ferret'   
require 'acts_as_ferret'
 
# dictionaries needed to be explicitly loaded
# RMMSeg::Dictionary.load_dictionaries
$KCODE = 'u'

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug  
  # 
  config.i18n.default_locale = :cn
  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_cy_session',
    :secret      => '6d6bbf29819bab7be65d3d2c6971012e9bb9d77f02b3bc49901fa5e835ea3da7e1e6ac1d3e4858842c469817c312a0baba4f8546532cbabdda7ec2bf86274ed9'
  }                  
  
  config.load_paths += %W( #{RAILS_ROOT}/app/sweepers )
  config.action_controller.page_cache_directory = RAILS_ROOT + "/public/cache"
          
  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector 
  config.time_zone = 'Beijing'
  # config.active_record.observers = :user_observer
  # need to user server setting
  config.action_mailer.raise_delivery_errors = true

end
 
ExceptionNotifier.exception_recipients = %w(wear63659220@gmail.com)   
 
ActionMailer::Base.smtp_settings = {
   :tls => true,
   :address => "smtp.gmail.com",
   :port => "587",
   :domain => "muutang.com",
   :authentication => :plain,
   :user_name => "support@muutang.com",
   :password => "tellmewhy" 
 }
 
 if defined?(PhusionPassenger)
   # monkey patch drb so we can close its connections
   class DRb::DRbConn
     def self.close_all
       @mutex.synchronize do
         @pool.each {|c| c.close}
         @pool = []
       end
     end
   end

   PhusionPassenger.on_event(:starting_worker_process) do |forked|
     if forked
       DRb::DRbConn.close_all  # ferret
     else
       # We’re in conservative spawning mode. We don’t need to do anything.
     end
   end
 end
