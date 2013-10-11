# 1. Make a Student class to pass this test.
# https://github.com/flatiron-school/003-School-Domain

# 2. Object Orient Your Scrape
# You should be able to do something like:
# main_index_url = "http://students.flatironschool.com"
# student_scrape = StudentScraper.new(main_index_url)
# student_hashes = student_scrape.call
# # Where student_hashes looks something like
# # [{:name => "Avi", :website => "http://flatironschool.com"}, {next_student}, {}]

# 3. Use the data from the student_scraper to instantiate a bunch of students.

# 4. Create a class that represents a CLI for the Student Site, maybe CLIStudent, so that:
# CLIStudent.new(students) # Where students are a bunch of student instances.
# CLIStudent.call
# The CLIStudent should have a browse (which lists all students), a help, an exit, and a show (by ID or name), which will show all the data of a student.


class Student
  attr_accessor :name,:twitter,:linkedin,:facebook,:website
  @@students=[]
  
  def initialize
    @@students << self 
  end

  def self.all  
    @@students
  end

  def self.reset_all
    @@students.clear
  end

  def self.find_by_name(sname)
     @@students.select do |student|
        student.name.downcase==sname.strip.downcase
     end
  end

end

 