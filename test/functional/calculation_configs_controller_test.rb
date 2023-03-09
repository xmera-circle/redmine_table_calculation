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

module RedmineTableCalculation
  class CalculationConfigsControllerTest < ActionDispatch::IntegrationTest
    extend RedmineTableCalculation::LoadFixtures
    include RedmineTableCalculation::AuthenticateUser
    include RedmineTableCalculation::ProjectTypeCreator
    include Redmine::I18n

    fixtures :users, :table_configs, :calculation_configs, :projects

    def setup
      find_project_type(id: 4)
    end

    test 'index by anonymous should redirect to login form' do
      User.anonymous
      get calculation_configs_url
      assert_redirected_to '/login?back_url=http%3A%2F%2Fwww.example.com%2Fadmin%2Fcalculation_configs'
    end

    test 'index by user should respond with 403' do
      log_user('jsmith', 'jsmith')
      get calculation_configs_url
      assert_response 403
    end

    test 'should render index when admin' do
      log_user('admin', 'admin')
      get calculation_configs_path
      assert_response :success
    end

    test 'should get new' do
      log_user('admin', 'admin')
      get new_calculation_config_path
      assert_response :success
    end

    test 'should get edit' do
      log_user('admin', 'admin')
      get edit_calculation_config_url(id: 1)
      assert_response :success
    end

    test 'should redirect after create' do
      log_user('admin', 'admin')
      name = 'Another calculation config'
      assert_difference after_create do
        post calculation_configs_url, params: calculation_config_create_params(name: name)
      end
      assert_redirected_to(controller: 'calculation_configs', action: 'index')
      calculation_config = CalculationConfig.last
      assert_equal name, calculation_config.name
    end

    test 'should update' do
      log_user('admin', 'admin')
      calculation_config_to_change = CalculationConfig.first
      patch calculation_config_url(calculation_config_to_change), params: calculation_config_update_params
      calculation_config_to_change.reload
      assert_equal 'changed', calculation_config_to_change.name
    end

    test 'should delete' do
      log_user('admin', 'admin')
      post calculation_configs_url, params: calculation_config_create_params(name: 'One more table')

      assert_redirected_to(controller: 'calculation_configs', action: 'index')
      assert_difference after_delete do
        delete "/admin/calculation_configs/#{CalculationConfig.last.id}", params: nil
      end
      assert_redirected_to(controller: 'calculation_configs', action: 'index')
    end

    private

    def calculation_config_create_params(name:, associates: {})
      cf = CustomField.generate!(name: 'Field1',
                                 type: 'TableCustomField',
                                 field_format: 'string')
      table_config = TableConfig.new(name: 'Another Table Config',
                                     description: 'for testing',
                                     column_ids: ['', cf.id],
                                     project_type_ids: ['', 4])
      table_config.save
      { calculation_config:
        { name: name,
          description: 'for testing',
          table_config_id: table_config.id,
          formula: 'min',
          column_ids: ['', cf.id] }
          .merge(associates) }
    end

    def calculation_config_update_params
      cf = CustomField.generate!(name: 'Field2',
                                 type: 'TableCustomField',
                                 field_format: 'string')
      table_config = TableConfig.find(1)
      table_config.columns << cf
      { calculation_config: { name: 'changed', table_config_id: 1, column_ids: ['', cf.id] } }
    end

    def after_create
      { -> { CalculationConfig.count } => 1 }
    end

    def after_delete
      { -> { CalculationConfig.count } => -1 }
    end
  end
end
