# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
#
# Copyright (C) 2022 Liane Hampe <liaham@xmera.de>, xmera.
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

module TableCaclulation
  class SpreadsheetTableTest < ActiveSupport::TestCase
    extend RedmineTableCalculation::LoadFixtures

    fixtures :projects,
             :members, :member_roles, :roles, :users,
             :tables, :spreadsheets, :spreadsheet_rows

    setup do
      spreadsheet = spreadsheets :spreadsheets_001
      @table = SpreadsheetTable.new(spreadsheet)
    end

    test 'should respond to sorted_by_id' do
      assert @table.respond_to? :sorted_by_id
    end

    test 'should respond to rows' do
      assert @table.respond_to? :rows
    end

    test 'should respond to row_ids' do
      assert @table.respond_to? :row_ids
    end

    test 'should return spreadsheet rows' do
      assert_equal [1, 2], @table.rows.map(&:id)
    end

    test 'should return spreadsheet row ids' do
      assert_equal [1, 2], @table.row_ids
    end
  end
end
