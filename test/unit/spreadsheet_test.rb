# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
#
# Copyright (C) 2021 - 2022 Liane Hampe <liaham@xmera.de>, xmera.
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
  class SpreadsheetTest < ActiveSupport::TestCase
    extend TableCalculation::LoadFixtures
    include TableCalculation::ProjectTypeCreator

    fixtures :projects,
             :members, :member_roles, :roles, :users,
             :tables, :spreadsheets

    test 'should respond to safe attributes' do
      assert Spreadsheet.respond_to? :safe_attributes
    end

    test 'should respond to column_ids' do
      assert Spreadsheet.find(1).respond_to? :column_ids
    end

    test 'should respond to calculations' do
      assert Spreadsheet.find(1).respond_to? :calculations?
    end

    test 'should respond to copy' do
      assert Spreadsheet.find(1).respond_to? :copy
    end

    test 'spreadsheet should not be valid without name' do
      sheet = Spreadsheet.new(table_id: Table.find(1).id)
      assert_not sheet.valid?
      assert_equal %i[name], sheet.errors.keys
    end

    test 'spreadsheet should not be valid without table' do
      sheet = Spreadsheet.new(name: 'New Sheet')
      assert_not sheet.valid?
      assert_equal %i[table_id], sheet.errors.keys
    end
  end
end
