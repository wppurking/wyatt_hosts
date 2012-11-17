# -*- encoding : utf-8 -*-
class DomainsController < ApplicationController

  def index
    @domains = Domain.all
    #@domains = [] unless @domains
    @domain = Domain.new
  end

  def create
    @domain = Domain.new(params[:domain])
    if @domain.save
      flash[:success] = "域名添加成功"
      redirect_to domains_url
    else
      @domains = Domain.all
      render 'index'
    end
  end

  def destroy
    @domain = Domain.find(params[:id])
    if @domain.destroy
      flash[:success] = "域名删除成功"
      redirect_to domains_url
    else
      render 'index'
    end
  end

end
