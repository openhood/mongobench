{
  "Sequel with SQLite" => "sqlite_sequel",
  "Sequel with Mongo" => "mongo_sequel",
  "Mongo ruby driver" => "mongo_driver",
  "MongoMapper" => "mongomapper",
  "Mongoid" => "mongoid",
  "MongoModel" => "mongomodel",
  "Candy" => "candy",
  "MongoRecord" => "mongo_record",
  "MongoDoc" => "mongo_doc",
  "Mongomatic" => "mongomatic",
}.each_with_index do |(name, filename), i|
  sleep 10 unless i.zero?
  puts "\n*** #{name} ***"
  puts %x[ruby -I libs libs/#{filename}.rb]
end