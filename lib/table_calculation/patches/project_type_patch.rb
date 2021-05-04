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
  module Patches
    module ProjectTypePatch
      def self.included(base)
        base.class_eval do
          has_many :spreadsheets, foreign_key: :project_id, dependent: :destroy
          # has_many :projects_tables, foreign_key: :project_id
          # has_many :tables, through: :projects_tables
          has_and_belongs_to_many :tables,
                                  join_table: "#{table_name_prefix}projects_tables#{table_name_suffix}",
                                  foreign_key: 'project_id',
                                  association_foreign_key: 'table_id'
        end
      end
    end
  end
end

# Apply patch
Rails.configuration.to_prepare do
  unless ProjectType.included_modules.include?(TableCalculation::Patches::ProjectTypePatch)
    ProjectType.include TableCalculation::Patches::ProjectTypePatch
  end
end
