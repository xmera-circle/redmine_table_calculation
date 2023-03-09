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
  class TableConfigTest < UnitTestCase
    test 'should have many columns' do
      association = TableConfig.reflect_on_association(:columns)
      assert_equal :columns, association.name
      assert_equal :has_and_belongs_to_many, association.macro
    end

    test 'should have many project types' do
      association = TableConfig.reflect_on_association(:project_types)
      assert_equal :project_types, association.name
      assert_equal :has_and_belongs_to_many, association.macro
    end

    test 'should respond to safe attributes' do
      assert TableConfig.respond_to? :safe_attributes
    end

    test 'should respond to column_assigned?' do
      assert TableConfig.find(1).respond_to? :column_assigned?
    end

    test 'should respond to project_type_assigned?' do
      assert TableConfig.find(1).respond_to? :project_type_assigned?
    end

    test 'table should not be valid without name' do
      table_config = TableConfig.new
      assert_not table_config.valid?
      assert_equal [:name], table_config.errors.keys
    end

    test 'should find columns and project types' do
      cf = custom_field
      table_config = TableConfig.find(1)
      table_config.columns << cf
      assert table_config.save
      assert table_config.columns.count == 1
      find_project_type(id: 4)
      assert table_config.project_types.count == 1
    end

    test 'should update table' do
      table_config = TableConfig.new(name: 'Table config to update')
      name = 'Updated Table config'
      table_config.name = name
      assert table_config.save
      assert table_config.name == name
    end

    test 'should delete table' do
      table_config = TableConfig.new(name: 'Table config to delete')
      assert table_config.destroy
      assert table_config.destroyed?
    end

    private

    def custom_field
      CustomField.generate! custom_field_attributes(name: 'Table Column')
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
