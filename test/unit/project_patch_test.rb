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
  class ProjectPatchTest < ActiveSupport::TestCase
    extend TableCalculation::LoadFixtures
    include TableCalculation::ProjectTypeCreator

    fixtures :tables, :projects, :spreadsheets

    def setup
      project_type = find_project_type(id: 4)
      project_type.tables << Table.find(2)
      project_type.spreadsheets << Spreadsheet.find(2)

      project(id: 1, type: 4)
    end

    test 'should have spreadsheets' do
      project1 = project(id: 1, type: 4)
      project_type = find_project_type(id: 4)
      assert_equal 1, project1.spreadsheets.count
      assert_equal 1, project_type.spreadsheets.count
    end

    test 'should have tables' do
      project1 = project(id: 1, type: 4)
      assert_equal 1, project1.project_type.tables.count
      assert_equal 1, find_project_type(id: 4).tables.count
    end

    test 'should respond to project_type_assigned?' do
      assert Table.find(1).respond_to? :project_type_assigned?
    end

    test 'table should not be valid without name' do
      table = Table.new
      assert_not table.valid?
      assert_equal [:name], table.errors.keys
    end

    test 'should copy spreadsheets from project' do
    skip
      source_project = Project.find(4)
      new_project = Project.copy_from(source_project)
      save_project(new_project)
      new_project = Project.last
      assert_equal 1, new_project.spreadsheets.to_a.count
      assert_equal 1, source_project.spreadsheets.to_a.count
      assert new_project.spreadsheets.to_a.map(&:project_id).include? new_project.id
    end

    test 'should copy spreadsheets from project type master' do
    skip
      project_type_master = ProjectType.find(4)
      new_project = Project.copy_from(project_type_master)
      save_project(new_project)
      new_project = Project.last
      assert_equal 1, new_project.spreadsheets.to_a.count
      assert_equal 1, project_type_master.spreadsheets.to_a.count
      assert new_project.spreadsheets.to_a.map(&:project_id).include? new_project.id
    end

    private

    def project(id: , type: )
      project = Project.find(id.to_i)
      project.project_type_id = type
      project.save
      project
    end

    def save_project(project)
      project.identifier ||= 'new-project'
      project.name ||= 'New Project'
      project.save
    end
  end
end
