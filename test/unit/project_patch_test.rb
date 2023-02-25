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
  class ProjectPatchTest < UnitTestCase
    include PrepareSpreadsheet
    include ProjectCreator
    include Redmine::I18n

    fixtures :projects, :table_configs, :spreadsheets, :projects_table_configs, :spreadsheet_rows

    def setup
      find_project_type(id: 4)
      project(id: 1, type: 4)
    end

    test 'should have spreadsheets' do
      project1 = project(id: 1, type: 4)
      project_type = find_project_type(id: 4)
      assert_equal 1, project1.spreadsheets.count
      assert_equal 1, project_type.spreadsheets.count
    end

    test 'should have table_configs' do
      project1 = project(id: 1, type: 4)
      assert_equal 1, project1.project_type.table_configs.count
      assert_equal 1, find_project_type(id: 4).table_configs.count
    end

    test 'should respond to project_type_assigned?' do
      assert TableConfig.find(1).respond_to? :project_type_assigned?
    end

    test 'table should not be valid without name' do
      table_config = TableConfig.new
      assert_not table_config.valid?
      assert_equal [:name], table_config.errors.keys
    end

    test 'should copy spreadsheets from project' do
      source_project = Project.find(4)
      spreadsheet = source_project.spreadsheets.first
      optional_field = TableCustomField.generate!(name: 'Description')
      add_spreadsheet_field(spreadsheet, optional_field)
      add_content_to_spreadsheet(spreadsheet, optional_field)
      new_project = Project.copy_from(source_project)
      save_project(new_project)
      new_project = Project.last
      new_project.copy(source_project)
      assert_equal 1, new_project.spreadsheets.to_a.count
      assert_equal 1, source_project.spreadsheets.to_a.count
      assert new_project.spreadsheets.to_a.map(&:project_id).include? new_project.id
      assert_equal 2, new_project.spreadsheets.first.rows.to_a.count
    end

    test 'should copy spreadsheets from project type master' do
      project_type_master = ProjectType.find(4)
      spreadsheet = project_type_master.spreadsheets.first
      optional_field = TableCustomField.generate!(name: 'Description')
      add_spreadsheet_field(spreadsheet, optional_field)
      add_content_to_spreadsheet(spreadsheet, optional_field)
      new_project = Project.copy_from(project_type_master)
      save_project(new_project)
      new_project = Project.last
      new_project.copy(project_type_master)
      assert_equal 1, new_project.spreadsheets.to_a.count
      assert_equal 1, project_type_master.spreadsheets.to_a.count
      assert new_project.spreadsheets.to_a.map(&:project_id).include? new_project.id
      assert_equal 2, new_project.spreadsheets.first.rows.to_a.count
    end

    test 'should raise an exception when copying spreadsheets with existing rows and required fields' do
      ## Refers to issue #1358 where existing rows are extended with a
      # required field afterwards
      project_type_master = ProjectType.find(4)
      spreadsheet = project_type_master.spreadsheets.first
      optional_field = TableCustomField.generate!(name: 'Description')
      add_spreadsheet_field(spreadsheet, optional_field)
      add_content_to_spreadsheet(spreadsheet, optional_field)
      required_field = TableCustomField.generate!(name: 'Count', field_format: 'int', is_required: 1)
      add_spreadsheet_field(spreadsheet, required_field)
      new_project = Project.copy_from(project_type_master)
      save_project(new_project)
      new_project = Project.last
      assert_raise(ActiveModel::ValidationError,
                   l(:error_records_with_required_field_could_not_be_saved, project_type_master.name)) do
        new_project.copy(project_type_master)
      end
    end
  end
end
