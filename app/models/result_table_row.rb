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

class ResultTableRow
  include Enumerable

  # @param columns [Array(DataTableColumn)] Columns of the underlying DataTable.
  # @param calculation_config [CalculationConfig] A Calculation configuration of
  #                                               the underlying table config.
  def initialize(**attrs)
    @columns = attrs[:columns]
    @calculation_config = attrs[:calculation_config]
  end

  # Position of the row in the ResultTable
  def index
    calculation_config_id
  end

  # @return [Array(ResultTableCell)] The row containing ResultTableCell objects
  #                                  each with its calculation result accessable
  #                                  by ResultTableCell#value.
  #
  def calculate
    results = map do |column|
      if column.calculable?(calculation_config)
        ResultTableCell.new(column: column, calculation_config: calculation_config)
      else
        SpareTableCell.new(value: '', column_index: column.index, row_index: calculation_config_id)
      end
    end
    results.prepend(SpareTableCell.new(value: calculation_config.name,
                                       description: calculation_config.description,
                                       column_index: 0,
                                       row_index: calculation_config_id))
  end

  private

  attr_reader :columns, :calculation_config

  delegate :id, to: :calculation_config, prefix: true

  # Allows to iterate through DataTableColumn instances
  def each(&block)
    columns.each(&block)
  end
end
