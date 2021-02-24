class Formula
  class_attribute :operators
  self.operators = {
    max: :label_max,
    min: :label_min,
    sum: :label_sum
  }

  def initialize(operation, values)
    @operation = operation
    @values = values
  end

  def exec
    return '-' unless valid? operation

    values.map(&:to_i).send(operation)    
  end

  private

  attr_reader :operation, :values

  def valid?(operation)
    self.class.operators.keys.include? operation.to_sym
  end
end