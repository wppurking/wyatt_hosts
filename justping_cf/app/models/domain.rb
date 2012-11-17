# -*- encoding : utf-8 -*-
require "open-uri"
class Domain
  include Mongoid::Document
  include Mongoid::Timestamps

  # 域名
  field :domain
  # 模板中的此域名的占位符
  field :placeholder

  belongs_to :template

  # TODO 增加 domain 的格式验证
  validates :domain, presence: true, uniqueness: true
  validates :template_id, presence: true
  validates :placeholder, presence: true

  index({domain: 1}, {unique: true})

  # 获取对应落地点服务器的 ping Ip 地址
  def ping(location_id)
    html = open("http://www.just-ping.com/index.php?vh=#{domain}&c=&s=ping%21&vtt=#{Time.now.to_i}&vhost=_&c=")
    # 新加坡
    url = html.read.lines.select { |line| line.include?(location_id) }[0]
    url = url[(url.index("('") + 2)...url.index("',")]
    c = open("http://www.just-ping.com/#{url}")
    html = c.read
    puts "#{domain} --> #{html}"
    html[(html.rindex(';') + 1)..-1]
  end
end
