#!/bin/ruby
# -*- coding: utf-8 -*-
require 'sqlite3'
class HTML
  #TODO:Replace to a curl Webpage Grabber
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
    @db = SQLite3::Database.new(name)
  end
  def query(string)
    return @db.execute(string)
  end
  def insert(uploadDate,smNumber,numViews,numComments,numMyList,numAds)
    return @db.execute("INSERT INTO list (uploadDate,smNumber,numViews,numComments,numMyList,numAds) VALUES ('#{uploadDate}','#{smNumber}','#{numViews}','#{numComments}','#{numMyList}','#{numAds}');")
  end
end
html = HTML.new("template")
regex = REGEX.new("regexp")
db = DATABASE.new("database.sqlite")
#list = {uploadDate,smNumber,numViews,numComments,numMyList,numAds,recodeDate}
html.getContext.scan(/#{regex.getExpression}/).each {|arr|
  #arr = {year,month,date,hour,minute,title,smNumber,comment,views,numComments,myList,ads}
  db.insert(DateTime.new(2000+Integer(arr[0]),Integer(arr[1]),Integer(arr[2]),Integer(arr[3]),Integer(arr[4]),0,'+09:00'),arr[6],arr[8],arr[9],arr[10],arr[11])
}
