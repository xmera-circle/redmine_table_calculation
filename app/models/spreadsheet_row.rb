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

class SpreadsheetRow < ActiveRecord::Base
  include Redmine::SafeAttributes
  include RedmineTableCalculation::Copyable
  acts_as_customizable type_class: :table

  belongs_to :spreadsheet, inverse_of: :rows, touch: true

  after_destroy :destroy_row_values

  safe_attributes(
    :position,
    :spreadsheet_id,
    :custom_fields,
    :custom_field_values
  )

  def initialize(attributes = nil, *_args)
    table_config = attributes.delete(:table_config)
    super attributes
    @table_config = table_config
  end

  # overrides Redmine::Acts::Customizable#available_custom_fields
  def available_custom_fields
    CustomField.where(id: column_ids).sorted.to_a
  end

  ##
  # Copy the custom_field_values of each row as it is.
  #
  # @return [Hash(id, value)] A hash where the key is the custom field id and
  #   the value the custom field value.
  #
  def copy_values
    custom_field_values.each_with_object({}) do |origin, copies|
      copies[origin.custom_field_id] = origin.value
      copies
    end
  end

  ##
  # Assigns explicitly values and saves them. This method is used during
  # the copy process of Spreadsheet#copy.
  #
  def assign_values(values)
    self.custom_field_values = values
    # skip validations to allow rows with empty required custom fields!
    save(validate: false)
  end

  ##
  # Is required by ApplicationHelper#format_object in order to render
  # 'CustomValue' and 'CustomFieldValue' according to their format.
  #
  def visible?
    true
  end

  private

  ##
  # Needed for SpreadsheetRow#copy
  #
  def attributes_to_ignore
    %w[id spreadsheet_id created_on updated_on]
  end

  delegate :column_ids, to: :table_config, allow_nil: true

  def table_config
    @table_config ||= spreadsheet&.table_config
  end

  def destroy_row_values
    CustomValue.where(customized_id: id).delete_all
  end
end
