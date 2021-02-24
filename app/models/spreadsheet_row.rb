class SpreadsheetRow < ActiveRecord::Base
  include Redmine::SafeAttributes
  acts_as_customizable type_class: :table

  belongs_to :spreadsheet
  
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
end