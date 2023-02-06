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

module SpreadsheetsHelper
  def table_select_options
    return project_tables.select(:id, :name) unless project_type_id || project_type_master
    return project_type_tables.select(:id, :name) if project_type_id

    project_type_master_tables.select(:id, :name)
  end

  def project_type_master
    return unless defined? ProjectType

    @project.is_project_type
  end

  def project_type_master_tables
    @project.tables
  end

  delegate :tables, to: :project_type, prefix: true

  def project_tables
    Table
  end

  def project_type_id
    return unless defined? ProjectType

    @project.project_type_id
  end

  def project_type
    @project.project_type
  end

  def selected_spreadsheet_home
    return if params[:action].to_sym != :index

    'selected'
  end

  def selected_spreadsheet(id, action)
    return if action.to_sym != params[:action].to_sym

    'selected' if params[:id].to_i == id.to_i
  end

  ##
  # Define whether to align to the left.
  #
  def odd?(index)
    (index + 1).odd?
  end

  ##
  # Define whether to align to the right.
  #
  def even?(index)
    !odd?(index)
  end

  ##
  # This method formats the given (custom) value by using
  # CustomFieldsHelper#format_value or a special format for non custom value
  # fields.
  #
  # @param value [String|Integer] The value of a custom field.
  # @param column [CustomField] The column of the table, i.e. the custom field
  #  corresponding to the given value.
  #
  def value(value, column)
    return non_custom_field_value(value) if column.nil?

    format_value(value, column)
  end

  def color(value, column)
    return '' unless column

    column.cast_color(value)
  end

  def render_spreadsheet_result_table(spreadsheet)
    render partial: 'spreadsheets/calculation_results',
           locals: { table: SpreadsheetResultTable.new(spreadsheet) }
  end

  def render_spreadsheet_table(spreadsheet)
    render partial: 'table',
           locals: { table: SpreadsheetTable.new(spreadsheet) }
  end

  ##
  # Consider by default string values to be textilizable.
  #
  def non_custom_field_value(value)
    value.is_a?(String) ? textilizable(value) : value
  end
end
