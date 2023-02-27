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

class Table
  def initialize(**attrs)
    @spreadsheet = attrs[:spreadsheet]
    @table_config = spreadsheet.table_config
  end

  def header
    table_config.columns
  end

  def width
    header.count
  end

  def length
    rows.count
  end

  def rows
    spreadsheet_rows = spreadsheet.rows
    return [] unless spreadsheet_rows

    spreadsheet_rows.map do |row|
      TableRow.new(row: row, width: width)
    end
  end

  private

  attr_reader :spreadsheet, :table_config
end
