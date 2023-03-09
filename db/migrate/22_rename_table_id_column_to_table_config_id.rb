# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
#
# Copyright (C) 2023 Liane Hampe <liaham@xmera.de>, xmera Solutions GmbH.
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

class RenameTableIdColumnToTableConfigId < ActiveRecord::Migration[5.2]
  def change
    rename_column :calculation_configs, :table_id, :table_config_id
    rename_column :projects_table_configs, :table_id, :table_config_id
    rename_column :custom_fields_table_configs, :table_id, :table_config_id
    rename_column :spreadsheets, :table_id, :table_config_id
  end
end
