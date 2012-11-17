# -*- encoding : utf-8 -*-
# 一次次生成的 hosts 文件
class Hostfile
  include Mongoid::Document
  include Mongoid::Timestamps

  LOCATION = %w(HongKong Singapore Shanghai Tokyo Beijing)

  field :location, default: 'Tokyo'
  # 是否需要广告过滤部分
  field :needAd, type: Boolean, default: false
  field :content

  validates :location, presence: true, inclusion: {
      in: LOCATION,
      message: "只允许在 HongKong Singapore, Shanghai Tokyo Beijing 中选择"}
  validates :content, presence: true

  def just_ping
  end

end
