require "curb"
require "forkmanager"
require "pp"
#http://www.just-ping.com/index.php?vh=z-ecx.images-amazon.com&c=&s=ping%21&vtt=1351054032&vhost=_&c=

SITES = [
	"z-ecx.images-amazon.com",
	"g-ecx.images-amazon.com",
	"images-na.ssl-images-amazon.com",
	#1
	"drive.google.com",
	#2
	"lh1.googleusercontent.com",
	#3
	"ssl.gstatic.com",
	#4
	"ngrams.googlelabs.com",
	#5
	"www.google-analytics.com"
]

# 最终的 IP 地址
IPS = {}

def step1(site)
	c = Curl.get("http://www.just-ping.com/index.php?vh=#{site}&c=&s=ping%21&vtt=#{Time.now.to_i}&vhost=_&c=")
	`mkdir -p ./sites` unless Dir.exist?('./sites')
	open("sites/#{site}.html", 'w') { |f| f.write(c.body_str) }
end


def step2(site)
	html = open("sites/#{site}.html")
	# 新加坡
	url = html.to_a.select { |line| line.include?("203.142.24.8") }[0]
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
			step1(site)
			IPS[site] = step2(site)
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



google_template = open('google_template.ini').read
IPS.each do |k, v|
	puts "#{k}		#{v}"
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
	else
		google_template << "#{v}	#{k}\n"
	end
end

open("google_template.#{Time.now.to_i}.txt", 'w') { |io| io.write(google_template) }