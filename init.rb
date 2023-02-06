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

require File.expand_path('lib/redmine_table_calculation', __dir__)

Redmine::Plugin.register :redmine_table_calculation do
  name 'Table Calculation'
  author 'Liane Hampe (xmera Solutions GmbH)'
  description 'Create a custom table and calculate over columns'
  version '1.0.4'
  url 'https://circle.xmera.de/projects/redmine-table-calculation'
  author_url 'https://circle.xmera.de/users/5'

  requires_redmine version_or_higher: '4.1.0'
  requires_redmine_plugin :redmine_project_types, version_or_higher: '4.0.0'
  requires_redmine_plugin :redmine_colored_enumeration, version_or_higher: '0.1.0'

  menu(:project_menu,
       :menu_table_calculation,
       { controller: 'spreadsheets', action: 'index' },
       param: :project_id,
       caption: :label_menu_table_calculation,
       permission: :view_spreadsheet)

  menu :admin_menu,
       :menu_table_config,
       :tables_path,
       caption: :label_menu_table_config,
       html: { class: 'icon icon-tables' }

  project_module :table_calculation do
    permission :add_spreadsheet, { spreadsheets: %i[new create] }
    permission :view_spreadsheet, { spreadsheets: %i[index show] }
    permission :destroy_spreadsheet, { spreadsheets: :destroy }
    permission :configure_spreadsheet, { spreadsheets: %i[edit update] }
    permission :add_spreadsheet_row, { spreadsheet_rows: %i[new create] }
    permission :edit_spreadsheet_row, { spreadsheet_rows: %i[edit update] }
    permission :destroy_spreadsheet_row, { spreadsheet_rows: %i[destroy] }
  end
end

RedmineTableCalculation.setup
