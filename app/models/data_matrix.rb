# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
#
# Copyright (C) 2021 - 2022 Liane Hampe <liaham@xmera.de>, xmera.
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

##
# DataMatrix especially provides column vectors having custom values collected
# over the given rows.
#
class DataMatrix
  def initialize(rows, column_ids)
    @rows = rows
    @column_ids = column_ids.uniq
  end

  ##
  # @return Array(String)
  #
  def column_values(id)
    values_by_column[id]&.map(&:last)
  end

  private

  attr_reader :rows, :column_ids, :klass

  ##
  # @return Hash(Integer: Array(Array(Integer, String)))
  #
  # @example { 3: [[3,'12'], [3, '8'], [3, '2']],
  #            5: [[5, 'blue'], [5, 'red'], [5, 'black']] }
  #
  # The key is the column_id. The value consists of a pair
  # of column_id and value. Values are always Strings!
  #
  def values_by_column
    values = []
    rows.each do |row|
      row_related_data(row).each { |pair| values << pair }
    end
    values.group_by(&:first)
  end

  def row_related_data(row)
    row.custom_field_values.map do |cfv|
      [cfv.custom_field_id, cast_value(cfv)]
    end
  end

  ##
  # If key/value field, the command CustomField#cast_value returns for instance
  # #<CustomFieldEnumeration id: 1, custom_field_id: 1, name: "B 1.1 ISMS", active: true, position: 1>
  # If so, the computable value is the position instead of the custom_field_id since
  # it is easier for the user to derive the value from a key/value custom field by
  # counting its position.
  #
  # @note: Could also be implemented in CustomField class.
  #
  def cast_value(cfv)
    value(cfv).is_a?(CustomFieldEnumeration) ? value(cfv).position : value(cfv)
  end

  def value(cfv)
    cfv.custom_field.cast_value(cfv.value)
  end
end
