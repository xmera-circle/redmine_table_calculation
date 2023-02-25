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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

require File.expand_path('../test_helper', __dir__)

module RedmineTableCalculation
  class DataMatrixTest < UnitTestCase
    fixtures :projects,
             :members, :member_roles, :roles, :users,
             :table_configs, :spreadsheets, :spreadsheet_rows, :calculation_configs

    def setup
      @table_config = TableConfig.find(1)
      @calculation_config = CalculationConfig.find(1)
    end

    test 'should respond to column_values' do
      matrix = DataMatrix.new([], [])
      assert matrix.respond_to? :column_values
    end

    # test is unstable since it could sometimes not find its enumerations
    test 'should use position to calculate with enumerations' do
      row1 = SpreadsheetRow.find(1)
      field1 = custom_field('enumeration', %w[1 2 3])
      field1_values = field1.enumerations.pluck(:id)
      value1 = field1_values.first
      row1.custom_field_values << custom_field_value(field1, row1, value1)
      row2 = SpreadsheetRow.find(2)
      field2 = custom_field('enumeration', %w[4 5 6])
      field2_values = field2.enumerations.pluck(:id)
      value2 = field2_values.second
      row2.custom_field_values << custom_field_value(field2, row2, value2)
      rows = [row1, row2]
      column_ids = []
      matrix = DataMatrix.new(rows, column_ids)
      grouped_values = matrix.send :values_by_column
      expected = {}
      # the second item in the inner arrays is the position of the enum whereas
      # the value added above is the enum id. This is since we calculate with
      # the position but identify the enums via id.
      expected.merge!({ field1.id => [[field1.id, 1]], field2.id => [[field2.id, 2]] })
      assert_equal expected, grouped_values
      # change values, i.e., position
      enum1 = CustomFieldEnumeration.find(field1_values.first)
      enum3 = CustomFieldEnumeration.find(field1_values.last)
      enum1.update_attribute(:position, 3)
      enum3.update_attribute(:position, 1)
      grouped_values = matrix.send :values_by_column
      expected = {}
      expected.merge!({ field1.id => [[field1.id, 3]], field2.id => [[field2.id, 2]] })
      assert_equal expected, grouped_values
    end

    test 'should use value to calculate with list and numbers' do
      value1 = '8'
      row1 = SpreadsheetRow.find(1)
      field1 = custom_field('int')
      row1.custom_field_values << custom_field_value(field1, row1, value1)
      value2 = '5'
      row2 = SpreadsheetRow.find(2)
      field2 = custom_field('int')
      row2.custom_field_values << custom_field_value(field2, row2, value2)
      rows = [row1, row2]
      column_ids = []
      matrix = DataMatrix.new(rows, column_ids)
      grouped_values = matrix.send :values_by_column
      expected = {}
      expected.merge!({ field1.id => [[field1.id, 8]], field2.id => [[field2.id, 5]] })
      assert_equal expected, grouped_values
    end

    private

    def custom_field_value(field, row, value)
      CustomFieldValue.new({ custom_field: field, customized: row, value: value })
    end

    def custom_field(format, ids = nil, attributes: {})
      column_field(
        format,
        attributes: attributes,
        enumerations: enums(ids)
      )
    end

    def enums(ids)
      return nil unless ids

      {
        ids[0].to_s => { name: 'value1' },
        ids[1].to_s => { name: 'value2' },
        ids[2].to_s => { name: 'value3' }
      }
    end

    def column_field(format, attributes: {}, enumerations: {})
      @generated_field_name ||= +"#{format.capitalize} Field 0"
      @generated_field_name.succ!
      params = attributes.merge(name: @generated_field_name,
                                field_format: format, is_for_all: true)
      field = TableCustomField.create params
      if enumerations.present?
        enumerations.each do |_key, values|
          field.enumerations.build(values)
          field.save!
        end
      end
      field
    end
  end
end
