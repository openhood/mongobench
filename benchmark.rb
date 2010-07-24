require "benchmark"
require "bundler"
Bundler.require :default

puts "Cleaning old data..."
db_name = "mongobench"
connection = Mongo::Connection.new
db = connection.db(db_name)
db.collections.each{|c| c.remove}
db[:mongo_driver].create_index(:a)

n = 1000

puts "\n*** Mongo ruby driver ***"
Benchmark.bm(25) do |x|
  x.report("#{n} inserts:"){n.times{|i| db[:mongo_driver].insert(:a => i, :b => n-i)}}
  x.report("#{n} lookups:"){n.times{|i| db[:mongo_driver].find_one(:a => i)}}
  x.report("#{n/25} select alls:"){(n/25).times{|i| db[:mongo_driver].find.to_a}}
  x.report("#{n} updates:"){n.times{|i| db[:mongo_driver].update({:a => i}, {'$set' => {:b => i}})}}
  x.report("#{n} deletes:"){n.times{|i| db[:mongo_driver].remove(:a => i)}}
end

MongoMapper.connection = connection
MongoMapper.database = db_name
class MongoMapperObject
  include MongoMapper::Document
  key :a, Integer, :index => true
  key :b, Integer
end

puts "\n*** MongoMapper ***"
Benchmark.bm(25) do |x|
  x.report("#{n} inserts:"){n.times{|i| MongoMapperObject.create!(:a => i, :b => n-i)}}
  x.report("#{n} lookups:"){n.times{|i| MongoMapperObject.first(:a => i)}}
  x.report("#{n/25} select alls:"){(n/25).times{|i| MongoMapperObject.all.to_a}}
  x.report("#{n} updates:"){n.times{|i| MongoMapperObject.first(:a => i).update_attributes(:b => i)}}
  x.report("#{n} deletes:"){n.times{|i| MongoMapperObject.first(:a => i).destroy}}
end

Mongoid.configure do |config|
  config.master = db
end
class MongoidObject
  include Mongoid::Document
  field :a, :type => Integer
  field :b, :type => Integer
  index :a
end

puts "\n*** Mongoid ***"
Benchmark.bm(25) do |x|
  x.report("#{n} inserts:"){n.times{|i| MongoidObject.create!(:a => i, :b => n-i)}}
  x.report("#{n} lookups:"){n.times{|i| MongoidObject.first(:conditions => {:a => i})}}
  x.report("#{n/25} select alls:"){(n/25).times{|i| MongoidObject.all.to_a}}
  x.report("#{n} updates:"){n.times{|i| MongoidObject.first(:conditions => {:a => i}).update_attributes(:b => i)}}
  x.report("#{n} deletes:"){n.times{|i| MongoidObject.first(:conditions => {:a => i}).destroy}}
end