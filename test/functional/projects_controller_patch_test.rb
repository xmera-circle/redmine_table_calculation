# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
#
# Copyright (C) 2021 - 2022 Liane Hampe <liaham@xmera.de>, xmera.
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
    include TableCalculation::PrepareSpreadsheet
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
      first_row = SpreadsheetRow.find(3)
      first_row.custom_field_values = { string_column.id => 'Smartphone', int_column.id => 5 }
      first_row.save
      second_row = SpreadsheetRow.find(4)
      second_row.custom_field_values = { string_column.id => 'Laptop', int_column.id => 2 }
      second_row.save
    end

    test 'should not copy spreadsheets when not selected' do
      log_user('admin', 'admin')
      assert_difference 'Project.count' do
        post copy_project_path(id: 4),
             params: {
               project: {
                 name: 'Copy',
                 identifier: 'unique-copy',
                 enabled_module_names: %w[table_calculation]
               },
               only: []
             }
      end
      project = Project.find('unique-copy')
      assert_equal %w[table_calculation], project.enabled_module_names.sort

      assert_equal 1, @project_type_master.spreadsheets.count
      assert_equal 0, project.spreadsheets.count
    end

    test 'should copy spreadsheets when selected' do
      log_user('admin', 'admin')
      assert_difference 'Project.count' do
        post copy_project_path(id: 4),
             params: {
               project: {
                 name: 'Copy',
                 identifier: 'unique-copy',
                 enabled_module_names: %w[table_calculation]
               },
               only: %w[spreadsheets]
             }
      end
      project = Project.find('unique-copy')
      assert_equal %w[table_calculation], project.enabled_module_names.sort

      assert_equal 1, @project_type_master.spreadsheets.count
      assert_equal 1, project.spreadsheets.count
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
      first_row = spreadsheet.rows.first
      second_row = spreadsheet.rows.last
      project_type_master_first_row = @project_type_master.spreadsheets.first.rows.first
      project_type_master_second_row = @project_type_master.spreadsheets.first.rows.last

      assert_equal @project_type_master.id, new_project.project_type_id
      assert_equal 1, spreadsheets.to_a.count
      assert_equal 2, spreadsheet.rows.to_a.count
      assert_equal 'Smartphone', first_row.custom_field_values.first.value
      assert_equal '5', first_row.custom_field_values.last.value
      assert_equal 'Laptop', second_row.custom_field_values.first.value
      assert_equal '2', second_row.custom_field_values.last.value

      assert_equal 'Smartphone', project_type_master_first_row.custom_field_values.first.value
      assert_equal '5', project_type_master_first_row.custom_field_values.last.value
      assert_equal 'Laptop', project_type_master_second_row.custom_field_values.first.value
      assert_equal '2', project_type_master_second_row.custom_field_values.last.value
    end

    # ProjectsController#create based on project type
    # @note Exception handling in ProjectsController is implemented in Redmine Project Types
    test 'should render error message when creating project failed due to invalid spreadsheet' do
      spreadsheet = @project_type_master.spreadsheets.first
      optional_field = TableCustomField.generate!(name: 'Description')
      add_spreadsheet_field(spreadsheet, optional_field)
      add_content_to_spreadsheet(spreadsheet, optional_field)
      required_field = TableCustomField.generate!(name: 'Number', field_format: 'int', is_required: 1)
      add_spreadsheet_field(spreadsheet, required_field)

      log_user('jsmith', 'jsmith')

      assert_no_difference 'Project.count' do
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
      assert_redirected_to settings_project_path(id: @project_type_master.identifier)
      assert flash[:error].match(/has at least 1 spreadsheet row which cannot be saved/)
    end

    # ProjectsController#copy
    # @note Exception handling in ProjectsController is implemented in Redmine Project Types
    test 'should render error message when copying project failed due to invalid spreadsheet' do
      spreadsheet = @project_type_master.spreadsheets.first
      optional_field = TableCustomField.generate!(name: 'Description')
      add_spreadsheet_field(spreadsheet, optional_field)
      add_content_to_spreadsheet(spreadsheet, optional_field)
      required_field = TableCustomField.generate!(name: 'Number', field_format: 'int', is_required: 1)
      add_spreadsheet_field(spreadsheet, required_field)

      log_user('admin', 'admin')
      assert_no_difference 'Project.count' do
        post copy_project_path(id: 4),
             params: {
               project: {
                 name: 'Copy',
                 identifier: 'unique-copy',
                 enabled_module_names: %w[table_calculation]
               },
               only: %w[spreadsheets]
             }
      end
      assert_redirected_to settings_project_path(id: @project_type_master.identifier)
      assert flash[:error].match(/has at least 1 spreadsheet row which cannot be saved/)
    end
  end
end
