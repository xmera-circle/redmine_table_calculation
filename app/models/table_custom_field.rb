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

class TableCustomField < CustomField
  def type_name
    :menu_table_calculation
  end

  def self.options_for_select
    TableCustomField.sorted.collect { |custom_field| [custom_field.name, custom_field.id.to_s] }
  end

  # Supports color fields as provided by Redmine Colored Enumeration plugin
  def cast_color(value)
    return '' unless Redmine::Plugin.installed?(:redmine_colored_enumeration)

    format.cast_color(self, value)
  end
end
