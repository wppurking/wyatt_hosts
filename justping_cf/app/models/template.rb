# -*- encoding : utf-8 -*-
# 一个一个的 Template 文件
class Template
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :content

  has_one :domain

  validates :name, presence: true, length: {minimum: 1, maximum: 100}, uniqueness: true
  validates :content, presence: true

  index({name: 1}, {unique: true})
end
