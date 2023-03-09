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

class DataTableCell
  delegate :full_text_formatting?, to: :column
  delegate :id, to: :column, prefix: true
  delegate :id, to: :row, prefix: true

  def initialize(**attrs)
    @custom_field_value = attrs[:custom_field_value]
    @column = custom_field_value.custom_field
    @row = custom_field_value.customized
  end

  # Raw value will be casted and formatted in SpreadsheetsHelper#format_table_value
  def value
    raw_value
  end

  # Casted custom field value according to the underlying field
  # format, i.e., int, string, enumeration, etc.
  #
  # @note Required for ResultTableCell#calculable_values
  def casted_value
    column.cast_value(raw_value)
  end

  # Color of a TableCustomField with field_format :enumeration
  def cast_color
    column.cast_color(raw_value)
  end

  # Column position of the cell in the DataTable
  def column_index
    column.position
  end

  # Row position of the cell in the DataTable
  def row_index
    row.position
  end

  # Format of the underlying custom field
  def format
    column.field_format
  end

  def custom_field
    column
  end

  private

  attr_reader :custom_field_value, :column, :row

  # Returns always a String independet of field_format
  def raw_value
    row.custom_field_value(column_id)
  end
end
