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

class RowValue
  attr_accessor :value, :row, :col

  ##
  # @param value [String] The custom value.
  # @param row   [SpreadsheetRow|SpreadsheetRowResult] The row object of the spreadsheet.
  # @param col   [CustomField] The column object corresponding to the custom value.
  #
  def initialize(value:, row: nil, col: nil)
    @value = value
    @row = row
    @col = col
  end

  def row_id
    row.nil? ? row : row.id
  end

  def value?
    value.present?
  end
end
