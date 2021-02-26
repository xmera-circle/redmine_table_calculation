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

##
# A final result is potentially a adjusted member result with a 
# comment about the taken adjustement but does not need to be.
# If not it is the same as the member result.
#
class FinalResultTable < MembersResultTable
  include Redmine::I18n
  attr_reader :spreadsheet, :row, :comment_field_name

  def initialize(members, spreadsheet)
    super(members, spreadsheet)
    @spreadsheet = spreadsheet
    @comment_field_name = Struct.new(:name)
  end

  def result_table_row(operation, column_id, calculation)
    return result(calculation.id, column_id) if result(calculation.id, column_id).value

    result_value(operation, column_id, calculation)
  end

  def columns
    return if self.instance_variable_get('@columns').include? comment_field

    self.instance_variable_get('@columns').append(comment_field)
  end

  private

  attr_writer :row

  def extend_result_row(results, calculation)
    extended = super(results, calculation)
    extended.append(comment_value(calculation))
    extended
  end

  def comment_field
    comment_field_name.new(l(:field_comment))
  end

  def comment_value(calculation)
    RowValue.new(value: row&.comment, row: row&.id)
  end

  def result(calculation_id, column_id)
    @row = spreadsheet_result_row(calculation_id)
    RowValue.new(value: row&.custom_value_for(column_id)&.value, row: row&.id)
  end

  def spreadsheet_result_row(calculation_id)
    SpreadsheetRowResult.find_by(calculation_id: calculation_id,
                                 spreadsheet_id: spreadsheet.id)
  end

end
