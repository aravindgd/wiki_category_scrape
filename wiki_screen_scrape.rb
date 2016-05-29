require "date"
require "mechanize"
mechanize = Mechanize.new do |a|
  a.follow_meta_refresh = true
  a.keep_alive = false
end
page = mechanize.get('https://commons.wikimedia.org/wiki/Category:PDF_files_in_Tamil_with_OCR_conversion')
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
    file_data = page.search('#mw-content-text .fullMedia span.fileInfo')[0]
    puts file_data.inspect
    output = "#{file_link['title']}~#{file_link['href']}~#{file_data.text}"
    puts output
    f.puts output
  end
end

puts "Completed...."
