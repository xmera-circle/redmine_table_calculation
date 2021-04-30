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

class SpreadsheetResultTable
  attr_reader :spreadsheet, :calculations, :columns

  def initialize(spreadsheet)
    @spreadsheet = spreadsheet
    @table = spreadsheet.table
    @calculations = @table.calculations
    @columns = calculable_columns
  end

  ##
  # A result table row of a given column operation.
  #
  def result_row(operation, calculation)
    results = []
    calculation.fields.each do |column|
      results << result_table_row(operation, column, calculation)
    end
    results = extend_result_row(results, calculation)
    results.flatten
  end

  private

  def result_table_row(operation, column, calculation)
    result_value(operation, column, calculation)
  end

  ##
  # A single row value of a given column operation.
  #
  def result_value(operation, column, calculation)
    RowValue.new(value: Formula.new(operation,
                                    column_values(column.id, calculation)).exec,
                 row: nil,
                 col: column)
  end

  ##
  # A result row might have less columns than the underlying table. If so,
  # the gab is filled with empty String values for each missing column.
  #
  # @note: calling columns gives nil, even though the attr_reader is set in
  #   SpreadsheetTable
  def extend_result_row(results, _calculation)
    gap = calculable_columns&.size - results&.size # if @columns&.size&.positive?
    return results unless gap.positive?

    results.append([RowValue.new(value: nil)] * gap).flatten
  end

  ##
  # Provides the calculation base for column operations.
  #
  # @return Array(String) All row values of a given calculable column.
  #
  def column_values(id, calculation)
    data_matrix = DataMatrix.new(rows(calculation.id), calculation.column_ids)
    data_matrix.column_values(id)
  end

  ##
  # Provide rows for further calculation.
  #
  # @node This method might be overridden of other plugins. Therefore, we use
  #   the catch-all argument (*).
  #
  def rows(*)
    spreadsheet.rows
  end

  ##
  # The table may have more columns than needed for calculation.
  # Therefore, all the columns of the spreadsheets calcuations are
  # collected and unified.
  #
  def calculable_columns
    calculations
      .to_a
      .map(&:fields)
      .map(&:split)
      .flatten
      .uniq
  end
end
