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

class CreateCalculations < ActiveRecord::Migration[4.2]
  def self.up
    unless table_exists?(:calculations)
      create_table :calculations do |t|
        t.string :name, limit: 60, default: '', null: false
        t.text :description
        t.integer :table_id, default: 0, null: false
        t.string :formula, limit: 30, default: '', null: false
        t.boolean :columns, default: false, null: false
        t.boolean :rows, default: false, null: false
        t.timestamp :created_on
        t.timestamp :updated_on
      end

      add_index :calculations, %i[table_id], name: 'calculation_by_table'
    end
  end

  def self.down
    drop_table :calculations if table_exists?(:calculations) && table_exists?(:calculations)
  end
end
