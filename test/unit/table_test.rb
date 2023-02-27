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
  class TableTest < UnitTestCase
    include PrepareSpreadsheet

    fixtures :projects,
             :members, :member_roles, :roles, :users,
             :table_configs, :spreadsheets, :spreadsheet_rows

    setup do
      @column = TableCustomField.generate!(name: 'Name')
      spreadsheet = spreadsheets :spreadsheets_001
      add_spreadsheet_column(spreadsheet, @column)
      add_content_to_spreadsheet(spreadsheet, @column)
      @table = Table.new(spreadsheet: spreadsheet)
    end

    test 'should have header' do
      assert_equal [@column], @table.header
    end

    test 'should know table width' do
      assert_equal 1, @table.width
    end

    test 'should return table rows' do
      klasses = @table.rows.map(&:class).uniq
      assert_equal 1, klasses.count
      assert_equal TableRow, klasses.first
    end

    test 'should return table length' do
      assert_equal 2, @table.length
    end

    test 'should return empty array when table has no rows' do
      skip
    end
  end
end
