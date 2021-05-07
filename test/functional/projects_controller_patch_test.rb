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

require File.expand_path('../test_helper', __dir__)

module TableCaclulation
  class ProjectsControllerPatchTest < ActionDispatch::IntegrationTest
    extend TableCalculation::LoadFixtures
    include TableCalculation::AuthenticateUser
    include TableCalculation::ProjectTypeCreator
    include TableCalculation::TestObjectCreators
    include Redmine::I18n

    fixtures :projects, :users, :roles, :members,
             :member_roles, :enabled_modules,
             :tables, :calculations, :spreadsheets,
             :projects_tables, :spreadsheet_rows

    def setup
      @project_type_master = find_project_type(id: 4)
      table = Table.find(2)
      string_column = TableCustomField.generate!(name: 'Name', field_format: 'string')
      int_column = TableCustomField.generate!(name: 'Count', field_format: 'int')
      table.columns << [string_column, int_column]
      row = SpreadsheetRow.find(3)
      row.custom_field_values = { string_column.id => 'Smartphone', int_column.id => 5 }
      row.save
    end

    test 'should copy spreadsheet when creating project with project type' do
      log_user('jsmith', 'jsmith')

      assert_difference 'Project.count' do
        post projects_path, params: {
          project: {
            name: 'Project with project type',
            identifier: 'project-with-project-type',
            is_public: false,
            project_type_id: @project_type_master.id,
            is_project_type: false
          }
        }
      end
      assert_redirected_to settings_project_path(id: 'project-with-project-type')

      new_project = Project.last
      spreadsheets = new_project.spreadsheets
      spreadsheet = spreadsheets.first
      row = spreadsheet.rows.first
      project_type_master_row = @project_type_master.spreadsheets.first.rows.first

      assert_equal @project_type_master.id, new_project.project_type_id
      assert_equal 1, spreadsheets.to_a.count
      assert_equal 1, spreadsheet.rows.to_a.count
      assert_equal 'Smartphone', row.custom_field_values.first.value
      assert_equal '5', row.custom_field_values.last.value
      assert_equal 'Smartphone', project_type_master_row.custom_field_values.first.value
      assert_equal '5', project_type_master_row.custom_field_values.last.value
    end
  end
end
