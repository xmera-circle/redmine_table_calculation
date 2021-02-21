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

  def table_settings_tabs
    [{ name: 'table_configs',
       partial: 'tables/configs',
       label: :label_tab_configs },
     { name: 'table_calculations',
       partial: 'tables/calculations',
       label: :label_tab_calculations }]
  end

  # def create_table(object, fields)
  #   content_tag :table, create_table_head_and_body(object, fields), class: 'list'
  # end

  # def create_table_head_and_body(object, fields)
  #   create_thead(object, fields).concat(create_tbody(object, fields))
  # end

  # module_function

  # def create_thead(fields)
  #   content_tag :thead do
  #     content_tag :tr do
  #       fields.collect { |field| concat content_tag(:th, field.name, class: 'name') }.join.html_safe
  #     end
  #   end
  # end

  # def create_tbody(object, fields)
  #   content_tag :tbody do
  #     column_values(object, fields).collect do |value|
  #       content_tag :tr do
  #         concat content_tag(:td, value, class: 'name').to_s.html_safe
  #       end
  #     end.join.html_safe
  #   end
  # end

  # def column_names(fields)
  #   fields.map(&:name).prepend(l(:label_project_type), l(:label_project))
  # end

  # def column_values(object, field_values)
  #   fields.map(&:value).prepend(project.project_type.name, project.name)
  # end
end