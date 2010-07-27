require "config"

conf = Conf.new :sequel
conf.bundler_require
conf.clean

$:.unshift(File.expand_path("../sequel-mongo/lib", File.dirname(__FILE__)))
MONGO = Sequel.connect('mongo:///' + conf.db_name)
MONGO[:t].add_index :a
Benchmark.bm(25) do |x|
  x.report("#{conf.times} inserts:"){conf.times{|i| MONGO[:t].insert(:a=>i, :b=>conf.times - i)}}
  x.report("#{conf.times} lookups:"){conf.times{|i| MONGO[:t][:a=>i]}}
  x.report("#{conf.times/25} select alls:"){(conf.times/25).times{|i| MONGO[:t].all}}
  x.report("#{conf.times} updates:"){conf.times{|i| MONGO[:t].filter(:a=>i).update(:b=>i)}}
  x.report("#{conf.times} deletes:"){conf.times{|i| MONGO[:t].filter(:a=>i).delete}}
end
