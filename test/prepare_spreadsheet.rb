# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
#
# Copyright (C) 2022-2023 Liane Hampe <liaham@xmera.de>, xmera Solutions GmbH.
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
  # Some spreadsheets needs special configuration
  #
  module PrepareSpreadsheet
    def create_table_config(**attrs)
      name = attrs[:name]
      columns = attrs[:columns]
      TableConfig.generate!(name: name, columns: columns)
    end

    # @param object [TableConfig|CalculationConfig|Spreadsheet] The available object
    #                                                           as starting point for
    #                                                           adding the column.
    # @param column [TableCustomField] The column which should be added to the config.
    def add_column_to_table_config(**attrs)
      object = attrs[:object]
      column = attrs[:column]
      case object
      when TableConfig
        object.columns << column
      when CalculationConfig, Spreadsheet
        object.table_config.columns << column
      when DataTableRow
        spreadsheet = object.send(:row).spreadsheet
        spreadsheet.table_config.columns << column
      else
        raise "Cannot add #{column} to table with #{object}"
      end
    end

    # @param config [CalculationConfig] The calculation config which should get
    #                                   a further column.
    # @param column [TableCustomField] The column which should be added to the config.
    def add_column_to_calculation_config(**attrs)
      attrs[:config].columns << attrs[:column]
    end

    ##
    # @param object [Spreadsheet|TableRow] An object instance having at least one row.
    # @param column [TableCustomField] A table custom field accepting text as value.
    # @param content [String|Integer|Float|...] The content for the column.
    # @param row_index [Integer] The position of the row in the table, default: 1.
    #
    def add_content_to_spreadsheet(**attrs)
      object = attrs[:object]
      column = attrs[:column]
      content = attrs[:content].presence || "Content for #{column.id}"
      row_index = attrs[:row_index].presence || 1
      case object
      when Spreadsheet
        object.reload
        row = object.rows.find { |item| item.position == row_index }
        row ||= SpreadsheetRow.new(spreadsheet_id: object.id,
                                   table_config: object.table_config,
                                   position: object.rows.count + 1)
        row.custom_field_values = { column.id => content }
        row.save!
      when DataTableRow
        row = object.send(:row)
        row.custom_field_values = { column.id => content }
        row.save!
      else
        raise "Cannot add content for #{column} to spreadsheet with #{object}"
      end
    end

    # @param ids [Array(Integer)] A list of enumeration ids.
    def enums(ids)
      return nil unless ids

      {
        ids[0].to_s => { name: 'value1' },
        ids[1].to_s => { name: 'value2' },
        ids[2].to_s => { name: 'value3' }
      }
    end

    ########################### Replace the methods below with them above ###############

    # @param spreadsheet [Spreadsheet] A spreadsheet instance having at least one row.
    # @param column [TableCustomField] A table custom field accepting text as value.
    def add_spreadsheet_column(spreadsheet, column)
      spreadsheet.table_config.columns << column
    end

    def add_calculation_column(calculation_config, column)
      calculation_config.columns << column
    end
  end
end
