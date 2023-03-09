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

# The SpareTableCell is no fully equipped table cell. Instead it is a reduced
# variation able to respond to the most important attributes.
#
class SpareTableCell
  attr_reader :row_index, :column_index, :position, :name, :value, :description

  def initialize(**attrs)
    @row_index = attrs[:row_index]
    @column_index = attrs[:column_index]
    @position = attrs[:position]
    @name = attrs[:name]
    @value = attrs[:value]
  end

  def custom_field
    nil
  end

  def cast_color
    ''
  end

  def full_text_formatting?
    false
  end
end
