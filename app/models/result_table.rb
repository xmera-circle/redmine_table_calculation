# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
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

class ResultTable

  attr_reader :table, :columns, :rows, :calculations

  def initialize(spreadsheet)
    @table = spreadsheet.table
    @calculations = self.table.calculations
    @columns = self.table.columns
    @rows = spreadsheet.rows
  end

  def row_ids
    rows.map(&:id)
  end

  def column_value(id, calculation)
    DataMatrix.new(row_ids, calculation.column_ids).column_values(id)
  end
end