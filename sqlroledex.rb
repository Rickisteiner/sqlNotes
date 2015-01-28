require 'sqlite3'
# http://www.rubydoc.info/gems/sqlite3/1.3.10
require 'pry'
# select a database, or create it if it does not yet exist
db = SQLite3::Database.new "rolodex.db"

# if this is the first time running the code this table will be created, otherwise this step will be skipped
rows = db.execute <<-SQL
create table if not exists friends (
  ID INTEGER PRIMARY KEY, 
  name TEXT, 
  phone INTEGER
  );
  SQL

  # the meat and potatoes
  puts "what would you like to do? (C)reate, (R)ead, (U)pdate, or (D)estroy?"
  response = gets.chomp.downcase
  # create an entry
  if response == 'c'
  puts "person's name, please"
  name = gets.chomp.downcase
  puts "person's phone number, please"
  phone = gets.chomp
  # the actual code to insert the new entry
  db.execute("INSERT INTO friends (name, phone) VALUES (?, ?)", name, phone)
  # since the entry automatically happens at the end of the table, we can now select the last entry and display it so the user can see that their entry worked.
  person = db.execute("SELECT name,phone FROM friends WHERE id=(SELECT MAX(ID) FROM friends);");
  puts "#{person[0][0]}'s phone number is #{person[0][1]}" #it's in an array
  end
  # look everyone up
  
  if response == 'r'
  # grab only the name and phone number of everyone and display them
  all = db.execute("SELECT name,phone FROM friends");
  all.each do |entry|
  puts "#{entry[0]}'s phone number is #{entry[1]}" #now it's in an array so we need to grab the index not the variables.
  end
  end
  
  # update an entry
  if response == 'u'
  # get a list of everyone so we can select the correct person by id
  all = db.execute("SELECT * FROM friends");
  #puts all
  # loop through the names and print them to the terminal
  all.each do |entry|
  puts "#{entry[1]}'s phone number is #{entry[2]}. To select #{entry[1]}, enter ID NUMBER (#{entry[0]}) of #{entry[1]}."
  # grab an id and new phone number from the user
  end
  puts "which id will you update?"
  id = gets.chomp.downcase
  puts "what is their new number?"
  number = gets.chomp
  # update the entry
  db.execute("UPDATE friends SET phone=? WHERE id=?",number,id); #the ? is adding a param
  # get the updated entry so the user can see that the change happened
  person = db.execute("SELECT name,phone FROM friends WHERE id=?",id);
  puts "#{person[0][0]}'s phone number is now #{person[0][1]}"
  end
  
  # delete an entry
  if response == 'd'
  # get a list of everyone so we can select the correct person by id
  all = db.execute("SELECT * FROM friends")
  all.each do |entry|
  puts "#{entry[1]}'s phone number is #{entry[2]}. To select #{entry[1]}, enter ID NUMBER (#{entry[0]}) of #{entry[1]}."
  end
  puts "which id will you delete?"
  id = gets.chomp.downcase
  # delete the entry
  db.execute("DELETE FROM friends WHERE id=?",id);
  puts "buuuuurn"
  end