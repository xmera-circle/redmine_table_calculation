# frozen_string_literal: true

class NullTable
  def columns
    []
  end

  def column_ids
    []
  end

  def name
    '-'
  end

  def calculations
    Calculation.none
  end
end
