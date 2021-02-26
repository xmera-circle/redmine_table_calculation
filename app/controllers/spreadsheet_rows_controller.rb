# frozen_string_literal: true

# This file is part of the Plugin Redmine Table spreadsheet.
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

class SpreadsheetRowsController < ApplicationController
  model_object SpreadsheetRow
  menu_item :menu_table_calculation

  before_action :find_project_by_project_id, only: %i[new create]
  before_action :find_spreadsheet
  before_action :find_model_object, except: %i[index new create]

  # helper :tables
  helper :custom_fields

  def index; end

  def new
    @spreadsheet_row ||= SpreadsheetRow.new(spreadsheet_id: @spreadsheet.id,
                                            position: @spreadsheet.rows.count + 1)
    @spreadsheet_row.safe_attributes = params[:spreadsheet_row]
  end

  def create
    @spreadsheet_row ||= SpreadsheetRow.new(spreadsheet_id: @spreadsheet.id,
                                            position: @spreadsheet.rows.count + 1)
    @spreadsheet_row.safe_attributes = params[:spreadsheet_row]
    if @spreadsheet_row.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to project_spreadsheet_path @project, @spreadsheet
    else
      render :new
    end
  end

  # def show; end

  def edit; end

  def update
    @spreadsheet_row.safe_attributes = params[:spreadsheet_row]
    if @spreadsheet_row.save
      respond_to do |format|
        format.html do
          flash[:notice] = l(:notice_successful_update)
          redirect_to project_spreadsheet_path @spreadsheet_row.spreadsheet.project, @spreadsheet_row.spreadsheet
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
    redirect_to project_spreadsheet_path @spreadsheet_row.spreadsheet.project, @spreadsheet_row.spreadsheet
  end

  private

  def find_spreadsheet
    spreadsheet_id = params[:spreadsheet_id] || params[:spreadsheet_row][:spreadsheet_id]
    @spreadsheet = Spreadsheet.find(spreadsheet_id.to_i)
  end
end
