#!/bin/ruby
# -*- coding: utf-8 -*-
require 'sqlite'
class HTML
  def initialize(filename)
    @file = File.open(filename)
  end
  def getContext
    temp = String.new
    @file.each {|text| temp += text}
    return temp
  end
end
class REGEX
  def initialize(filename)
    @file = File.open(filename)
  end
  def getExpression
    temp = String.new
    @file.each {|text| temp += text}
    return temp
  end
end
class DATABASE
  #Database Connect Layer,type SQLite3
  def initialize(name)
    @db = SQLite::Database.new(name)
  end
  def query(string)
    return @db.execute(string)
  end
end
html = HTML.new("template")
regex = REGEX.new("regexp")
db = DATABASE.new("database.sqlite")
html.getContext.scan(/#{regex.getExpression}/).each {|arr|
  myListRank = 100*Float(arr[5])/Float(arr[3])
  #TODO:Insert data
}
