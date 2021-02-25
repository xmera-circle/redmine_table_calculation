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

module SpreadsheetsHelper
  def render_adapted_result_table()

  end

  def render_aggregated_result_table(members, spreadsheet)
    render partial: 'calculation_results',
           locals: { table: AggregatedResultTable.new(members, spreadsheet) }
  end

  def render_spreadsheet_result_table(spreadsheet)
    render partial: 'calculation_results',
           locals: { table: ResultTable.new(spreadsheet) }
  end

  def render_spreadsheet_table(spreadsheet)
    render partial: 'table',
           locals: { table: ResultTable.new(spreadsheet) }
  end

  def spreadsheet_of(member)
    member.spreadsheets.find_by(name: @spreadsheet.name)
  end

  def value(operation, column_values)
    Formula.new(operation, column_values).exec
  end
end