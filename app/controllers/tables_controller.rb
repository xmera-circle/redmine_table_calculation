# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
#
# Copyright (C) 2021 Liane Hampe <liaham@xmera.de>, xmera.
#
# This plugin program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

class TablesController < ApplicationController
  model_object Table
  menu_item :menu_table_config

  before_action :find_model_object, except: %i[index new create]
  before_action :find_project
  
  ## modify the next three lines if project settings tab enabled
  before_action :require_admin
  layout 'admin'
  self.main_menu = false
  ##

  def index
    @tables = Table.all
  end

  def new
    @table = Table.new
  end

  def create
    @table = ProjectType.new
    @table.safe_attributes = params[:table]
    if @table.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to table_path
    else
      render :new
    end
  end

  def show

  end

  def edit

  end

  def update

  end

  def destroy
    @table.destroy
    redirect_to tables_path
  end

  private

  ##
  # Intermediate state for @project as long as project settings tag
  # is deactivated.
  #
  def find_project
    @project = nil
  end

end