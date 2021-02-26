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

module TablesHelper
  def columns_multiselect(_table, choices)
    hidden_field_tag('table[column_ids][]', '').html_safe +
      choices.collect do |choice|
        text, value = (choice.is_a?(Array) ? choice : [choice, choice])
        content_tag(
          'label',
          check_box_tag(
            'table[column_ids][]',
            value,
            @table.column_assigned?(value),
            id: nil
          ) + text.to_s,
          class: 'floating'
        )
      end.join.html_safe
  end

  def project_types_multiselect(_table, choices)
    hidden_field_tag('table[project_type_ids][]', '').html_safe +
      choices.collect do |choice|
        text, value = (choice.is_a?(Array) ? choice : [choice, choice])
        content_tag(
          'label',
          check_box_tag(
            'table[project_type_ids][]',
            value,
            @table.project_type_assigned?(value),
            id: nil
          ) + text.to_s,
          class: 'floating'
        )
      end.join.html_safe
  end

  def available_columns
    TableCustomField.sorted.collect { |t| [t.name, t.id.to_s] }
  end

  def available_project_types
    ProjectType.sorted.collect { |t| [t.name, t.id.to_s] }
  end
end
