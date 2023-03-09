# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
#
# Copyright (C) 2023 Liane Hampe <liaham@xmera.de>, xmera Solutions GmbH.
#
# This program is free software; you can redistribute it and/or
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

module RedmineTableCalculation
  ##
  # Ready to use data table
  #
  # |Name  |Quality|Amount|Price|
  # |------|-------|------|-----|
  # |Apple |value1 |4     |3.95 |
  # |Orange|value2 |6     |1.80 |
  # |Banana|value3 |8     |4.25 |
  #
  # Name:String
  # Quality:Enumeration
  # Amount:Integer
  # Price:Float
  #
  module PrepareDataTable
    def default_data_table
      @name_field = TableCustomField.generate!(name: 'Name')
      @quality_field = TableCustomField.generate!(name: 'Quality',
                                                  field_format: 'enumeration',
                                                  enumerations: enums(%w[1 2 3]))
      @enumerations = @quality_field.enumerations
      @enumeration_values = @enumerations.map(&:id)
      @amount_field = TableCustomField.generate!(name: 'Amount', field_format: 'int')
      @price_field = TableCustomField.generate!(name: 'Price', field_format: 'float')
      fields = [@name_field, @quality_field, @amount_field, @price_field]
      @table_config = create_table_config(name: 'Data Table', columns: fields)
      @max_config = CalculationConfig.generate!(table_config_id: @table_config.id,
                                                name: 'Calculate maximum quality',
                                                formula: 'max',
                                                columns: [@quality_field])
      @min_config = CalculationConfig.generate!(table_config_id: @table_config.id,
                                                name: 'Calculate minimum price',
                                                formula: 'min',
                                                columns: [@price_field])
      @sum_config = CalculationConfig.generate!(table_config_id: @table_config.id,
                                                name: 'Calculate sum of amount',
                                                formula: 'sum',
                                                columns: [@amount_field])
      @columns = {}
      @columns[@name_field] = { values: %w[Apple Orange Banana] }
      @columns[@quality_field] = { values: @enumeration_values }
      @columns[@amount_field] = { values: [4, 6, 8] }
      @columns[@price_field] = { values: [3.95, 1.80, 4.25] }

      @spreadsheet = Spreadsheet.generate!(name: 'Data Sheet', table_config: @table_config)
      @columns.each do |column, configs|
        row_index = 1
        configs[:values].each do |value|
          add_content_to_spreadsheet(object: @spreadsheet, column: column, content: value, row_index: row_index)
          row_index += 1
        end
      end
      @data_table = DataTable.new(spreadsheet: @spreadsheet)
    end

    def data_table_row(row_index)
      @data_table.rows.find { |row| row.index == row_index }
    end

    def data_table_column(column_index)
      @data_table.columns.find { |column| column.index == column_index }
    end

    def data_table_cell(row_index, column_index)
      row = data_table_row(row_index)
      row.cells.find { |cell| cell.column_index == column_index }
    end
  end
end
