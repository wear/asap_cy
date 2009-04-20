require 'rubygems'
require 'nokogiri'
require 'open-uri'
doc = Nokogiri::HTML(open('/Users/konglingliang/Documents/dianping/luw/benban.html'))
doc.css('div#ctl00_PlaceHolderPage_MainInfo').each do |content|
  content.css('dd').each do |vendor|
    puts 'taste: ' + vendor.css('li.grade > span')[0].content
    puts 'env: ' + vendor.css('li.grade > span')[1].content
    puts 'service: ' + vendor.css('li.grade > span')[2].content
    puts 'avg cost: ' + vendor.css('li.grade > span')[3].content.gsub(/￥/,'')
    puts 'name: ' + vendor.search('li.shopname > a.BL')[0].text
    puts 'address: ' +  vendor.search('ul.detail > li')[1].text.gsub(/\d{8}|转/,'')
    puts 'tel: ' + vendor.search('ul.detail > li')[1].text.grep(/\d{8}/)[0].gsub(/转/,'')
    puts 'tags: ' + vendor.search('ul.detail > li')[2].text.gsub(/标签: /,'') 
  end
end


