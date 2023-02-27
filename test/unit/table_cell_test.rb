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

require File.expand_path('../test_helper', __dir__)

module RedmineTableCalculation
  class TableCellTest < UnitTestCase
    include PrepareSpreadsheet

    fixtures :projects,
             :members, :member_roles, :roles, :users,
             :table_configs, :spreadsheets, :spreadsheet_rows

    setup do
      @row = spreadsheet_rows :spreadsheet_rows_001
      @column = TableCustomField.generate!(name: 'Name')
      @table_row = TableRow.new(row: @row, width: 1)
      add_table_column(@table_row, @column)
      add_content_to_table_row(@table_row, @column)
      @table_cell = @table_row.cells.first
    end

    test 'should know column_id' do
      assert_equal @column.id, @table_cell.column_id
    end

    test 'should know row_id' do
      assert_equal @row.id, @table_cell.row_id
    end

    test 'should know value' do
      assert_equal "Content for #{@column.id}", @table_cell.value
    end

    test 'should know row_index' do
      assert_equal @row.position, @table_cell.row_index
    end

    test 'should know column_index' do
      assert_equal @column.position, @table_cell.column_index
    end
  end
end
