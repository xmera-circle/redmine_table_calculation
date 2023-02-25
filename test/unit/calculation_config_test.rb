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
  class CalculationConfigTest < UnitTestCase
    fixtures :table_configs, :calculation_configs

    test 'should belong to table' do
      association = CalculationConfig.reflect_on_association(:table_config)
      assert_equal :table_config, association.name
      assert_equal :belongs_to, association.macro
    end

    test 'should have many fields' do
      association = CalculationConfig.reflect_on_association(:columns)
      assert_equal :columns, association.name
      assert_equal :has_and_belongs_to_many, association.macro
    end

    test 'should respond to safe attributes' do
      assert CalculationConfig.respond_to? :safe_attributes
    end

    test 'should respond to locale_formula' do
      assert CalculationConfig.find(1).respond_to? :locale_formula
    end

    test 'table should not be valid without attributes' do
      calc = CalculationConfig.new
      assert_not calc.valid?
      assert_equal %i[name table_config formula column_ids].sort, calc.errors.keys.sort
    end

    test 'should not save calculabe columns from other table config' do
      cf2 = custom_field('CF2')
      cf3 = custom_field('CF3')
      table_config = TableConfig.find(1)
      table_config.columns << cf2
      calc = CalculationConfig.new(name: 'Calculate SUM',
                                   table_config_id: 1,
                                   formula: 'sum',
                                   column_ids: ['', cf3.id])
      assert_not calc.valid?
      assert_equal [:columns], calc.errors.keys
    end

    test 'should save calculable columns' do
      cf2 = custom_field('CF2')
      table_config = TableConfig.find(1)
      table_config.columns << cf2
      calc = CalculationConfig.new(name: 'Calculate SUM',
                                   table_config_id: 1,
                                   formula: 'sum',
                                   column_ids: ['', cf2.id])
      assert calc.save
      assert_equal [cf2.id], calc.column_ids
    end

    test 'should delete calculation' do
      calc = CalculationConfig.find(2)
      assert calc.destroy
      assert calc.destroyed?
    end

    private

    def custom_field(name)
      CustomField.generate! custom_field_attributes(name: name)
    end

    def custom_field_attributes(name:)
      { name: name,
        regexp: '',
        is_for_all: true,
        is_filter: true,
        type: 'TableCustomField',
        possible_values: %w[A B C],
        is_required: false,
        field_format: 'list',
        default_value: '',
        editable: true }
    end
  end
end
