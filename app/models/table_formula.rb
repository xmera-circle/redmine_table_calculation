# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
#
# Copyright (C) 2021 - 2022 Liane Hampe <liaham@xmera.de>, xmera.
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

  ##
  # @params values Array(String|Integer)
  # @params operation TableFormula.operators.key
  #
  def initialize(operation, values)
    @operation = operation
    @values = values
  end

  ##
  # If String values are given, they will be casted to Integer.
  # Strings bearing other characters than numbers will turn to 0.
  #
  def exec
    return '-' unless valid? operation

    values&.map(&:to_i)&.send(operation)
  end

  private

  attr_reader :operation, :values

  def valid?(operation)
    self.class.operators.keys.include? operation.to_sym
  end
end
