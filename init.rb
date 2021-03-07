# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
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

require_dependency 'table_calculation'

Redmine::Plugin.register :redmine_table_calculation do
  name 'Redmine Table Calculation'
  author 'Liane Hampe, xmera'
  description 'Create a custom table and calculate over columns'
  version '0.0.4'
  url 'https://circle.xmera.de/projects/redmine-table-calculation'
  author_url 'http://xmera.de'

  requires_redmine version_or_higher: '4.1.0'
  requires_redmine_plugin :redmine_project_types, version_or_higher: '3.0.3'
  requires_redmine_plugin :redmine_project_types_relations, version_or_higher: '1.0.1'

  # settings  partial: TableCalculation.partial,
  #           default: TableCalculation.defaults

  menu :project_menu,
       :menu_table_calculation,
       { controller: 'spreadsheets', action: 'index' },
       param: :project_id,
       caption: :label_menu_table_calculation

  menu :admin_menu,
       :menu_table_config,
       :tables_path,
       caption: :label_menu_table_config,
       html: { class: 'icon icon-tables' }

  project_module :table_calculation do
    permission :add_spreadsheet, { spreadsheets: %i[new create] }
    permission :view_spreadsheet, { spreadsheets: %i[index show] }
    permission :destroy_spreadsheet, { spreadsheets: :destroy }
    permission :edit_spreadsheet, { spreadsheets: :edit }
    permission :edit_spreadsheet_results, {}
  end
end

ActiveSupport::Reloader.to_prepare do
  table_custom_fields = { name: 'TableCustomField',
                          partial: 'custom_fields/index',
                          label: :table_calculation }
  CustomFieldsHelper::CUSTOM_FIELDS_TABS << table_custom_fields
  Redmine::FieldFormat::RecordList.customized_class_names << 'Table'
  ProjectsController.send :helper, SpreadsheetsHelper
end
