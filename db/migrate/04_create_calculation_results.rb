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

class CreateCalculationResults < ActiveRecord::Migration[4.2]
  def self.up
    return if table_exists?(:calculation_results)

    create_table :calculation_results do |t|
      t.string :type, limit: 30, default: '', null: false
      t.string :name, limit: 60, default: '', null: false
      t.integer :calculation_id, default: 0, null: false
      t.text :comment
      t.timestamp :created_on
      t.timestamp :updated_on
    end

    add_index :calculation_results, %i[calculation_id], name: 'calculation_results_by_calculation'
    add_index :calculation_results, %i[type calculation_id], name: 'calculation_results_by_calculation_and_type'
  end

  def self.down
    drop_table :calculation_results if table_exists?(:calculation_results)
  end
end
