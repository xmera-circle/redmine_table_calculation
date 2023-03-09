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

class ResultTableHeader
  include Redmine::I18n
  include Enumerable

  # @param data_table_header [Array(CustomField)] CustomField objects sorted
  #                                               by its position.
  # @param calculation_columns [Array(CustomField)] Unique CustomField objects
  #                                                 sorted by its position.
  def initialize(**attrs)
    @data_table_header = attrs[:data_table_header]
    @calculation_columns = attrs[:calculation_columns]
  end

  # Prepares the header columns sorted and placed at its position in the
  # underlying table.
  def columns
    sorted = cells.sort_by(&:position)
    sorted.prepend(SpareTableCell.new(column_index: 0, name: l(:label_calculation)))
  end

  # Allows to iterate through TableCustomField instances
  def each(&block)
    calculation_columns.each(&block)
  end

  private

  attr_reader :data_table_header, :calculation_columns

  # Separate TableCustomFields used for calculation by those
  # not to be used for calculation.
  def cells
    data_table_header.map do |column|
      if calculable?(column.id)
        column
      else
        SpareTableCell.new(position: column.position, name: '')
      end
    end
  end

  def calculable?(id)
    calculation_column_ids.include? id
  end

  def calculation_column_ids
    map(&:id).flatten
  end
end
