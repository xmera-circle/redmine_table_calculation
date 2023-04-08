# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
#
# Copyright (C) 2022-2023 Liane Hampe <liaham@xmera.de>, xmera Solutions GmbH.
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
  class SpreadsheetRowTest < UnitTestCase
    setup do
      @spreadsheet_row = spreadsheet_rows :spreadsheet_rows_001
    end

    test 'should respond to visible?' do
      assert @spreadsheet_row.respond_to? :visible?
    end

    test 'should respond to available_custom_fields' do
      assert @spreadsheet_row.respond_to? :available_custom_fields
    end

    test 'should respond to copy_values' do
      assert @spreadsheet_row.respond_to? :copy_values
    end

    test 'should respond to assign_values' do
      assert @spreadsheet_row.respond_to? :assign_values
    end
  end
end
