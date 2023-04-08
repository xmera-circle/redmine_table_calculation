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

class ResultTable
  include RedmineTableCalculation::CalculationUtils
  delegate :rows, :header, to: :data_table, prefix: true

  # @param data_table [DataTable] A DataTable object.
  def initialize(**attrs)
    @data_table = attrs[:data_table]
  end

  # A ResultTable exists only if there is a DataTable object with calculation
  # configurations.
  def exist?
    data_table.presence && calculation_configs.presence
  end

  # The header of a result table having empty columns where no result is
  # required and a first column header for the calculation name.
  def header
    return [] unless exist?

    ResultTableHeader.new(data_table_header: data_table_header,
                          calculation_columns: calculation_columns).columns
  end

  # Result rows, one for each calculation.
  def rows
    calculation_configs&.map do |calculation|
      result_row(calculation).calculate
    end
  end

  private

  attr_reader :data_table

  delegate :table_config, to: :data_table
  delegate :calculation_configs, to: :table_config

  # A single result row determined by the given calculation config.
  def result_row(calculation_config)
    ResultTableRow.new(columns: data_table_columns(calculation_config), calculation_config: calculation_config)
  end

  # Differentciate between columns for a certain calculation if necessary
  #
  # @note It is necessary when columns are provided by an AggregatedDataTable
  #       as used in RedmineTableCalculationInheritance.
  def data_table_columns(calculation_config)
    cols = data_table.columns
    return cols if cols.is_a?(Array)

    cols[calculation_config]
  end
end
