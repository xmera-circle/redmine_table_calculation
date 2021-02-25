class Spreadsheet < ActiveRecord::Base
  include Redmine::SafeAttributes 

  belongs_to :project
  belongs_to :table
  belongs_to :author, :class_name => 'User'
  has_many :rows, class_name: 'SpreadsheetRow', dependent: :destroy
  has_many :row_results, class_name: 'SpreadsheetRowResult', dependent: :destroy

  safe_attributes(
    :name,
    :description,
    :table_id,
    :project_id,
    :author_id,
    :row_ids
  )

  def column_ids
    table.column_ids
  end
end