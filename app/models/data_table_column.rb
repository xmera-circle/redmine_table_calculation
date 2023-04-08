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

class DataTableColumn
  include Enumerable

  def initialize(**attrs)
    @column = attrs[:column]
    @table_config = attrs[:table_config]
  end

  # Position of the column in the table
  def index
    map(&:column_index).uniq[0]
  end

  # Custom field id for this column
  def id
    map(&:column_id).uniq[0]
  end

  # Raw values of DataTableCells in this column
  def values
    map(&:value)
  end

  # Format of the underlying custom field
  def format
    map(&:format).uniq[0]
  end

  # Custom field object
  def custom_field
    map(&:custom_field).uniq[0]
  end

  # Is the column relevant for the given calculation?
  def calculable?(calculation_config)
    calculation_config.column_ids.include? id
  end

  # Allows to iterate through DataTableCell instances
  def each(&block)
    column.each(&block)
  end

  private

  attr_reader :column, :table_config

  delegate :calculation_configs, to: :table_config
end
