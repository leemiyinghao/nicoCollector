#!/bin/ruby
# -*- coding: utf-8 -*-
require 'sqlite3'
require 'curb'
require 'rubygems'
class HTML
  #TODO:Replace to a curl Webpage Grabber
  def initialize(url)
    @url = /[^\?]+/.match(url)#Strip URL for '?' and char after
  end
  def grabPage(page)
    curl = Curl::Easy.new(String(@url) + "?sort=f&page=#{page}")
    #puts "url:#{String(@url)}?sort=f&page=#{page}"
    curl.headers["Accept-Encoding"] = "gzip,deflate"
    curl.encoding = "UTF-8"
    curl.perform
    @page = curl.body_str.force_encoding("UTF-8")
  end
  def getContext
    return @page
#    return File.readlines("page2.html","r").to_s
  end
end
class REGEX
  def initialize(filename)
    @file = File.open(filename)
    temp = String.new
    @file.each {|text| temp += text}
    @expression = temp
  end
  def getExpression
    return @expression
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
#COLLECTING RANGE SET
colRange = 60 * 60 * 24 * 7 * 2 #default: 2 weeks, display in second.
#COLLECTING RANGE SET
html = HTML.new("http://www.nicovideo.jp/tag/初音ミク")
regex = REGEX.new("regexp")
db = DATABASE.new("database.sqlite")
#list = {uploadDate,smNumber,numViews,numComments,numMyList,numAds,recodeDate}
countPage = 1
countSong = 0
stop = false
while !stop
  html.grabPage(countPage)
  html.getContext.scan(/#{regex.getExpression}/).each {|arr|
    #arr = {month,date,hour,minute,title,smNumber,comment,views,numComments,myList,ads}
    break if arr[1].nil?
    date = DateTime.new(2014,Integer(arr[0]),Integer(arr[1]),Integer(arr[2]),Integer(arr[3]),0,'+09:00')
    if(date.to_time.to_i + colRange < DateTime.now.to_time.to_i + 9 * 60 * 60)
      stop = true
      break
    end
    countSong += 1
    print "\r"
    print "#{countSong} songs,#{countPage} pages"
    db.insert(date,arr[5],arr[7],arr[8],arr[9],arr[10])
  }
  break if stop
  countPage += 1
  puts ",sleep..."
  sleep(1)
end
puts "\nSenquance completed."
puts "#{countSong} songs,#{countPage - 1} pages have scaned."
