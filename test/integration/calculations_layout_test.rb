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
  class CalculationsLayoutTest < ActionDispatch::IntegrationTest
    extend RedmineTableCalculation::LoadFixtures
    include RedmineTableCalculation::AuthenticateUser
    include RedmineTableCalculation::ProjectTypeCreator
    include Redmine::I18n

    fixtures :users, :table_configs, :calculation_configs

    test 'should render index with calculation configs' do
      log_user('admin', 'admin')
      get calculation_configs_path
      assert_response :success
      assert_select 'table.calculation-configs'
      assert_select 'table.list.calculation-configs tbody tr', 2
    end

    test 'should render new form' do
      log_user('admin', 'admin')
      get new_calculation_config_path
      assert_response :success
      assert_select '#calculation_config_name'
      assert_select '#calculation_config_description'
      assert_select '#calculation_config_table_config_id'
      assert_select '#calculation_config_formula'
      assert_select '#calculation_config_column_ids'
    end
  end
end
