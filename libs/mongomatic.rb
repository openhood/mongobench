require "config"

conf = Conf.new :mongomatic
conf.bundler_require
conf.clean

Mongomatic.db = Mongo::Connection.new.db conf.db_name

class MongomaticObject < Mongomatic::Base
  def self.create_indexes
    collection.create_index "a"
  end
end
MongomaticObject.create_indexes

Benchmark.bm(25) do |x|
  x.report("#{conf.times} inserts:"){conf.times{|i| MongomaticObject.new("a" => i, "b" => conf.times-i).insert}}
  x.report("#{conf.times} lookups:"){conf.times{|i| MongomaticObject.find_one("a" => i)}}
  x.report("#{conf.times/25} select alls:"){(conf.times/25).times{|i| MongomaticObject.find.to_a}}
  x.report("#{conf.times} updates:") do
    conf.times do |i|
      obj = MongomaticObject.find_one("a" => i)
      obj.merge("b" => i)
      obj.update
    end
  end
  x.report("#{conf.times} deletes:"){conf.times{|i| MongomaticObject.find_one("a" => i).remove}}
end
