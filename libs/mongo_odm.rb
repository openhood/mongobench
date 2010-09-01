require "config"

conf = Conf.new :mongo_odm
conf.bundler_require
conf.clean

MongoODM.connection = conf.connection
MongoODM.config = {:database => conf.db_name}

class MongoOdmObject
  include MongoODM::Document
  field :a, Integer
  field :b, Integer
  create_index :a
end
Benchmark.bm(25) do |x|
  x.report("#{conf.times} inserts:"){conf.times{|i| MongoOdmObject.new(:a => i, :b => conf.times-i).save}}
  x.report("#{conf.times} lookups:"){conf.times{|i| MongoOdmObject.find_one(:a => i)}}
  x.report("#{conf.times/25} select alls:"){(conf.times/25).times{|i| MongoOdmObject.find.to_a}}
  x.report("#{conf.times} updates:"){conf.times{|i| MongoOdmObject.find_one(:a => i).update_attributes(:b => i)}}
  x.report("#{conf.times} deletes:"){conf.times{|i| MongoOdmObject.find_one(:a => i).destroy}}
end
