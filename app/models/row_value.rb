class RowValue
  attr_accessor :value, :row

  def initialize(value:, row: nil)
    @value = value
    @row = row
  end

  def value?
    value.present?
  end
end