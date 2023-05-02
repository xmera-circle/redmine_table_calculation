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

# Suppresses ruby gems warnings when running tests
$VERBOSE = nil

# Load the Redmine helper
require File.expand_path('../../../test/test_helper', __dir__)
require File.expand_path('../../../test/application_system_test_case', __dir__)
require_relative 'load_fixtures'
require_relative 'authenticate_user'
require_relative 'enumerations'
require_relative 'project_type_creator'
require_relative 'project_creator'
require_relative 'test_object_creators'
require_relative 'prepare_spreadsheet'
require_relative 'prepare_data_table'

module RedmineTableCalculation
  class UnitTestCase < ActiveSupport::TestCase
    extend LoadFixtures
    include ProjectCreator
    include Redmine::I18n
    include ProjectTypeCreator
    include PrepareSpreadsheet
    include PrepareDataTable

    fixtures :projects, :projects_table_configs,
             :members, :member_roles, :roles, :users,
             :table_configs, :spreadsheets, :spreadsheet_rows,
             :calculation_configs
  end
end
