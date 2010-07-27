require "config"

conf = Conf.new :mongo_doc
conf.bundler_require
conf.clean

MongoDoc::Connection.name = conf.db_name
MongoDoc::Connection.host = "localhost"
MongoDoc::Connection.port = "27017"

class MongoDocObject
  include MongoDoc::Document

  attr_accessor :a
  attr_accessor :b
  index :a
end

Benchmark.bm(25) do |x|
  x.report("#{conf.times} inserts:"){conf.times{|i| MongoDocObject.create(:a => i, :b => conf.times-i)}}
  x.report("#{conf.times} lookups:"){conf.times{|i| MongoDocObject.where(:a => i).first}}
  x.report("#{conf.times/25} select alls:"){(conf.times/25).times{|i| MongoDocObject.all.to_a}}
  x.report("#{conf.times} updates:"){conf.times{|i| MongoDocObject.where(:a => i).first.update_attributes(:b => i)}}
  x.report("#{conf.times} deletes:"){conf.times{|i| MongoDocObject.where(:a => i).first.remove}}
end
