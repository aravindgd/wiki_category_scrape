require "date"
require "mechanize"
mechanize = Mechanize.new
page = mechanize.get('https://commons.wikimedia.org/wiki/Category:The_PDF_files_in_Tamil_without_OCR_conversion')
links = []
page.search('#mw-category-media li .gallerytext a').each do |link|
	links << link['href']
end
host_name = page.uri.hostname
scheme = page.uri.scheme

File.open("url_#{DateTime.now.to_s}.txt",'w') do |f|
	links.each do |link| 
		link_with_base = "#{scheme}://#{host_name}#{link}"
		# puts "Getting for...#{link_with_base}"
		page = mechanize.get(link_with_base)
		file_link = page.search('#mw-content-text .fullMedia a')[0]
		output = "#{file_link['title']}~#{file_link['href']}"
		puts output
		f.puts output
	end
end

puts "Completed...."
