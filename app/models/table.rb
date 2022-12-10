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

class Table < ActiveRecord::Base
  include Redmine::SafeAttributes
  has_many :spreadsheets, inverse_of: :table

  has_and_belongs_to_many :columns,
                          -> { order(:position) },
                          class_name: 'TableCustomField',
                          join_table: "#{table_name_prefix}custom_fields_tables#{table_name_suffix}",
                          association_foreign_key: 'custom_field_id'

  has_and_belongs_to_many :project_types, -> { where(is_project_type: true) },
                          class_name: 'Project',
                          join_table: "#{table_name_prefix}projects_tables#{table_name_suffix}",
                          foreign_key: 'table_id',
                          association_foreign_key: 'project_id'

  has_many :calculations, dependent: :destroy, inverse_of: :table

  validates :name, presence: true
  validates :name, uniqueness: true

  safe_attributes(
    :name,
    :description,
    :column_ids,
    :project_type_ids
  )

  def column_assigned?(id)
    columns.to_a.map(&:id).include? id.to_i
  end

  def project_type_assigned?(id)
    project_types.to_a.map(&:id).include? id.to_i
  end
end
