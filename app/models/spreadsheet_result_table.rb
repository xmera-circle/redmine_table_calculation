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

class SpreadsheetResultTable
  attr_reader :spreadsheet, :calculation_configs, :columns

  def initialize(spreadsheet)
    @spreadsheet = spreadsheet
    @table_config = spreadsheet.table_config || NullTableConfig.new
    @calculation_configs = @table_config.calculation_configs
    @columns = calculable_columns
  end

  ##
  # A result table row of a given column operation.
  #
  def result_row(operation, calculation_config)
    results = []
    calculation_config.columns.each do |column|
      results << result_table_row(operation, column, calculation_config)
    end
    results = extend_result_row(results, calculation_config)
    results.flatten
  end

  private

  def result_table_row(operation, column, calculation_config)
    result_value(operation, column, calculation_config)
  end

  ##
  # A single row value of a given column operation.
  #
  def result_value(operation, column, calculation_config)
    RowValue.new(value: calculation_result(operation, column, calculation_config),
                 row: nil,
                 col: column)
  end

  def calculation_result(operation, column, calculation_config)
    TableFormula.new(operation, column_values(column.id, calculation_config)).exec
  end

  ##
  # A result row might have less columns than the underlying table. If so,
  # the gab is filled with empty String values for each missing column.
  #
  # @note: calling columns gives nil, even though the attr_reader is set in
  #   SpreadsheetTable
  def extend_result_row(results, _calculation_config)
    gap = calculable_columns_size - results&.size
    return results unless gap.positive?

    results.append([RowValue.new(value: nil)] * gap).flatten
  end

  ##
  # Provides the calculation base for column operations.
  #
  # @return Array(String) All row values of a given calculable column.
  #
  def column_values(id, calculation_config)
    data_matrix(calculation_config).column_values(id)
  end

  def data_matrix(calculation_config)
    DataMatrix.new(rows(calculation_config.id), calculation_config.column_ids)
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
    calculation_configs
      .to_a
      .map(&:columns)
      .map(&:split)
      .flatten
      .uniq
  end

  def calculable_columns_size
    calculable_columns&.size
  end
end
