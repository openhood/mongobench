require "config"

conf = Conf.new :mongo
conf.bundler_require
conf.clean

conf.db[:mongo_driver].create_index(:a)
Benchmark.bm(25) do |x|
  x.report("#{conf.times} inserts:"){conf.times{|i| conf.db[:mongo_driver].insert(:a => i, :b => conf.times-i)}}
  x.report("#{conf.times} lookups:"){conf.times{|i| conf.db[:mongo_driver].find_one(:a => i)}}
  x.report("#{conf.times/25} select alls:"){(conf.times/25).times{|i| conf.db[:mongo_driver].find.to_a}}
  x.report("#{conf.times} updates:"){conf.times{|i| conf.db[:mongo_driver].update({:a => i}, {'$set' => {:b => i}})}}
  x.report("#{conf.times} deletes:"){conf.times{|i| conf.db[:mongo_driver].remove(:a => i)}}
end