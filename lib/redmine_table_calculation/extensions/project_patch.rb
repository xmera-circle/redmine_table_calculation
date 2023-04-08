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

module RedmineTableCalculation
  module Extensions
    module ProjectPatch
      def self.included(base)
        base.include(InstanceMethods)
        base.class_eval do
          has_many :spreadsheets, foreign_key: :project_id, dependent: :destroy
          has_many :projects_table_configs, foreign_key: :project_id
          has_many :table_configs, through: :projects_table_configs, source: :table_config
        end
      end

      module InstanceMethods
        ##
        # Copy all spreadsheets from the source project with its rows and
        # row values.
        #
        def copy_spreadsheets(source_project)
          self.spreadsheets = source_project.spreadsheets.map(&:copy)
        end
      end
    end
  end
end
