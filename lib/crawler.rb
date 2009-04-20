module Crawler  
require 'rubygems'
require 'nokogiri'
require 'open-uri'
 
  def start_grab(file,caixi) 
        doc = Nokogiri::HTML(open("/Users/konglingliang/Documents/dianping/jingjiao/200/#{file}.html"))
        doc.css('div#ctl00_PlaceHolderPage_MainInfo').each do |content|
          content.css('dd').each do |vendor|
            begin  
              taste = vendor.css('li.grade > span')[0].content
              env = vendor.css('li.grade > span')[1].content
              ser = vendor.css('li.grade > span')[2].content
              avg = vendor.css('li.grade > span')[3].content.gsub(/￥/,'')
              name = vendor.search('li.shopname > a.BL')[0].text
              address = vendor.search('ul.detail > li')[1].text.gsub(/\d{8}|转/,'') 
              tel = vendor.search('ul.detail > li')[1].text.grep(/\d{8}/)[0].gsub(/转/,'').to_i unless vendor.search('ul.detail > li')[1].nil?
              tags = vendor.search('ul.detail > li')[2].text.gsub(/标签: /,'')  unless vendor.search('ul.detail > li')[2].nil?
            rescue
              taste = vendor.css('li.grade > span')[0].content
              env = vendor.css('li.grade > span')[1].content
              ser = vendor.css('li.grade > span')[2].content
              avg = vendor.css('li.grade > span')[3].content.gsub(/￥/,'')
              name = vendor.search('li.shopname > a.BL')[0].text
              address = vendor.search('ul.detail > li')[1].text.gsub(/\d{8}|转/,'').chop!
              tel = ''
              tags = ''
            end  
            Vendor.transaction do
              @vendor = Vendor.create(:name => name, :address => address, :tel1 => tel, :area_id => 66, :category_id => 1,:tag_list => tags )
              if @vendor.save! 
                @vendor.types << Type.find(caixi)
                @vendor.types << Type.find(82)
                @vendor.score_sumaries.create(:vote_id => 1, :score => taste.to_f )
                @vendor.score_sumaries.create(:vote_id => 5, :score => env.to_f ) 
                @vendor.score_sumaries.create(:vote_id => 3, :score => avg.to_f ) 
                @vendor.score_sumaries.create(:vote_id => 2, :score => ser.to_f )
              else
                @vendor.errors
              end
            end
          end
      end
  end
  
end  