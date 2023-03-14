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
  class DataTableCellTest < UnitTestCase
    setup do
      setup_default_data_table
      @row = data_table_row(1)
      @name_data_table_cell = data_table_cell(1, 1)
      @quality_data_table_cell = data_table_cell(1, 2)
    end

    test 'should know column_id' do
      assert_equal @name_field.id, @name_data_table_cell.column_id
    end

    test 'should know row_id' do
      assert_equal @row.id, @name_data_table_cell.row_id
    end

    test 'should know value' do
      assert_equal @columns[@name_field][:values][0], @name_data_table_cell.value
      assert_equal @enumerations.first.id.to_s, @quality_data_table_cell.value
    end

    test 'should return position as value when CustomFieldEnumeration' do
      skip
    end

    test 'should know row_index' do
      assert_equal 1, @name_data_table_cell.row_index
    end

    test 'should know column_index' do
      assert_equal 1, @name_data_table_cell.column_index
    end
  end
end
