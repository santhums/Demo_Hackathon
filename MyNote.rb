require "mysql2"
#STDOUT.sync = true

$con = Mysql2::Client.new(:host =>"localhost", :username =>"root", :password =>"root", :database =>"MyDiary")
 
def date
  Time.now.strftime("%d/%m/%Y %H:%M")
end

def getit
  puts "Enter the content: "
   ch=gets.chomp
  $con.query("insert into memo values('','#{date()}', '#{ch}')")
  puts "Saved"
end

def showit
  print " No\tDate\t\t\tContent\n"
  results = $con.query("SELECT * FROM memo")
  results.each(:cache_rows => false) do |row| 
     print "#{row['no'].to_s} \t #{row['ddate'].to_s} \t #{row['content'].to_s} \n"
    end
end

def clean
  print "Are you sure ..?(y/n):- "
  c = gets.chomp
  return if c == "n"
  print "Your Code : "
  cd = gets.chomp
  exit if cd != "3658"
  $con.query("delete from memo")
  puts "Diary is now clean "
  return
end

def search
  print "Date :- "
  d = gets.chomp
  print "No\tDate\t\t\tContent\n"
  results = $con.query("SELECT * FROM memo WHERE ddate LIKE '#{d}%'")
  results.each(:cache_rows => false) do |row|
     #if (!results)
  	 #  puts "Invalid Date"
     #end
     print "#{row['no'].to_s} \t #{row['ddate'].to_s} \t #{row['content'].to_s} \n"
    end
end



begin
  loop do
  	print "MY Note"
  	print "\n 1. New \n 2. View \n 3. Search \n 4. Clear All \n 5. Exit\n"
  	puts
  	print "Choose : "
	option = gets.chomp
	puts `clear`
	case option
	when "1"
	  getit()
	when "2"
	  showit()
	when "3"
	  search()
	when "4"
	  clean()
	when "5"
	  exit
	else
	  puts "Wrong Choice! "
	end

  end
rescue Mysql2::Error => e
  puts e.errno
  puts e.error
ensure
  $con.close if $con
end


