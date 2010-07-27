require "benchmark"
require "rubygems"
require "bundler"

class Conf
  def initialize(group = :default)
    @group = group
  end
  
  def bundler_require
    Bundler.require :default, @group
  end
  
  def db_name
    "mongobench_#{@group}"
  end
  
  def connection
    @connection ||= Mongo::Connection.new
  end
  
  def db
    @db ||= connection.db(db_name)
  end
  
  def clean
    db.collections.each{|c| c.remove}
  end
  
  def times
    if block_given?
      1000.times{|i| yield i }
    else
      1000
    end
  end
end