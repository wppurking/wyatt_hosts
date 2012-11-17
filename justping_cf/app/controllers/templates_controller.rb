# -*- encoding : utf-8 -*-
class TemplatesController < ApplicationController
  def index
    @templates = Template.all
  end

  def show
    @template = Template.find(params[:id])
  end

  def new
    @template = Template.new
  end

  def create
    @template = Template.new(params[:template])
    if @template.save
      flash[:success] = "添加成功"
      redirect_to templates_url
    else
      render 'new'
    end
  end

end
