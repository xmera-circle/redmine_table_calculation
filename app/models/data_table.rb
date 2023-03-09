# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
#
# Copyright (C) 2023 Liane Hampe <liaham@xmera.de>, xmera Solutions GmbH.
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

class DataTable
  include Enumerable

  attr_reader :spreadsheet, :spreadsheet_rows, :table_config

  def initialize(**attrs)
    @spreadsheet = attrs[:spreadsheet]
    @table_config = spreadsheet.table_config
    @calculation_configs = table_config.calculation_configs
    @spreadsheet_rows = spreadsheet.rows
  end

  def header
    table_config.columns.sort_by(&:position)
  end

  def columns
    return [] unless spreadsheet_rows

    transpose_rows.map do |column|
      DataTableColumn.new(column: column, table_config: table_config)
    end
  end

  def transpose_rows
    map(&:cells).transpose
  end

  def rows
    return [] unless spreadsheet_rows

    spreadsheet_rows.map do |row|
      DataTableRow.new(row: row)
    end
  end

  private

  # Allows to iterate through DataTableRow instances
  def each(&block)
    rows.each(&block)
  end
end
