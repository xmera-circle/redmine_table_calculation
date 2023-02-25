# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation Inheritance.
#
# Copyright (C) 2020-2023 Liane Hampe <liaham@xmera.de>, xmera Solutions GmbH.
#
# This program is free software; you can redistribute it and/or
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

module RedmineTableCalculation
  module TestObjectCreators
    def TableConfig.generate!(attributes = {})
      @generated_table_config_name ||= +'Table Config 0'
      @generated_table_config_name.succ!
      table_config = new(attributes)
      table_config.name = @generated_table_config_name.dup if table_config.name.blank?
      table_config.description = 'A test table config' if table_config.description.blank?
      yield table_config if block_given?
      table_config.save!
      table_config
    end

    def Spreadsheet.generate!(attributes = {})
      @generated_spreadsheet_name ||= +'Spreadsheet 0'
      @generated_spreadsheet_name.succ!
      sheet = new(attributes)
      sheet.name = @generated_spreadsheet_name.dup if sheet.name.blank?
      sheet.description = 'A test spreadsheet' if sheet.description.blank?
      yield sheet if block_given?
      sheet.save!
      sheet
    end
  end
end
