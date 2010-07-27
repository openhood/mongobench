require "config"

conf = Conf.new :mongo_record
conf.bundler_require
conf.clean

MongoRecord::Base.connection = conf.db

class MongoRecordObject < MongoRecord::Base
  collection_name :mongo_record_objects
  fields :a, :b
  index :a
end

Benchmark.bm(25) do |x|
  x.report("#{conf.times} inserts:"){conf.times{|i| MongoRecordObject.create(:a => i, :b => conf.times-i)}}
  x.report("#{conf.times} lookups:"){conf.times{|i| MongoRecordObject.first(:conditions => {:a => i})}}
  x.report("#{conf.times/25} select alls:"){(conf.times/25).times{|i| MongoRecordObject.all.to_a}}
  x.report("#{conf.times} updates:"){conf.times{|i| MongoRecordObject.first(:conditions => {:a => i}).update_attributes(:b => i)}}
  x.report("#{conf.times} deletes:"){conf.times{|i| MongoRecordObject.first(:conditions => {:a => i}).destroy}}
end
