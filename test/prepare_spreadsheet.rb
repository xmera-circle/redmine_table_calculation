# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
#
# Copyright (C) 2022 Liane Hampe <liaham@xmera.de>, xmera.
#
# This program is free software; you can redistribute it and/or
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

module TableCalculation
  ##
  # Some spreadsheets needs special configuration
  #
  module PrepareSpreadsheet
    def add_spreadsheet_field(spreadsheet, field)
      spreadsheet.table.columns << field
    end

    ##
    # @param spreadsheet [Spreadsheet] A spreadsheet instance having at least one row.
    # @param field [TableCustomField] A table custom field accepting text as value.
    #
    def add_content_to_spreadsheet(spreadsheet, field)
      row = spreadsheet.rows.first
      row.custom_field_values = { field.id => "Content for #{field.id}" }
      row.save!
    end
  end
end
