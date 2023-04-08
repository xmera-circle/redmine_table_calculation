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
  class DataTableColumnTest < UnitTestCase
    setup do
      setup_default_data_table
    end

    test 'should return cells' do
      klasses = data_table_row(1).cells.map(&:class).uniq
      assert_equal 1, klasses.count
      assert_equal DataTableCell, klasses.first
    end

    test 'should return values' do
      assert_equal %w[Apple Orange Banana], data_table_column(1).values
      assert_equal @enumerations.map(&:id).map(&:to_s), data_table_column(2).values
      assert_equal %w[4 6 8], data_table_column(3).values
      assert_equal %w[3.95 1.8 4.25], data_table_column(4).values
    end
  end
end
