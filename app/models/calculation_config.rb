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

class CalculationConfig < ActiveRecord::Base
  include Redmine::SafeAttributes

  belongs_to :table_config, inverse_of: :calculation_configs

  has_and_belongs_to_many :columns,
                          -> { order(:position) },
                          class_name: 'TableCustomField',
                          join_table: "#{table_name_prefix}custom_fields_calculation_configs#{table_name_suffix}",
                          association_foreign_key: 'custom_field_id'

  validates :name, :formula, :column_ids, presence: true
  validate :validate_table_config_presence
  validate :validate_columns

  scope :inheritables, -> { where(inheritable: true) }

  safe_attributes(
    :name,
    :description,
    :table_config_id,
    :formula,
    :column_ids,
    :inheritable
  )

  def column?(id)
    column_ids.include?(id)
  end

  def locale_formula
    TableFormula.operators[formula.to_sym]
  end

  def inheritable?
    inheritable
  end

  private

  def validate_table_config_presence
    errors.add :table_config, l(:error_table_config_id_not_present) unless table_config_id&.positive?
  end

  def validate_columns
    return unless table_config_id&.positive?

    errors.add :columns, l(:error_column_ids_invalid) unless column_ids_belong_to?(table_config)
    errors.add :columns, l(:error_column_ids_doubled) unless column_ids_unique?
  end

  def column_ids_belong_to?(table_config)
    (column_ids - table_config.column_ids).empty?
  end

  def column_ids_unique?
    (column_ids - column_ids.uniq).empty?
  end
end
