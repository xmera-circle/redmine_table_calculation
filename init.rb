# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculator.
#
# Copyright (C) 2020-2021 Liane Hampe <liaham@xmera.de>, xmera.
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

require_dependency 'redmine_table_calculator'

Redmine::Plugin.register :redmine_table_calculator do
  name 'Redmine Table Calculator'
  author 'Liane Hampe, xmera'
  description 'Create a custom table and calculate over columns or rows'
  version '0.0.1'
  url 'https://circle.xmera.de/projects/redmine-table-calculator'
  author_url 'http://xmera.de'

  requires_redmine version_or_higher: '4.1.0'

  settings  partial: RedmineTableCalculator.partial,
            default: RedmineTableCalculator.defaults

  menu :project_menu, 
       :table_calculator, 
       { controller: 'tables', action: 'index' }, 
        caption: :menu_table_calculator, 
        html: { class: 'icon icon-types' }
  project_module :table_calculator do
    permission :view_tables, { :tables => [:index, :show] }, :public => true
    permission :destroy_tables, { :tables => :destroy }
  end
end

ActiveSupport::Reloader.to_prepare do
  table_custom_fields = { name: 'TableCustomField', 
                          partial: 'custom_fields/index',
                          label: :table_calculation }
  CustomFieldsHelper::CUSTOM_FIELDS_TABS << table_custom_fields
end