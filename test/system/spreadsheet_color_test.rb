# frozen_string_literal: true

# frozen enum_literal: true

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

require File.expand_path('../test_helper', __dir__)

module RedmineTableCalculation
  class SpreadsheetColorTest < ApplicationSystemTestCase
    extend LoadFixtures
    include Enumerations
    include ProjectTypeCreator

    fixtures :projects,
             :members, :member_roles, :roles, :users,
             :table_configs, :calculation_configs, :spreadsheets, :spreadsheet_rows

    def setup
      super
      @project_type_master = find_project_type(id: 4)
      @project_type_master.enable_module!(:table_calculation)
      table_config = TableConfig.find(2)
      enum_column = create_colored_custom_field
      enum_values = enum_column.enumerations.pluck(:id)
      int_column = TableCustomField.generate!(name: 'Count', field_format: 'int')
      int_values = [5, 2]
      table_config.columns << [enum_column, int_column]
      first_row = SpreadsheetRow.find(3)
      first_row.custom_field_values = { enum_column.id => enum_values.first, int_column.id => int_values.first }
      first_row.save
      second_row = SpreadsheetRow.find(4)
      second_row.custom_field_values = { enum_column.id => enum_values.second, int_column.id => int_values.second }
      second_row.save
      Capybara.current_session.reset!
      log_user 'admin', 'admin'
    end

    test 'should render custom field enumeration color badge in result row' do
      visit project_spreadsheet_path(project_id: @project_type_master.id, id: 2)
      expected_color = 'rgba(255, 255, 0, 1)'
      Capybara.match = :first # since there are two badges (1 x yellow, 1 x green)
      current_color = page.find('.enumeration-badge td').style('background-color')['background-color']
      assert_equal expected_color, current_color
    end
  end
end
