#!/usr/bin/env ruby

html_string = "<ul>"

Dir.glob("img/*.jpg").reverse.each do |file|
    if file.include? " "
        File.rename(file, file.gsub(" ", "_"))
    end
end

Dir.glob("img/*.jpg").reverse.each_with_index do |file, index|
    html_string += "<li class=Item><span class=Number>#{index+1}</span><img class=Image data-src='#{file}'></li>\n\t"
end

html_string += "</ul>"

html_file = File.read("template.html")
html = html_file.gsub("%REPLACE_ME%", html_string)

File.write("index.html", html)

system "git add index.html"
system "git add img/*"
system "git c -m 'update'"
system "git push"
