# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
#
# Copyright (C) 2022-2023 Liane Hampe <liaham@xmera.de>, xmera Solutions GmbH.
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
  class SpreadsheetsHelperTest < Redmine::HelperTest
    include RedmineTableCalculation::ProjectTypeCreator
    include RedmineTableCalculation::ProjectCreator
    include SpreadsheetsHelper

    fixtures :projects, :projects_tables,
             :members, :member_roles, :roles, :users,
             :tables, :calculations, :spreadsheets

    def setup
      @plain_project = projects :projects_002
      @project_with_project_type = project(id: 1, type: 4)
      @project_type_master = find_project_type(id: 4)
    end

    def teardown
      @project = nil
    end

    test 'should return all tables for plain projects' do
      @project = @plain_project
      expected_tables = Table.select(:id, :name)
      current_tables = table_select_options
      assert_equal expected_tables, current_tables
    end

    test 'should return all tables for project with project type' do
      @project = @project_with_project_type
      expected_tables = Table.where(id: 1).select(:id, :name)
      current_tables = table_select_options
      assert_equal expected_tables, current_tables
    end

    test 'should return all tables for project type master' do
      @project = @project_type_master
      expected_tables = Table.where(id: 1).select(:id, :name)
      current_tables = table_select_options
      assert_equal expected_tables, current_tables
    end
  end
end
