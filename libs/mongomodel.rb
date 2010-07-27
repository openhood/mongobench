require "config"

conf = Conf.new :mongomodel
conf.bundler_require
conf.clean

MongoModel.configuration = { 'host' => 'localhost', 'database' => conf.db_name }

class MongoModelObject < MongoModel::Document
  property :a, Integer
  property :b, Integer
  index :a
  ensure_indexes!
end

Benchmark.bm(25) do |x|
  x.report("#{conf.times} inserts:"){conf.times{|i| MongoModelObject.create!(:a => i, :b => conf.times-i)}}
  x.report("#{conf.times} lookups:"){conf.times{|i| MongoModelObject.where(:a => i).first}}
  x.report("#{conf.times/25} select alls:"){(conf.times/25).times{|i| MongoModelObject.all.to_a}}
  x.report("#{conf.times} updates:"){conf.times{|i| MongoModelObject.where(:a => i).first.update_attributes(:b => i)}}
  x.report("#{conf.times} deletes:"){conf.times{|i| MongoModelObject.where(:a => i).first.destroy}}
end
