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

module RedmineTableCalculation
  module CalculationUtils
    # Iterates through each calculation config and collects the columns
    def calculation_columns
      column_collection = calculation_configs.map(&:columns)
      column_collection.flatten.uniq.sort_by(&:position)
    end

    def calculation_column_positions
      calculation_column.map(&:position)
    end

    def calculation_column_ids
      return unless calculation_configs.presence

      calculation_configs
        .map(&:column_ids)
        .flatten
    end

    def calculable?(column)
      calculation_columns.include?(column)
    end

    # Iterates through each table column and sorts them by position
    def table_columns
      column_collection = table_config.columns
      column_collection.sort_by(&:position)
    end
  end
end
