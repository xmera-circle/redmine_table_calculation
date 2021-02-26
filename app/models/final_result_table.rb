# frozen_string_literal: true

class FinalResultTable < MembersResultTable
  include Redmine::I18n
  attr_reader :spreadsheet, :comment_field_name

  def initialize(members, spreadsheet)
    super(members, spreadsheet)
    @spreadsheet = spreadsheet
    @comment_field_name = Struct.new(:name)
  end

  def result_table_row(operation, column_id, calculation)
    result(calculation.id, column_id) || result_value(operation, column_id, calculation)
  end

  def columns
    self.instance_variable_get('@columns').append(comment_field)
  end

  private

  def extend_result_row(results, calculation)
    extended = super(results, calculation)
    extended.append(comment_value(calculation))
  end

  def comment_field
    comment_field_name.new(l(:field_comment))
  end

  def comment_value(calculation)
    spreadsheet_result_row(calculation.id)&.comment
  end

  def result(calculation_id, column_id)
    spreadsheet_result_row(calculation_id)&.custom_value_for(column_id)
  end

  def spreadsheet_result_row(calculation_id)
    SpreadsheetRowResult.find_by(calculation_id: calculation_id,
                                 spreadsheet_id: spreadsheet.id)
  end

end
