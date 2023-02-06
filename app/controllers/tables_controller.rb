# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
#
# Copyright (C) 2020-2023 Liane Hampe <liaham@xmera.de>, xmera Solutions GmbH.
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
  before_action :require_admin

  layout 'admin'
  self.main_menu = false

  def index
    @tables = Table.all
  end

  def show; end

  def new
    @table = Table.new
  end

  def edit; end

  def create
    @table = Table.new
    @table.safe_attributes = params[:table]
    if @table.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to tables_path
    else
      render :new
    end
  end

  def update
    @table.safe_attributes = params[:table]
    if @table.save
      respond_to do |format|
        format.html do
          flash[:notice] = l(:notice_successful_update)
          redirect_to tables_path
        end
      end
    else
      respond_to do |format|
        format.html do
          edit
          render action: 'edit'
        end
      end
    end
  end

  def destroy
    @table.destroy
    redirect_to tables_path
  end
end
