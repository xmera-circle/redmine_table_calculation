# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
#
# Copyright (C) 2020-2023 Liane Hampe <liaham@xmera.de>, xmera Solutions GmbH.
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
# Calculates over given values, i.e. Arrays.
#
class TableFormula
  class_attribute :operators
  self.operators = {
    max: :label_max,
    min: :label_min,
    sum: :label_sum
  }

  # @param operation [Symbol] An element of TableFormula.operators.key.
  # @param values [Array(Integer, Float)] Values on which the operation should
  #                                       be executed.
  #
  def initialize(operation, values)
    @operation = operation
    # remove nil values in case of SpareTableCell objects included
    @values = values&.compact
  end

  # Check whether the operation is registered and
  # whether values given at all.
  def exec
    return '-' unless valid?(operation)
    return '-' if values.blank?

    values&.send(operation)
  end

  private

  attr_reader :operation, :values

  def valid?(operation)
    self.class.operators.key?(operation.to_sym)
  end
end
