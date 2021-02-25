# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
#
# Copyright (C) 2021 Liane Hampe <liaham@xmera.de>, xmera.
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

class DataMatrix
  def initialize(row_ids, column_ids)
    @row_ids = row_ids
    @column_ids = column_ids.uniq
  end

  ##
  # @return Array(String)
  #
  def column_values(id)
    values_by_column[id]&.map(&:last)
  end

  private

  attr_reader :row_ids, :column_ids

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
    CustomValue
      .where(customized_id: row_ids)
      .where(custom_field_id: column_ids)
      .pluck(:custom_field_id, :value)
      .group_by(&:first)
  end
end