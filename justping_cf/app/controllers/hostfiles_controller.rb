# -*- encoding : utf-8 -*-
class HostfilesController < ApplicationController
  def index
    @hostfiles = Hostfile.all
  end

  def new
    @hostfile = Hostfile.new
  end

  def create
    @hostfile = Hostfile.new(params[:hostfile])
    if @hostfile.hosts.save
      send_data(@hostfile.content, filename: 'hosts', type: 'text/txt')
    else
      render 'new'
    end
  end

  def down
    send_data("ksdjfksdjfkjdsf", filename: 'hottt', type: 'text/txt')
  end

  def show
    @hostfile = Hostfile.find(params[:id])
    send_data(@hostfile.content, filename: 'hosts', type: 'text/txt')
  end

end
