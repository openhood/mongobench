require "config"

conf = Conf.new :mongo_mapper
conf.bundler_require
conf.clean

MongoMapper.connection = conf.connection
MongoMapper.database = conf.db_name
class MongoMapperObject
  include MongoMapper::Document
  key :a, Integer, :index => true
  key :b, Integer
end
Benchmark.bm(25) do |x|
  x.report("#{conf.times} inserts:"){conf.times{|i| MongoMapperObject.create!(:a => i, :b => conf.times-i)}}
  x.report("#{conf.times} lookups:"){conf.times{|i| MongoMapperObject.first(:a => i)}}
  x.report("#{conf.times/25} select alls:"){(conf.times/25).times{|i| MongoMapperObject.all.to_a}}
  x.report("#{conf.times} updates:"){conf.times{|i| MongoMapperObject.first(:a => i).update_attributes(:b => i)}}
  x.report("#{conf.times} deletes:"){conf.times{|i| MongoMapperObject.first(:a => i).destroy}}
end
