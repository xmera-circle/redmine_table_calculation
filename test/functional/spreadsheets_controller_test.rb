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
  class SpreadsheetsControllerTest < ActionDispatch::IntegrationTest
    extend TableCalculation::LoadFixtures
    include TableCalculation::AuthenticateUser
    include TableCalculation::ProjectTypeCreator
    include Redmine::I18n

    fixtures :projects,
             :members, :member_roles, :roles, :users,
             :tables, :calculations, :spreadsheets

    def setup
      @manager = User.find(2)
      @manager_role = Role.find_by_name('Manager')

      @project_type_master = find_project_type(id: 4)
      @project_type_master.enable_module!(:table_calculation)
      @project_type_master.members << Member.create(user_id: @manager.id, roles: [@manager_role])

      @project = Project.find(1)
      @project.enable_module!(:table_calculation)
    end

    test 'should show no menu item if not allowed to view spreadsheets' do
      log_user('jsmith', 'jsmith')
      get project_spreadsheets_path(project_id: @project.identifier)
      assert_response 403
    end

    test 'should create no spreadsheet if not allowed to' do
      log_user('jsmith', 'jsmith')

      assert_no_difference 'Spreadsheet.count' do
        post project_spreadsheets_path(project_id: @project.identifier),
             params: { spreadsheet: { name: 'testsheet', table_id: 2 } }
      end
      assert_response 403
    end

    test 'should create spreadsheet if allowed to' do
      @manager_role.add_permission!(:add_spreadsheet)
      assert @manager.allowed_to?(:add_spreadsheet, @project)

      log_user('jsmith', 'jsmith')

      assert_difference 'Spreadsheet.count' do
        post project_spreadsheets_path(project_id: @project.identifier),
             params: { spreadsheet: { name: 'testsheet', table_id: 2 } }
      end
      assert_redirected_to project_spreadsheet_path @project, Spreadsheet.last
    end

    test 'should update spreadsheet configuration if admin' do
      spreadsheet = Spreadsheet.last

      log_user('admin', 'admin')

      patch project_spreadsheet_path(project_id: @project_type_master.identifier,
                                     id: spreadsheet.id),
            params: { spreadsheet: { description: 'A very useful spreadsheet for admins' } }

      assert_redirected_to project_spreadsheet_path @project_type_master, spreadsheet
    end

    test 'should update spreadsheet configuration if allowed to' do
      @manager_role.add_permission!(:configure_spreadsheet)
      assert @manager.allowed_to?(:configure_spreadsheet, @project_type_master)
      spreadsheet = Spreadsheet.last

      log_user('jsmith', 'jsmith')

      patch project_spreadsheet_path(project_id: @project_type_master.identifier,
                                     id: spreadsheet.id),
            params: { spreadsheet: { description: 'A very useful spreadsheet for managers' } }

      assert_redirected_to project_spreadsheet_path @project_type_master, spreadsheet
    end

    test 'should not update spreadsheet configuration if not allowed to' do
      assert_not @manager.allowed_to?(:configure_spreadsheet, @project_type_master)
      spreadsheet = Spreadsheet.last

      log_user('jsmith', 'jsmith')

      patch project_spreadsheet_path(project_id: @project_type_master.identifier,
                                     id: spreadsheet.id),
            params: { spreadsheet: { description: 'A very useful spreadsheet' } }

      assert_response 403
    end
  end
end
