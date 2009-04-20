# bootstrap.rb
# 25 de agosto de 2007
#

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'


namespace :db do
  desc "Loads a schema.rb file into the database and then loads the initial database fixtures."
  task :bootstrap => ['db:bootstrap:load']
    namespace :bootstrap do
       desc "Load initial database fixtures (in db/bootstrap/*.yml) into the current environment's database. Load specific fixtures using FIXTURES=x,y"
       task :load => :environment do
         require 'active_record/fixtures'

         ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
         
         ActiveRecord::ConnectionAdapters::DatabaseStatements.class_eval do
           def delete_fixture(fixture, table_name)
             klass = fixture.class_name.is_a?(Class) ? fixture.class_name : Object.const_get(fixture.class_name) rescue nil

             if klass && fixture[klass.primary_key]
               klass.delete(fixture[klass.primary_key])
             else
               conditions = fixture.to_hash.collect do |attr, value|
                 "#{table_name}.#{quote_column_name(attr)} " + (value.nil? ? 'IS NULL' : ('= ' + quote(value, attr).to_s))
               end.join(' and ')
       
               execute "DELETE FROM #{table_name} where #{conditions}", "Fixture Delete"                            
             end
           end
         end
         
         Fixtures.class_eval do
           def delete_existing_fixtures
           end
           
           def insert_fixtures
             values.each do |fixture|
               @connection.delete_fixture fixture, @table_name
               @connection.insert_fixture fixture, @table_name
             end
           end
         end
         
         (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(RAILS_ROOT, 'db', 'bootstrap', '*.{yml,csv}'))).each do |fixture_file|
           Fixtures.create_fixtures('db/bootstrap', File.basename(fixture_file, '.*'))
         end
       end
     end
     
     desc "rebuild and initial sumary"
     task :vendor_initial => :environment do
       Vendor.find(:all).each do |vendor|
         vendor.set_score
       end
     end
end
