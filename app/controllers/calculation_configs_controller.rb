# frozen_string_literal: true

# This file is part of the Plugin Redmine Table CalculationConfig.
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

class CalculationConfigsController < ApplicationController
  model_object CalculationConfig
  menu_item :menu_table_config

  helper :table_configs

  before_action :find_model_object, except: %i[index new create]
  before_action :require_admin

  layout 'admin'
  self.main_menu = false

  def index
    @calculation_configs = CalculationConfig.all
  end

  def show; end

  def new
    @calculation_config = CalculationConfig.new
  end

  def edit; end

  def create
    @calculation_config = CalculationConfig.new
    @calculation_config.safe_attributes = remove_duplicate_column_ids
    if @calculation_config.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to calculation_configs_path
    else
      render :new
    end
  end

  def update
    @calculation_config.safe_attributes = remove_duplicate_column_ids
    if @calculation_config.save
      respond_to do |format|
        format.html do
          flash[:notice] = l(:notice_successful_update)
          redirect_to calculation_configs_path
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
    @calculation_config.destroy
    redirect_to calculation_configs_path
  end

  private

  def remove_duplicate_column_ids
    uniq_field_ids = params[:calculation_config][:column_ids].uniq
    params[:calculation_config][:column_ids] = uniq_field_ids
    params[:calculation_config]
  end
end
