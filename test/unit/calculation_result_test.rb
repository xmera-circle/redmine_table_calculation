# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
#
# Copyright (C) 2021 Liane Hampe <liaham@xmera.de>, xmera.
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

require File.expand_path('../test_helper', __dir__)

module TableCaclulation
  class CalculationResultTest < ActiveSupport::TestCase

    test 'should have many custom values' do
      association = CalculationResult.reflect_on_association(:custom_values)
      assert_equal :custom_values, association.name
      assert_equal :has_many, association.macro
    end

    test 'should respond to safe attributes' do
      assert CalculationResult.respond_to? :safe_attributes
    end

    test 'should find TableCustomField instances' do
      custom_field
      assert CalculationResult.new.available_custom_fields.count == 1
    end

    private

    def custom_field
      CustomField.generate! custom_field_attributes(name: 'CF')
    end

    def custom_field_attributes(name:)
      { name: name,
        regexp: '',
        is_for_all: true,
        is_filter: true,
        type: 'TableCustomField',
        possible_values: %w[A B C],
        is_required: false,
        field_format: 'list',
        default_value: '',
        editable: true }
    end
    
  end
end
