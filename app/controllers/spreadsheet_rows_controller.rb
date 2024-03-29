# frozen_string_literal: true

# This file is part of the Plugin Redmine Table spreadsheet.
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

class SpreadsheetRowsController < ApplicationController
  model_object SpreadsheetRow
  menu_item :menu_table_calculation

  before_action :find_model_object, except: %i[index new create]
  before_action :find_project_by_project_id, only: %i[new create]
  before_action :find_spreadsheet
  before_action :find_project_of_spreadsheet
  before_action :authorize, except: :index

  helper :custom_fields

  def index; end

  def new
    @spreadsheet_row ||= new_row
    @spreadsheet_row.safe_attributes = params[:spreadsheet_row]
  end

  def edit; end

  def create
    @spreadsheet_row ||= new_row
    @spreadsheet_row.safe_attributes = params[:spreadsheet_row]
    if @spreadsheet_row.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to project_spreadsheet_path @project, @spreadsheet
    else
      render :new
    end
  end

  def update
    @spreadsheet_row.safe_attributes = params[:spreadsheet_row]
    if @spreadsheet_row.save
      respond_to do |format|
        format.html do
          flash[:notice] = l(:notice_successful_update)
          redirect_to project_spreadsheet_path @project, @spreadsheet
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
    @spreadsheet_row.destroy
    redirect_to project_spreadsheet_path @project, @spreadsheet
  end

  private

  def new_row
    SpreadsheetRow.new(spreadsheet_id: @spreadsheet.id,
                       table_config: @spreadsheet.table_config,
                       position: @spreadsheet.rows.count + 1)
  end

  def find_spreadsheet
    @spreadsheet = @spreadsheet_row ? @spreadsheet_row.spreadsheet : find_spreadsheet_by_id
  end

  def find_spreadsheet_by_id
    Spreadsheet.find_by(id: spreadsheet_id)
  end

  def spreadsheet_id
    params[:spreadsheet_id].to_i || params[:spreadsheet_row][:spreadsheet_id].to_i
  end

  def find_project_of_spreadsheet
    @project = @spreadsheet.project
  end
end
