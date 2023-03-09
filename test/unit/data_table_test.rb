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
  class DataTableTest < UnitTestCase
    setup do
      default_data_table
    end

    test 'should have header' do
      assert_equal @columns.keys, @data_table.header
    end

    test 'should return table rows' do
      klasses = @data_table.rows.map(&:class).uniq
      assert_equal 1, klasses.count
      assert_equal DataTableRow, klasses.first
    end

    test 'should return empty array when table has no rows' do
      table_config = TableConfig.generate!(name: 'Empty Table')
      spreadsheet = Spreadsheet.generate!(table_config: table_config)
      data_table = DataTable.new(spreadsheet: spreadsheet)
      assert_equal [], data_table.rows
    end

    test 'should return table columns' do
      columns = @data_table.columns
      assert_equal 4, columns.count
      assert_equal @columns.keys.map(&:id), columns.map(&:id)
    end
  end
end
