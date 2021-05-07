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

class Spreadsheet < ActiveRecord::Base
  include Redmine::SafeAttributes

  belongs_to :project, foreign_key: :project_id, inverse_of: :spreadsheets
  belongs_to :table, inverse_of: :spreadsheets
  belongs_to :author, class_name: 'User'
  has_many :rows, class_name: 'SpreadsheetRow', dependent: :destroy

  validates_uniqueness_of :name, scope: :project_id

  safe_attributes(
    :name,
    :description,
    :table_id,
    :project_id,
    :author_id
  )

  def column_ids
    table.column_ids
  end

  def calculations?
    table.calculations.present?
  end

  def copy_rows(attributes = {})
    rows.map do |row|
      row.copy(attributes)
    end
  end

  def copy_row_values
    Hash(rows.map(&:copy_values).first)
  end
end
