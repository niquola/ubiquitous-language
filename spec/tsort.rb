require "tsort"

class Project
  attr_accessor :dependents, :name
  def initialize(name)
    @name = name
    @dependents = []
  end
end

class Sorter
  include TSort

  def initialize(col)
    @col = col
  end

  def tsort_each_node(&block)
    @col.each(&block)
  end

  def tsort_each_child(project, &block)
    @col.select { |i| i.name == project.name }.first.dependents.each(&block)
  end
end

r5 = Project.new :r5
r2 = Project.new :r2

r11 = Project.new :r11
r11.dependents << r5
r11.dependents << r2

r3 = Project.new :r3
r10 = Project.new :r10
r10.dependents << r11
r10.dependents << r3

r8 = Project.new :r8
r9 = Project.new :r9
r9.dependents << r8
r9.dependents << r11

r7 = Project.new :r7
r8.dependents << r3
r8.dependents << r7

col = [r5, r2, r11, r3, r10, r9, r7, r8, r5]

result = Sorter.new(col).tsort
puts result.map(&:name).inspect
