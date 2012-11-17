# -*- encoding : utf-8 -*-
# 一次次生成的 hosts 文件
require 'open-uri'
class Hostfile
  include Mongoid::Document
  include Mongoid::Timestamps

  LOCATION_IPS = {
      # Beijing
      "Beijing" => "202.142.24.224",
      # Tokyo
      "Tokyo" => "54.248.93.127",
      # Shanghai
      "Shanghai" => "61.129.74.156",
      # Singapore
      "Singapore" => "203.142.24.8",
      # HongKong
      "HongKong" => "203.142.29.40"

  }

  field :location, default: 'Tokyo'
  # 是否需要广告过滤部分
  field :needAd, type: Boolean, default: false
  field :content

  validates :location, presence: true, inclusion: {
      in: LOCATION_IPS.keys,
      message: "只允许在 HongKong Singapore, Shanghai Tokyo Beijing 中选择"}
  validates :content, presence: true


  def hosts
    # 多线程获取 domain ip
    threads = []
    domain_dns = {}
    Domain.all.each do |domain|
      threads << Thread.new do
        begin
          domain_dns[domain] = domain.ping(LOCATION_IPS[location])
        rescue Exception => e
          puts "#{e.message}; error..."
        end
      end
    end
    threads.each { |t| t.join }
    # 根据 domain 向模板中填充

    self.content = ""
    self.content << open('http://winhelp2002.mvps.org/hosts.txt').read if needAd
    # 缓存的 tempaltes, 合并处理 template
    templates = {}
    domain_dns.each do |domain, ip|
      key = domain.template.name
      templates[key] = domain.template.content unless templates.key?(key)
      if key.start_with?('base')
        templates[key] << "#{ip}  #{domain.domain}\n"
      else
        templates[key] = templates[key].gsub("#{domain.placeholder}", ip)
      end
    end
    templates.each { |k, c| self.content << c << "\n\n" }
    # 如果 content 没有变化, 则变为 nil
    self.content = nil if self.content == ""
    self
  end

end
