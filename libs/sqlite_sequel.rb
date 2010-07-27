require "config"

conf = Conf.new :sequel
conf.bundler_require
conf.clean

SQLITE = Sequel.sqlite('nosequel.sqlite')
SQLITE.create_table!(:t) do
  primary_key :_id
  Integer :a
  Integer :b
  index :a
end
Benchmark.bm(25) do |x|
  x.report("#{conf.times} inserts:"){conf.times{|i| SQLITE[:t].insert(:a=>i, :b=>conf.times - i)}}
  x.report("#{conf.times} lookups:"){conf.times{|i| SQLITE[:t][:a=>i]}}
  x.report("#{conf.times/25} select alls:"){(conf.times/25).times{|i| SQLITE[:t].all}}
  x.report("#{conf.times} updates:"){conf.times{|i| SQLITE[:t].filter(:a=>i).update(:b=>i)}}
  x.report("#{conf.times} deletes:"){conf.times{|i| SQLITE[:t].filter(:a=>i).delete}}
end