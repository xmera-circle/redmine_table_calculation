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

class ResultTableCell
  include Enumerable

  attr_reader :custom_field, :description

  delegate :full_text_formatting?, to: :custom_field
  delegate :index, to: :column, prefix: true

  # @param column [DataTableColumn] A column from the underlying DataTable.
  # @param calculation_config [CalculationConfig] A CalculationConfig object
  #                                               corresponding to the underlying
  #                                               DataTable.
  def initialize(**attrs)
    @column = attrs[:column]
    @calculation_config = attrs[:calculation_config]
    @custom_field = column.custom_field
    @enumerations = custom_field.enumerations
  end

  # Raw value will be casted and formatted in SpreadsheetsHelper#format_table_value
  def value
    raw_result_value
  end

  # Color of a TableCustomField value with field_format :enumeration
  def cast_color
    custom_field.cast_color(raw_result_value)
  end

  # Row position of the cell in the ResultTable
  def row_index
    calculation_config.id
  end

  private

  attr_reader :column, :calculation_config, :enumerations

  delegate :formula, to: :calculation_config
  delegate :format, to: :column

  def each(&block)
    column.each(&block)
  end

  # Returns the raw result value where especially the enumeration custom field
  # is retransformed.
  def raw_result_value
    enumeration? ? retransform_enumeration : result
  end

  def result
    @result ||= TableFormula.new(formula, calculable_values).exec
  end

  def calculable_values
    map do |cell|
      prepared_value_for_operation(cell.casted_value)
    end
  end

  # Transforms every value into a calculabe value.
  #
  # @note Changes behavior for CustomFieldEnumeration
  #
  #       If key/value field, the command CustomField#cast_value returns for instance
  #       #<CustomFieldEnumeration id: 1, custom_field_id: 1, name: "B 1.1 ISMS", active: true, position: 1>
  #       If so, the computable value is the position instead of the custom_field_id since
  #       it is easier for the user to derive the value from a key/value custom field by
  #       counting its position.
  #
  # @return [Integer|Float|nil] Will return nil if the cell has no format or the enumeration has no value.
  #
  def prepared_value_for_operation(value)
    case format
    when 'float'
      value.to_f
    when 'int'
      value.to_i
    when 'bool'
      value ? 1 : 0
    when 'enumeration'
      value&.position
    end
  end

  def enumeration?
    format == 'enumeration'
  end

  # Finds the id of the CustomFieldEnumeration object corresponding to the
  # calculation result what is a position number.
  def retransform_enumeration
    item = enumerations.find { |enum| enum.position == result }
    item&.id
  end
end
