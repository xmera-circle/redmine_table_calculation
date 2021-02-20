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

class CreateCustomFieldsTables < ActiveRecord::Migration[4.2]
  def self.up
    create_table :custom_fields_tables, id: false do |t|
      t.column :custom_field_id, :integer, default: 0, null: false
      t.column :table_id, :integer, default: 0, null: false
    end
    add_index :custom_fields_tables,
              %i[table_id],
              name: :custom_fields_by_table
  end

  def self.down
    drop_table :custom_fields_tables
  end
end