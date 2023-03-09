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
  def table_config_select_options
    return project_table_configs.select(:id, :name) unless project_type_id || project_type_master
    return project_type_table_configs.select(:id, :name) if project_type_id

    project_type_master_tables.select(:id, :name)
  end

  def project_type_master
    return unless defined? ProjectType

    @project.is_project_type
  end

  def project_type_master_tables
    @project.table_configs
  end

  delegate :table_configs, to: :project_type, prefix: true

  def project_table_configs
    TableConfig
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

  def render_spreadsheet_result_table(**attrs)
    spreadsheet = attrs[:spreadsheet]
    result_table = attrs[:result_table] || ResultTable.new(data_table: spreadsheet.data_table)
    render partial: 'spreadsheets/result_table',
           locals: { table: result_table }
  end

  def render_spreadsheet_table(**attrs)
    table = attrs[:data_table] || attrs[:spreadsheet].data_table
    render partial: 'spreadsheets/data_table',
           locals: { table: table }
  end

  # Cast and format custom field values according to the underlying field
  # format
  def format_table_value(value, custom_field)
    return value unless custom_field
    return value if value == '-'

    html = true
    format_object(custom_field.format.formatted_value(self, custom_field, value, false, html), html)
  end
end
