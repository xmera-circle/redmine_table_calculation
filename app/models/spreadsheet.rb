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

class Spreadsheet < ActiveRecord::Base
  include Redmine::SafeAttributes
  include TableCalculation::Copyable
  include TableCalculation::Sortable

  belongs_to :project, foreign_key: :project_id, inverse_of: :spreadsheets
  belongs_to :table, inverse_of: :spreadsheets
  belongs_to :author, class_name: 'User'
  has_many :rows, class_name: 'SpreadsheetRow', dependent: :destroy

  validates_uniqueness_of :name, scope: :project_id
  validates_presence_of :name, :table_id

  safe_attributes(
    :name,
    :description,
    :table_id,
    :project_id,
    :author_id
  )

  def column_ids
    secure_table.column_ids
  end

  def calculations?
    secure_table.calculations.present?
  end

  def copy(attributes = nil)
    copy = super(attributes)
    row_attributes = { spreadsheet_id: copy.id }
    copy.rows = copy_rows(row_attributes)
    copy.copy_row_values(self)
    copy
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
    table || NullTable.new
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
