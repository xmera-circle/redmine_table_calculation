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
  class TablesControllerTest < ActionDispatch::IntegrationTest
    extend TableCalculation::LoadFixtures
    include TableCalculation::AuthenticateUser
    include TableCalculation::CreateProjectType
    include Redmine::I18n

    fixtures :users, :tables

    test 'index by anonymous should redirect to login form' do
      User.anonymous
      get tables_url
      assert_redirected_to '/login?back_url=http%3A%2F%2Fwww.example.com%2Ftables'
    end

    test 'index by user should respond with 403' do
      log_user('jsmith', 'jsmith')
      get tables_url
      assert_response 403
    end

    test 'should render index when admin' do
      log_user('admin', 'admin')
      get tables_path
      assert_response :success
      assert_select 'table.config-tables'
    end

    test 'should get new' do
      log_user('admin', 'admin')
      get new_table_url
      assert_response :success
      assert_template 'new'
    end

    test 'should get edit' do
      log_user('admin', 'admin')
      get edit_table_url(id: 1)
      assert_response :success
      assert_template 'edit'
    end
  end
end