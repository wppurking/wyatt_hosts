# -*- encoding : utf-8 -*-
class HostfilesController < ApplicationController
  def index
    @hostfiles = Hostfile.find
  end

  def new
    @hostfile = Hostfile.new
  end

  def create
  end

end
