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
  class CalculationsControllerTest < ActionDispatch::IntegrationTest
    extend TableCalculation::LoadFixtures
    include TableCalculation::AuthenticateUser
    include TableCalculation::CreateProjectType
    include Redmine::I18n

    fixtures :users, :tables, :project_types, :calculations

    test 'index by anonymous should redirect to login form' do
      User.anonymous
      get calculations_url
      assert_redirected_to '/login?back_url=http%3A%2F%2Fwww.example.com%2Fadmin%2Fcalculations'
    end

    test 'index by user should respond with 403' do
      log_user('jsmith', 'jsmith')
      get calculations_url
      assert_response 403
    end

    test 'should render index when admin' do
      log_user('admin', 'admin')
      get calculations_path
      assert_response :success
    end

    test 'should get new' do
      log_user('admin', 'admin')
      get new_calculation_path
      assert_response :success
      assert_template 'new'
    end

    test 'should get edit' do
      log_user('admin', 'admin')
      get edit_calculation_url(id: 1)
      assert_response :success
      assert_template 'edit'
    end

    test 'should redirect after create' do
      log_user('admin', 'admin')
      name = 'Another calculation'
      assert_difference after_create do
        post calculations_url, params: calculation_create_params(name: name)
      end
      assert_redirected_to(controller: 'calculations', action: 'index')
      calculation = Calculation.last
      assert_equal name, calculation.name
    end

    test 'should update' do
      log_user('admin', 'admin')
      calculation_to_change = Calculation.first
      patch calculation_url(calculation_to_change), params: calculation_update_params
      calculation_to_change.reload
      assert_equal 'changed', calculation_to_change.name
    end

    test 'should delete' do
      log_user('admin', 'admin')
      post calculations_url, params: calculation_create_params(name: 'One more table')
      assert_redirected_to(controller: 'calculations', action: 'index')
      assert_difference after_delete do
        delete "/admin/calculations/#{Calculation.last.id}", params: nil
      end
      assert_redirected_to(controller: 'calculations', action: 'index')
    end

    private

    def calculation_create_params(name:, associates: {})
      cf = CustomField.generate!(name: 'Field1',
                                 type: 'TableCustomField',
                                 field_format: 'string' )
      table = Table.new(name: 'Another Table',
                        description: 'for testing',
                        column_ids: ['', cf.id],
                        project_type_ids: ['', 1])
      table.save
      { calculation:
        { name: name,
          description: 'for testing',
          table_id: table.id,
          formula: 'min',
          field_ids: ['', cf.id],
          columns: true,
          rows: false}
        .merge(associates) }
    end

    def calculation_update_params
      cf = CustomField.generate!(name: 'Field2',
                            type: 'TableCustomField',
                            field_format: 'string' )
      table = Table.find(1)
      table.columns << cf
      { calculation: { name: 'changed', table_id: 1,  field_ids: ['', cf.id]} }
    end

    def after_create
      { -> { Calculation.count } => 1 }
    end

    def after_delete
      { -> { Calculation.count } => -1 }
    end
  end
end