# -*- encoding : utf-8 -*-
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
end
