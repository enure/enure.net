#!/usr/bin/env ruby

require "fileutils"
require "securerandom"

system "rm -rf dist"
system "mkdir -p dist/img/orig"
system "mkdir -p dist/img/2432"
system "mkdir -p dist/img/1216"
system "mkdir -p dist/img/608"

html_string = "<ul>"

Dir.glob("img/*.jpg").reverse.each do |file|

    new_file_name = file.gsub("img/", "")
    new_file_name = new_file_name.split("-").first
    new_file_name = "#{new_file_name}_#{SecureRandom.hex}.jpg"

    FileUtils.cp file, "dist/img/orig/#{new_file_name}"
    puts "→ Copying #{new_file_name}"

end

Dir.glob("dist/img/orig/*.jpg").each_with_index do |file, index|

    file_name = file.split("/").last

    [2432, 1216, 608].each do |size|
        system "convert #{file} -resize #{size} -quality 75 dist/img/#{size}/#{file_name}"
        puts "→ Converting #{file} to #{size}"
    end

end

Dir.glob("dist/img/orig/*.jpg").reverse.each_with_index do |file, index|

    file_name = file.split("/").last
    html_string += "<li class=Item><span class=Number>#{index+1}</span><img class=Image data-src='dist/img/608/#{file_name}' data-srcset='dist/img/608/#{file_name} 608w, dist/img/1216/#{file_name} 1216w, dist/img/2432/#{file_name} 2432w'></li>\n\t"

    puts "→ Writing HTML for #{file}"

end

html_string += "</ul>"

html_file = File.read("template.html")
html = html_file.gsub("%REPLACE_ME%", html_string)

File.write("index.html", html)

puts "→ Writing template to index.html"

system "git add index.html"
system "git add -f dist/img/608/*.jpg"
system "git add -f dist/img/1216/*.jpg"
system "git add -f dist/img/2432/*.jpg"
system "git commit -m 'update'"
system "git push"
