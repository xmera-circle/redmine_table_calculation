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

class Calculation < ActiveRecord::Base
  include Redmine::SafeAttributes

  belongs_to :table

  has_and_belongs_to_many :fields,
                          -> { order(:position) },
                          class_name: 'TableCustomField',
                          join_table: "#{table_name_prefix}custom_fields_calculations#{table_name_suffix}",
                          association_foreign_key: 'custom_field_id'

  validates_presence_of :name, :formula, :field_ids
  validates_uniqueness_of :name
  validate :validate_table_presence
  validate :validate_fields
  validate :validate_columns_and_rows

  scope :inheritables, -> { where(inheritable: true) }

  safe_attributes(
    :name,
    :description,
    :table_id,
    :formula,
    :field_ids,
    :columns,
    :rows,
    :inheritable
  )
  
  def field?(id)
    field_ids.include?(id)
  end

  def column_ids
    field_ids
  end

  def locale_formula
    Formula.operators[formula.to_sym]
  end

  private

  def validate_table_presence
    errors.add :table, l(:error_table_id_not_present) unless table_id&.positive?
  end

  def validate_fields
    return unless table_id&.positive?

    errors.add :fields, l(:error_field_ids_invalid) unless field_ids_belong_to?(table)
    errors.add :fields, l(:error_field_ids_doubled) unless field_ids_unique?
  end

  def field_ids_belong_to?(table)
    (field_ids - table.column_ids).empty?
  end

  def field_ids_unique?
    (field_ids - field_ids.uniq).empty?
  end

  def validate_columns_and_rows
    # both are true
    errors.add :columns_and_rows, l(:error_columns_and_rows_selected) if columns && rows
    # both are false
    errors.add :columns_and_rows, l(:error_columns_and_rows_unselected) if !columns && !rows
  end
end
