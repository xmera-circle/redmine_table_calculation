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

module TableCalculation
  module Extensions
    module ProjectPatch
      def self.included(base)
        base.include(InstanceMethods)
        base.class_eval do
          has_many :spreadsheets, dependent: :destroy
          has_many :projects_tables, foreign_key: :project_id
          has_many :tables, through: :projects_tables, source: :table
        end
      end

      module InstanceMethods
        ##
        # Copy all spreadsheets from the source project.
        #
        def copy_spreadsheets(source_project)
          source_project.spreadsheets.each do |spreadsheet|
            attrs_to_ignore = %w[id project_id created_on updated_on]
            new_spreadsheet = Spreadsheet.new
            new_spreadsheet.attributes =
              spreadsheet.attributes.dup.except(*attrs_to_ignore)
            row_attrs = { spreadsheet_id: new_spreadsheet.id }
            new_spreadsheet.rows = spreadsheet.copy_rows(row_attrs)
            spreadsheets << new_spreadsheet
            new_spreadsheet.rows.each do |row|
              row.custom_field_values = spreadsheet.copy_row_values
              row.save
            end
          end
        end
      end
    end
  end
end

# Apply patch
Rails.configuration.to_prepare do
  unless Project.included_modules.include?(TableCalculation::Extensions::ProjectPatch)
    Project.include TableCalculation::Extensions::ProjectPatch
  end
end
