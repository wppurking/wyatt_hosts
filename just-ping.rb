require "curb"

# Thanks to  
#  hostsx https://code.google.com/p/hostsx/  
#  MVPS http://winhelp2002.mvps.org/ 
#  huhamhire-hosts https://code.google.com/p/huhamhire-hosts/

server = {
# Beijing
"5" => "202.142.24.224",
# Tokyo
"4" => "54.248.93.127",
# Shanghai
"3" => "61.129.74.156",
# Singapore
"2" => "203.142.24.8",
# HongKong
"1" => "203.142.29.40"
}

puts """Chose server ip lcaltion:
1. HongKong(Good)
2. Singapore(Good)
3. Shanghai(Very Good but not always good)
4. Tokyo(Good)
5. Beijing(Very Good but not always good)
"""
SERVER_IP = server[gets.strip]
unless SERVER_IP
  puts "Please input 1/2"
  exit
end
puts "use #{SERVER_IP}"

puts "Need Block Ads? (y/n)"
ads = gets.strip == 'y'

puts "Need Ads!" if ads

SITES = [
	# amazon
	"z-ecx.images-amazon.com",
	"g-ecx.images-amazon.com",
	"images-na.ssl-images-amazon.com",
	# github
	"a248.e.akamai.net",
	#1
	"drive.google.com",
	"www.icloud.com",
	#2
	"lh1.googleusercontent.com",
	"swcdn.apple.com",
	#3
	"ssl.gstatic.com",
	"a1.mzstatic.com",
	#4
	"ngrams.googlelabs.com",
	"a1.phobos.apple.com",
	#5
	"www.google-analytics.com",
	"devimages.apple.com.edgekey.net",
        #6
        "metrics.apple.com"
]

# 最终的 IP 地址
IPS = {}

def just_ping(site)
	html = Curl.get("http://www.just-ping.com/index.php?vh=#{site}&c=&s=ping%21&vtt=#{Time.now.to_i}&vhost=_&c=")
	# 新加坡
	url = html.body_str.lines.select { |line| line.include?(SERVER_IP) }[0]
	url = url[(url.index("('") + 2)...url.index("',")]
	c = Curl.get("http://www.just-ping.com/#{url}")
	html = c.body_str
	puts html
	html[(html.rindex(';') + 1)..-1]
end

threads = []

SITES.each do |site|
	threads << Thread.new do
		begin
			puts "#{Thread.current} begin..."
			IPS[site] = just_ping site
			puts "#{Thread.current} end..."
		rescue Exception => e
			puts e.message
			IPS[site] = ''
		end
	end
end

threads.each { |t| t.join }

# TODO 
# 将需要处理的网站分不同的 template 文件
# 通过上面找到不同文件中的 IP 地址
# 然后再通过各自的 template 进行替换
# 最后将所有 template 合并成为一份 hosts 文件



base_template = open('template/base_template.ini').read
google_template = open('template/google_template.ini').read
apple_template = open('template/apple_template.ini').read

# 组织广告
mvps_tempalte = ads ? Curl.get('http://winhelp2002.mvps.org/hosts.txt').body_str.strip : ""

IPS.each do |k, v|
	next if v == ''
	puts "#{k}		#{v}"
	# google
	if k.include?('drive')
		google_template = google_template.gsub(/\$\{1\}/, v)
	elsif k.include?('googleusercontent')
		google_template = google_template.gsub(/\$\{2\}/, v)
	elsif k.include?('gstatic')
		google_template = google_template.gsub(/\$\{3\}/, v)
	elsif k.include?('googlelabs')
		google_template = google_template.gsub(/\$\{4\}/, v)
	elsif k.include?('analytics')
		google_template = google_template.gsub(/\$\{5\}/, v)
	# apple
	elsif k.include?('icloud')
		apple_template = apple_template.gsub(/\$\{1\}/, v)
	elsif k.include?('swcdn')
		apple_template = apple_template.gsub(/\$\{2\}/, v)
	elsif k.include?('mzstatic')
		apple_template = apple_template.gsub(/\$\{3\}/, v)
	elsif k.include?('phobos')
		apple_template = apple_template.gsub(/\$\{4\}/, v)
	elsif k.include?('edgekey')
		apple_template = apple_template.gsub(/\$\{5\}/, v)
	elsif k.include?('metrics')
		apple_template = apple_template.gsub(/\$\{6\}/, v)
	# amazon
	else
		base_template << "#{v}	#{k}\n"
	end
end

open("google_template.#{Time.now.to_i}.txt", 'w') { |io| io.write(google_template) }
open("apple_template.#{Time.now.to_i}.txt", 'w') { |io| io.write(apple_template) }

all_in_one = base_template << "\n" << google_template << "\n" << apple_template << "\n" << "\n\n" << mvps_tempalte
open("hosts.#{Time.now.to_i}.txt", 'w') { |io| io.write(all_in_one) }
