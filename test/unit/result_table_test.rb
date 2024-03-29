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
  class ResultTableTest < UnitTestCase
    setup do
      setup_default_data_table
      @result_table = ResultTable.new(data_table: @data_table)
    end

    test 'should have header' do
      calculation_name = 'Calculation'
      name_field = ''
      field_names = [@quality_field, @amount_field, @price_field].map(&:name)
      expected = field_names.prepend(name_field).prepend(calculation_name)
      actual = @result_table.header.map(&:name)
      assert_equal expected, actual
    end

    test 'should respond to data table rows' do
      assert @result_table.respond_to?(:rows)
    end

    test 'should respond to table config' do
      assert @result_table.respond_to?(:table_config)
    end

    test 'should respond to calculation configs' do
      assert @result_table.respond_to?(:calculation_configs)
    end
  end
end
