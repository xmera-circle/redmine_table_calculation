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

require File.expand_path('../test_helper', __dir__)

module RedmineTableCalculation
  class ResultTableCellTest < UnitTestCase
    setup do
      default_data_table
      @result_table = ResultTable.new(data_table: @data_table)
      @quality_column = data_table_column(2)
      @quality_table_cell = ResultTableCell.new(column: @quality_column,
                                                calculation_config: @max_config)
      @amount_column = data_table_column(3)
      @amount_table_cell = ResultTableCell.new(column: @amount_column,
                                               calculation_config: @sum_config)
      @price_column = data_table_column(4)
      @price_table_cell = ResultTableCell.new(column: @price_column,
                                              calculation_config: @min_config)
    end

    test 'should know its column index' do
      assert_equal 2, @quality_table_cell.column_index
      assert_equal 3, @amount_table_cell.column_index
      assert_equal 4, @price_table_cell.column_index
    end

    test 'should know its row index' do
      assert_equal @max_config.id, @quality_table_cell.row_index
      assert_equal @sum_config.id, @amount_table_cell.row_index
      assert_equal @min_config.id, @price_table_cell.row_index
    end

    test 'should know its underlying custom_field' do
      assert_equal @quality_field, @quality_column.send(:custom_field)
      assert_equal @amount_field, @amount_column.send(:custom_field)
      assert_equal @price_field, @price_column.send(:custom_field)
    end

    test 'should know its value' do
      assert_equal @enumerations.last.id, @quality_table_cell.value
      assert_equal 18, @amount_table_cell.value
      assert_equal 1.80, @price_table_cell.value
    end
  end
end
