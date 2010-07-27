require "config"

conf = Conf.new :mongoid
conf.bundler_require
conf.clean

Mongoid.configure do |config|
  config.master = conf.db
end
class MongoidObject
  include Mongoid::Document
  field :a, :type => Integer
  field :b, :type => Integer
  index :a
end
MongoidObject.collection # needed for next line to work!!
MongoidObject.create_indexes
Benchmark.bm(25) do |x|
  x.report("#{conf.times} inserts:"){conf.times{|i| MongoidObject.create!(:a => i, :b => conf.times-i)}}
  x.report("#{conf.times} lookups:"){conf.times{|i| MongoidObject.first(:conditions => {:a => i})}}
  x.report("#{conf.times/25} select alls:"){(conf.times/25).times{|i| MongoidObject.all.to_a}}
  x.report("#{conf.times} updates:"){conf.times{|i| MongoidObject.first(:conditions => {:a => i}).update_attributes(:b => i)}}
  x.report("#{conf.times} deletes:"){conf.times{|i| MongoidObject.first(:conditions => {:a => i}).destroy}}
end
