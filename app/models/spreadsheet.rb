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

class Spreadsheet < ActiveRecord::Base
  include Redmine::SafeAttributes
  include RedmineTableCalculation::Copyable
  include RedmineTableCalculation::Sortable

  belongs_to :project, inverse_of: :spreadsheets
  belongs_to :table_config, inverse_of: :spreadsheets
  belongs_to :author, class_name: 'User'
  has_many :rows, -> { order(:position) }, class_name: 'SpreadsheetRow', inverse_of: :spreadsheet, dependent: :destroy

  validates :name, uniqueness: { scope: :project_id }
  validates :name, presence: true
  # table_config will only be required when validated this way!
  validates :table_config_id, presence: true

  safe_attributes(
    :name,
    :description,
    :table_config_id,
    :project_id,
    :author_id
  )

  # is used in project in order to get easily a data table
  def data_table
    DataTable.new(spreadsheet: self)
  end

  delegate :column_ids, to: :secure_table

  def calculation_configs?
    secure_table.calculation_configs.present?
  end

  def copy(attributes = nil)
    attributes ||= {}
    attributes.merge(table_config: table_config)
    copied = super(attributes)
    copied.save
    copied.rows << copy_rows
    copied.copy_row_values(self)
    copied
  end

  private

  def attributes_to_ignore
    %w[id project_id created_on updated_on]
  end

  def copy_rows(attributes = {})
    sorted_rows.map do |row|
      row.copy(attributes)
    end
  end

  def secure_table
    table_config || NullTableConfig.new
  end

  protected

  def copy_row_values(spreadsheet)
    all_row_values = spreadsheet.copied_row_values
    return unless all_row_values.any?(&:present?)

    sorted_rows.zip(all_row_values).each do |row, row_values|
      row.assign_values(row_values)
    end
  end

  def copied_row_values
    sorted_rows.map(&:copy_values)
  end

  ##
  # Rows needs to be sorted this way to avoid to copy them
  # unsorted.
  # @note There was an attempt to sort the rows in the association above
  #       but that leads to side effects and ends in an exception.
  #
  def sorted_rows
    sorted_by_id(rows)
  end
end
