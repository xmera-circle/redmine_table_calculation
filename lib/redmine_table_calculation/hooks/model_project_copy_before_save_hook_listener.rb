# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculation.
#
# Copyright (C) 2021 - 2022 Liane Hampe <liaham@xmera.de>, xmera.
#
# This program is free software; you can redistribute it and/or
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

module RedmineTableCalculation
  module Hooks
    class ModelProjectCopyBeforeSaveHookListener < Redmine::Hook::ViewListener
      include ActiveModel::Validations
      include Redmine::I18n

      ##
      # Uses the call hook in Project#copy in order to copy spreadsheets as well.
      #
      # @note There is an edge case where copying spreadsheets will fail (Circle #1358):
      #  The error occurs only if
      #   - an existing table has already some entries,
      #   - the table will be extended by a further field,
      #   - the field is required,
      #   - the table will be copied into another object.
      # Copied tables will be newly created in the target object.
      # When doing so, each table row which is given in the source object will be
      # created in the target object. Bevor this new table row is saved it will be
      # valdiated what fails when the record given by the source object has no
      # value in the required field since it was added after the spreadsheet row
      # was created.
      #
      # The rescue block will handle the edge case above.
      # To make it work Project#copy and ProjectsController#create,
      # ProjectsController#copy will handle the exception as well.
      #
      def model_project_copy_before_save(context = {})
        source = context[:source_project]
        destination = context[:destination_project]
        selection = context[:selection]
        destination.copy_spreadsheets(source) if copy?(selection)
      rescue ActiveRecord::RecordNotSaved
        error_message = l(:error_records_with_required_field_could_not_be_saved, source.name)
        source.errors.add(:base, error_message)
        raise ActiveModel::ValidationError, source
      end

      def copy?(selection)
        return true unless selection

        selection&.include?('spreadsheets')
      end
    end
  end
end
