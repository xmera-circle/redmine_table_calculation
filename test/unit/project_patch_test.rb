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
      add_column_to_table_config(object: spreadsheet, column: optional_field)
      add_content_to_spreadsheet(object: spreadsheet, column: optional_field, row_index: 1)
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
      add_column_to_table_config(object: spreadsheet, column: optional_field)
      add_content_to_spreadsheet(object: spreadsheet, column: optional_field, row_index: 1)
      new_project = Project.copy_from(project_type_master)
      save_project(new_project)
      new_project = Project.last
      new_project.copy(project_type_master)
      assert_equal 1, new_project.spreadsheets.to_a.count
      assert_equal 1, project_type_master.spreadsheets.to_a.count
      assert new_project.spreadsheets.to_a.map(&:project_id).include? new_project.id
      assert_equal 2, new_project.spreadsheets.first.rows.to_a.count
    end

    test 'should copy spreadsheets with existing rows and required fields' do
      ## Refers to issue #1358 on circle.xmera.de where existing rows are extended with a
      # required field afterwards
      project_type_master = ProjectType.find(4)

      # Creates a spreadsheet with two columns and one row
      # where the required column is added after the first row exists
      spreadsheet = project_type_master.spreadsheets.first # spreadsheet id: 2
      optional_field = TableCustomField.generate!(name: 'Description')
      add_column_to_table_config(object: spreadsheet, column: optional_field)
      content = 'Book'
      add_content_to_spreadsheet(object: spreadsheet,
                                 column: optional_field,
                                 content: content,
                                 row_index: 1)
      required_field = TableCustomField.generate!(name: 'Count', field_format: 'int', is_required: 1)
      add_column_to_table_config(object: spreadsheet, column: required_field)

      # Copy the spreadsheet to a new project
      new_project = Project.copy_from(project_type_master)
      save_project(new_project)
      new_project = Project.last
      new_project.copy(project_type_master)

      # Check the new spreadsheet
      rows = new_project.spreadsheets.first.rows
      assert_equal 2, rows.count
      custom_field_values = rows.map(&:custom_field_values).flatten
      custom_fields = custom_field_values.map(&:custom_field).uniq
      assert_equal %w[Description Count], custom_fields.map(&:name)
      assert_equal content, custom_field_values.map(&:value).first
      required_field = custom_fields.map(&:is_required).last
      assert required_field
    end
  end
end
