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

class CreateSpreadsheetRows < ActiveRecord::Migration[4.2]
  def self.up
    return if table_exists?(:spreadsheet_rows)

    create_table :spreadsheet_rows do |t|
      t.integer :spreadsheet_id
      t.integer :position
      t.timestamp :created_on
      t.timestamp :updated_on
    end
    add_index :spreadsheet_rows,
              %i[spreadsheet_id],
              name: :rows_by_spreadsheet
  end

  def self.down
    drop_table :spreadsheet_rows if table_exists?(:spreadsheet_rows)
  end
end
