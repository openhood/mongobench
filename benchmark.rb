puts "\n*** Sequel with SQLite ***"
puts %x[ruby -I libs libs/sqlite_sequel.rb]

puts "\n*** Sequel with Mongo ***"
puts %x[ruby -I libs libs/mongo_sequel.rb]

puts "\n*** Mongo ruby driver ***"
puts %x[ruby -I libs libs/mongo_driver.rb]

puts "\n*** MongoMapper ***"
puts %x[ruby -I libs libs/mongomapper.rb]

puts "\n*** Mongoid ***"
puts %x[ruby -I libs libs/mongoid.rb]

puts "\n*** Mongomodel ***"
puts %x[ruby -I libs libs/mongomodel.rb]

puts "\n*** Candy ***"
puts %x[ruby -I libs libs/candy.rb]