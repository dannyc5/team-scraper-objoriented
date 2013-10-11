require 'nokogiri'
require 'open-uri'
require 'pry'
class Student
  attr_accessor :name, :twitter, :linkedin, :facebook, :website
  attr_reader :id
 
  @@students = []
 
 
  def initialize(hash = {})
    @@students << self
    @name = hash[:name] 
    @twitter = hash[:twitter]
    @facebook = hash[:facebook]
    @linkedin = hash[:linkedin]
    @website = hash[:website]
    @id = @@students.length
 
    clean_up_name
  end
 
  def clean_up_name
    if @name.nil?
     @name = "Rosie Hoyem"
   elsif @name == "Student Name"
     @name = "Saron Yitbarek"
   end
  end
 
  def self.all
    @@students
  end
 
  def self.find(id)
    @@students.select { |s| s.id == id }.first
  end
 
  def self.reset_all
    @@students.clear
  end
 
  def self.find_by_name(name)
    @@students.select { |s| s.name.downcase == name.downcase }
  end
 
  def self.delete(id)
 
    user = self.find(id)
    index = @@students.index(user)
    @@students.delete_at(index)
  end
 
end
 
 
class Scraper
 
  URL = "http://students.flatironschool.com/"
 
  attr_accessor :urlmap
 
  def initialize(url = URL)
    @url = url 
  end
 
  def call
    main_page = Nokogiri::HTML(open(@url))
    all_students = main_page.css('.home-blog').css('.blog-thumb a')
    links_to_crawl = all_students.map { |std| std.attributes["href"].value  }
    @urlmap = links_to_crawl.map { |link| "http://students.flatironschool.com/" + link  }
    @urlmap[5] = "http://students.flatironschool.com/students/stephanie_oh.html"
 
    self.urlmap.map do |student_url|
      linkedin, facebook, twitter, website, name = nil
      site = Nokogiri::HTML(open(student_url))
      begin
        name = site.css('.ib_main_header').children[0].text || "name"
      rescue
        name = nil
      end
      begin
        website = site.at('p:contains("Favorite Website")').children[1].children.text
      rescue
        website = nil
      end
 
      site.css('.social-icons a').each do |site_name|
        if site_name.attributes["href"].value.include?("facebook")
          facebook = site_name.attributes["href"].value
        elsif site_name.attributes["href"].value.include?("linkedin")
          linkedin = site_name.attributes["href"].value
        elsif site_name.attributes["href"].value.include?("twitter")
          twitter = site_name.attributes["href"].value
        end
      end
     
     Student.new({:name => name, :twitter => twitter, :facebook => facebook, :linkedin => linkedin, :website => website})
 
    end
 
  end
 
end
 
class CommandLine
 
  def initialize
    s = Scraper.new
    s.call
    @on = true
    greeting
  end
 
  def on?
      @on
  end
 
  def browse
      puts "Here is the index of students in the jungle."
     Student.all.each { |student| puts "#{student.id}. #{student.name}"  }
  end
 
  def show
    puts "Enter a Student's full name or ID number."
    student = gets.chomp.downcase
 
    output = (if student.to_i == 0
     Student.find_by_name(student)[0]
    else
     Student.find(student.to_i)
    end)
    puts "\nName: " + output.name if output.name != nil
    puts "Twitter: " + output.twitter if output.twitter != nil
    puts "Facebook: " + output.facebook if output.facebook != nil
    puts "LinkedIn: " + output.linkedin if output.linkedin != nil 
    puts "Website: " + output.website if output.website != nil
  end
 
  def help
    puts "\nThe jungle is a rough place, you get eaten by a wild #{["Spencer", "Scott", "John"].shuffle.first}, gotta watch out for those TAs. \n"
  end
 
  def greeting
    puts "\nWelcome to the Jungle... Of Flatiron Students.\n"
    puts "If you need to see the list of students, type 'browse'"
    puts "If you wish to see data on a specific student, type 'show'"
    puts "If you wish to leave the jungle, type 'exit'"
    puts "If you are lost in the jungle, type 'help'"
 
    while @on
      puts "\nYou're stuck in the jungle, what do you want to do? \n"
      input = gets.chomp.downcase
      case input
      when "browse"
        browse
      when "show"
        show
      when "exit"
        exit
      when "help"
        help
      else
          puts "\nYou got eaten by a wild Avi. Lose one life. Please try again.\n"
      end
    end
  end
 
end
 
cli = CommandLine.new