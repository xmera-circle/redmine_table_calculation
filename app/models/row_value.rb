class RowValue
  attr_accessor :value, :row, :col

  ##
  # @param value [String] The custom value.
  # @param row   [SpreadsheetRow|SpreadsheetRowResult] The row object of the spreadsheet.
  # @param col   [CustomField] The column object corresponding to the custom value.
  #
  def initialize(value:, row: nil, col: nil)
    @value = value
    @row = row
    @col = col
  end

  def row_id
    row.nil? ? row : row.id
  end

  def value?
    value.present?
  end
end