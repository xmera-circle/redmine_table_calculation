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

class SpreadsheetsController < ApplicationController
  model_object Spreadsheet
  menu_item :menu_table_calculation

  before_action :find_model_object, except: %i[index new create]
  before_action :find_project_by_project_id
  before_action :authorize

  helper :custom_fields

  def index
    @spreadsheets = @project.spreadsheets
  end

  def show
    index
    prepare_data_table
    prepare_result_table
  end

  def new
    @spreadsheet ||= new_spreadsheet
    @spreadsheet.safe_attributes = params[:spreadsheet]
  end

  def edit
    @spreadsheet.rows << SpreadsheetRow.new(position: 1) if @spreadsheet.rows.empty?
    @spreadsheet.safe_attributes = params[:spreadsheet]
  end

  def create
    @spreadsheet ||= new_spreadsheet
    @spreadsheet.safe_attributes = params[:spreadsheet]
    if @spreadsheet.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to project_spreadsheet_path @project, @spreadsheet
    else
      render :new
    end
  end

  def update
    @spreadsheet.safe_attributes = params[:spreadsheet]
    if @spreadsheet.save
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
    @spreadsheet.destroy
    redirect_to project_spreadsheets_path
  end

  private

  def new_spreadsheet
    Spreadsheet.new(project_id: @project.id,
                    author_id: User.current.id)
  end

  def prepare_data_table
    @data_table = DataTable.new(spreadsheet: @spreadsheet)
  end

  def prepare_result_table
    @result_table = ResultTable.new(data_table: @data_table)
  end
end
