require "config"

conf = Conf.new :candy
conf.bundler_require
conf.clean

Candy.db = conf.db
class CandyObject
  include Candy::Piece
end
class CandyObjects
  include Candy::Collection
  collects CandyObject
end

Benchmark.bm(25) do |x|
  x.report("#{conf.times} inserts:"){conf.times{|i| CandyObject.new(:a => i, :b => conf.times-i)}}
  x.report("#{conf.times} lookups:"){conf.times{|i| CandyObjects(limit: 1, a: i)}}
  x.report("#{conf.times/25} select alls:"){(conf.times/25).times{|i| CandyObjects.all.to_a}}
  x.report("#{conf.times} updates:"){conf.times{|i| CandyObjects(limit: 1, a: i).first[:b] = i}}
end