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

class RowValue
  attr_accessor :row, :col

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

  def value
    return @value unless enumeration?

    cast_value
  end

  def col_id
    col.nil? ? col : col.id
  end

  def row_id
    row.nil? ? row : row.id
  end

  def value?
    value.present?
  end

  private

  ##
  # If there is a SpreadsheetResultRow then the value needs no further treatment.
  #
  def enumeration?
    col&.field_format == 'enumeration' && row.blank?
  end

  ##
  # The value will be transformed from the position number to the custom
  # field enumeration id.
  #
  def cast_value
    entry = col.enumerations.find { |enum| enum.position == @value }
    entry ? entry.id : entry
  end
end
