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

class TableCell
  def initialize(**attrs)
    @custom_field_value = attrs[:custom_field_value]
  end

  def value
    row.custom_field_value(column_id)
  end

  delegate :full_text_formatting?, to: :column

  def cast_color
    column.cast_color(value)
  end

  def column_index
    column.position
  end

  delegate :id, to: :column, prefix: true

  def row_index
    row.position
  end

  delegate :id, to: :row, prefix: true

  private

  attr_reader :custom_field_value

  def row
    custom_field_value.customized
  end

  def column
    custom_field_value.custom_field
  end
end
