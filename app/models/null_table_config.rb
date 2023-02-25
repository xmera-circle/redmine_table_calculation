# frozen_string_literal: true

class NullTableConfig
  def columns
    []
  end

  def column_ids
    []
  end

  def name
    '-'
  end

  def calculation_configs
    CalculationConfig.none
  end
end
