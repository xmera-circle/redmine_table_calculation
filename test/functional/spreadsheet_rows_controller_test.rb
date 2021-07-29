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
  class SpreadsheetRowsControllerTest < ActionDispatch::IntegrationTest
    extend TableCalculation::LoadFixtures
    include TableCalculation::AuthenticateUser
    include TableCalculation::ProjectTypeCreator
    include Redmine::I18n

    fixtures :projects,
             :members, :member_roles, :roles, :users,
             :tables, :calculations, :spreadsheets, :spreadsheet_rows

    def setup
      @manager = User.find(2)
      @manager_role = Role.find_by_name('Manager')

      @description_field = TableCustomField.generate!(name: 'Description')
      @count_field = TableCustomField.generate!(name: 'Count', field_format: 'int')

      @project_type_master = find_project_type(id: 4)
      @project_type_master.enable_module!(:table_calculation)
      @project_type_master.members << Member.create(user_id: @manager.id, roles: [@manager_role])
      second_table = Table.find(2)
      second_table.columns << [@description_field, @count_field]
      @third_row = SpreadsheetRow.find(3)
      @third_row.custom_field_values = { @description_field.id => 'Item 3', @count_field.id => 3 }
      @third_row.save

      @project = Project.find(1)
      @project.enable_module!(:table_calculation)

      first_table = Table.find(1)
      first_table.columns << [@description_field, @count_field]
      @first_row = SpreadsheetRow.find(1)
      @first_row.custom_field_values = { @description_field.id => 'Item 1', @count_field.id => 1 }
      @first_row.save
      @second_row = SpreadsheetRow.find(2)
      @second_row.custom_field_values = { @description_field.id => 'Item 2', @count_field.id => 2 }
      @second_row.save
    end

    test 'should delete spreadsheet row by admin' do
      assert_equal ['Item 2', '2'], @second_row.custom_field_values.map(&:value)
      spreadsheet = @project.spreadsheets.first

      log_user('admin', 'admin')
      assert_difference 'SpreadsheetRow.count', -1 do
        delete "/spreadsheet_rows/#{@second_row.id}?spreadsheet_id=#{spreadsheet.id}", params: nil
      end
      assert_redirected_to project_spreadsheet_path @project, spreadsheet
    end

    test 'should delete spreadsheet row if allowed to' do
      assert_equal ['Item 2', '2'], @second_row.custom_field_values.map(&:value)
      spreadsheet = @project.spreadsheets.first
      @manager_role.add_permission!(:destroy_spreadsheet_row)

      log_user('jsmith', 'jsmith')
      assert_difference 'SpreadsheetRow.count', -1 do
        delete "/spreadsheet_rows/#{@second_row.id}?spreadsheet_id=#{spreadsheet.id}", params: nil
      end
      assert_redirected_to project_spreadsheet_path @project, spreadsheet
    end

    test 'should not delete spreadsheet row if not allowed to' do
      assert_equal ['Item 2', '2'], @second_row.custom_field_values.map(&:value)
      spreadsheet = @project.spreadsheets.first

      log_user('jsmith', 'jsmith')
      assert_no_difference 'SpreadsheetRow.count' do
        delete "/spreadsheet_rows/#{@second_row.id}?spreadsheet_id=#{spreadsheet.id}", params: nil
      end
      assert_response 403
    end

    test 'should render new spreadsheet row' do
      @manager_role.add_permission!(:add_spreadsheet_row)
      spreadsheet = @project.spreadsheets.first

      log_user('jsmith', 'jsmith')
      get new_project_spreadsheet_spreadsheet_row_path(project_id: @project.id,
                                                       spreadsheet_id: spreadsheet.id)
      assert_response :success
      assert_select '.box.tabular.settings'
      assert_select 'p', 2
    end

    test 'should not render new spreadsheet row if not allowed to' do
      spreadsheet = @project.spreadsheets.first

      log_user('jsmith', 'jsmith')
      get new_project_spreadsheet_spreadsheet_row_path(project_id: @project.id,
                                                       spreadsheet_id: spreadsheet.id)
      assert_response 403
    end

    test 'should create spreadsheet row' do
      spreadsheet = @project.spreadsheets.first
      @manager_role.add_permission!(:add_spreadsheet_row)
      assert @manager.allowed_to?(:add_spreadsheet_row, @project)

      log_user('jsmith', 'jsmith')

      assert_difference 'SpreadsheetRow.count' do
        post project_spreadsheet_spreadsheet_rows_path(project_id: @project.identifier,
                                                       spreadsheet_id: spreadsheet.id),
             params: {
               spreadsheet_row: {
                 custom_field_values: {
                   @description_field.id => 'New Item',
                   @count_field.id => '3'
                 }
               }
             }
      end
      assert_redirected_to project_spreadsheet_path @project, spreadsheet
    end

    test 'should not create spreadsheet row if not allowed to' do
      spreadsheet = @project.spreadsheets.first
      assert_not @manager.allowed_to?(:add_spreadsheet_row, @project)

      log_user('jsmith', 'jsmith')

      assert_no_difference 'SpreadsheetRow.count' do
        post project_spreadsheet_spreadsheet_rows_path(project_id: @project.identifier,
                                                       spreadsheet_id: spreadsheet.id),
             params: {
               spreadsheet_row: {
                 custom_field_values: {
                   @description_field.id => 'New Item',
                   @count_field.id => '3'
                 }
               }
             }
      end
      assert_response 403
    end

    test 'should update spreadsheet row' do
      @manager_role.add_permission!(:edit_spreadsheet_row)
      assert @manager.allowed_to?(:edit_spreadsheet_row, @project_type_master)
      spreadsheet = Spreadsheet.last
      spreadsheet_row = spreadsheet.rows.first

      log_user('jsmith', 'jsmith')

      patch spreadsheet_row_path(id: spreadsheet_row.id),
            params: {
              spreadsheet_row: {
                custom_field_values: {
                  @description_field.id => 'Adjusted item'
                }
              }
            }

      assert_redirected_to project_spreadsheet_path @project_type_master, spreadsheet
    end

    test 'should not update spreadsheet row if not allowed to' do
      assert_not @manager.allowed_to?(:edit_spreadsheet_row, @project_type_master)
      spreadsheet = Spreadsheet.last
      spreadsheet_row = spreadsheet.rows.first

      log_user('jsmith', 'jsmith')

      patch spreadsheet_row_path(id: spreadsheet_row.id),
            params: {
              spreadsheet_row: {
                custom_field_values: {
                  @description_field.id => 'Adjusted item'
                }
              }
            }

      assert_response 403
    end
  end
end
