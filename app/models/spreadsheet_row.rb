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

class SpreadsheetRow < ActiveRecord::Base
  include Redmine::SafeAttributes
  acts_as_customizable type_class: :table

  belongs_to :spreadsheet

  after_destroy :destroy_row_values

  safe_attributes(
    :position,
    :spreadsheet_id,
    :custom_fields,
    :custom_field_values
  )

  def available_custom_fields
    CustomField.where(id: column_ids).sorted.to_a
  end

  private

  ##
  # TODO: delegate to table
  #
  def column_ids
    spreadsheet.table.column_ids
  end

  def destroy_row_values
    CustomValue.where(customized_id: id).delete_all
  end
end
