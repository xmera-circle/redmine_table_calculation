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

class SpreadsheetRowResultsController < ApplicationController
  model_object SpreadsheetRowResult
  menu_item :menu_table_calculation

  before_action :find_project_by_project_id, only: %i[new create]
  before_action :find_spreadsheet, :find_calculation, except: %i[edit]
  before_action :find_model_object, except: %i[index new create]
  before_action :authorize, only: %i[edit update]

  helper :custom_fields

  def index; end

  def new
    @spreadsheet_row_result ||= new_row
    @spreadsheet_row_result.safe_attributes = params[:spreadsheet_row_result]
  end

  def create
    @spreadsheet_row_result ||= new_row
    @spreadsheet_row_result.safe_attributes = params[:spreadsheet_row_result]
    if @spreadsheet_row_result.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to results_project_spreadsheet_path @project, @spreadsheet
    else
      render :new
    end
  end

  def edit; end

  def update
    @spreadsheet_row_result.safe_attributes = params[:spreadsheet_row_result]
    if @spreadsheet_row_result.save
      respond_to do |format|
        format.html do
          flash[:notice] = l(:notice_successful_update)
          redirect_to results_project_spreadsheet_path row_project, row_spreadsheet
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
    @spreadsheet_row_result.destroy
    redirect_to project_spreadsheet_path row_project, row_spreadsheet
  end

  private

  def new_row
    SpreadsheetRowResult.new(spreadsheet_id: @spreadsheet.id,
                             calculation_id: @calculation.id,
                             author_id: User.current.id,
                             comment: '')
  end

  def find_spreadsheet
    spreadsheet_id = params[:spreadsheet_id] || params[:spreadsheet_row_result][:spreadsheet_id]
    @spreadsheet = Spreadsheet.find_by(id: spreadsheet_id.to_i)
  end

  def find_calculation
    calculation_id = params[:calculation_id] || params[:spreadsheet_row_result][:calculation_id]
    @calculation = Calculation.find_by(id: calculation_id.to_i)
  end

  def row_project
    @spreadsheet_row_result.spreadsheet.project
  end

  def row_spreadsheet
    @spreadsheet_row_result.spreadsheet
  end
end
