class Formula
  class_attribute :operators
  self.operators = {
    max: :label_max,
    min: :label_min,
    sum: :label_sum
  }

  def initialize(values, operation)
    @values = values
    @operation = operation
  end

  def exec
    operation.exec(values)
  end

  private
  attr_reader :operation, :values
end