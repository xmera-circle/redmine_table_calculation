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

class TableConfig < ActiveRecord::Base
  include Redmine::SafeAttributes
  has_many :spreadsheets, inverse_of: :table_config

  has_and_belongs_to_many :columns,
                          -> { order(:position) },
                          class_name: 'TableCustomField',
                          join_table: "#{table_name_prefix}custom_fields_table_configs#{table_name_suffix}",
                          association_foreign_key: 'custom_field_id'

  has_and_belongs_to_many :project_types, -> { where(is_project_type: true) },
                          class_name: 'Project',
                          join_table: "#{table_name_prefix}projects_table_configs#{table_name_suffix}",
                          foreign_key: 'table_config_id',
                          association_foreign_key: 'project_id'

  has_many :calculation_configs, dependent: :destroy, inverse_of: :table_config

  after_commit :enable_table_calculation_module

  validates :name, presence: true
  validates :name, uniqueness: true

  safe_attributes(
    :name,
    :description,
    :column_ids,
    :project_type_ids
  )

  def column_assigned?(id)
    column_ids.include? id.to_i
  end

  def project_type_assigned?(id)
    project_type_ids.include? id.to_i
  end

  private

  def enable_table_calculation_module
    project_types.each do |project_type|
      next if project_type.module_enabled?(:table_calculation)

      project_type.enable_module!(:table_calculation)
    end
  end
end
