# -*- encoding : utf-8 -*-
class Domain
  include Mongoid::Document
  include Mongoid::Timestamps

  # 域名
  field :domain

  # TODO 增加 domain 的格式验证
  validates :domain, presence: true, uniqueness: true

  index({domain: 1}, {unique: true})
end
