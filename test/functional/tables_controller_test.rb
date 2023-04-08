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

require File.expand_path('../test_helper', __dir__)

module TableCaclulation
  class TablesControllerTest < ActionDispatch::IntegrationTest
    extend RedmineTableCalculation::LoadFixtures
    include RedmineTableCalculation::AuthenticateUser
    include RedmineTableCalculation::ProjectTypeCreator
    include Redmine::I18n

    fixtures :users, :table_configs, :projects

    def setup
      find_project_type(id: 4)
    end

    test 'index by anonymous should redirect to login form' do
      User.anonymous
      get table_configs_url
      assert_redirected_to '/login?back_url=http%3A%2F%2Fwww.example.com%2Fadmin%2Ftable_configs'
    end

    test 'index by user should respond with 403' do
      log_user('jsmith', 'jsmith')
      get table_configs_url
      assert_response 403
    end

    test 'should render index when admin' do
      log_user('admin', 'admin')
      get table_configs_path
      assert_response :success
    end

    test 'should get new' do
      log_user('admin', 'admin')
      get new_table_config_path
      assert_response :success
    end

    test 'should get edit' do
      log_user('admin', 'admin')
      get edit_table_config_url(id: 1)
      assert_response :success
    end

    test 'should redirect after create' do
      log_user('admin', 'admin')
      name = 'Another table'
      assert_difference after_create do
        post table_configs_url, params: table_config_create_params(name: name)
      end
      assert_redirected_to(controller: 'table_configs', action: 'index')
      table_config = TableConfig.last
      assert_equal name, table_config.name
      assert_equal 1, table_config.columns.count
      assert_equal 1, table_config.project_types.count
    end

    test 'should update' do
      log_user('admin', 'admin')
      table_config_to_change = TableConfig.first
      patch table_config_url(table_config_to_change), params: table_config_update_params
      table_config_to_change.reload
      assert_equal 'changed', table_config_to_change.name
    end

    test 'should delete' do
      log_user('admin', 'admin')
      post table_configs_url, params: table_config_create_params(name: 'One more table')
      assert_redirected_to(controller: 'table_configs', action: 'index')
      assert_difference after_delete do
        delete "/admin/table_configs/#{TableConfig.last.id}", params: nil
      end
      assert_redirected_to(controller: 'table_configs', action: 'index')
    end

    private

    def table_config_create_params(name:, associates: {})
      cf = CustomField.generate!(name: 'Field1',
                                 type: 'TableCustomField',
                                 field_format: 'string')
      { table_config:
        { name: name,
          description: 'for testing',
          column_ids: ['', cf.id],
          project_type_ids: ['', 4] }
          .merge(associates) }
    end

    def table_config_update_params
      { table_config: { name: 'changed' } }
    end

    def after_create
      { -> { TableConfig.count } => 1 }
    end

    def after_delete
      { -> { TableConfig.count } => -1 }
    end
  end
end
