# -*- encoding : utf-8 -*-
# 一个一个的 Template 文件
class Template
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :content

  validates :name, presence: true, length: {minimum: 1, maximum: 100}
  validates :content, presence: true

end
