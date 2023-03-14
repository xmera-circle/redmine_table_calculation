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

# Extensions
require_relative 'redmine_table_calculation/extensions/project_patch'

# Hooks
require_relative 'redmine_table_calculation/hooks/view_layouts_base_html_head_hook_listener'
require_relative 'redmine_table_calculation/hooks/model_project_copy_before_save_hook_listener'
require_relative 'redmine_table_calculation/hooks/view_projects_copy_only_items_hook_listener'
require_relative 'redmine_table_calculation/hooks/view_projects_show_right_hook_listener'

# Overrides
require_relative 'redmine_table_calculation/overrides/project_patch'

# Others
require_relative 'redmine_table_calculation/copyable'
require_relative 'redmine_table_calculation/sortable'
require_relative 'redmine_table_calculation/calculation_utils'

##
# Plugin Setup
#
module RedmineTableCalculation
  class << self
    def setup
      %w[project_extension_patch
         project_override_patch].each do |patch|
        AdvancedPluginHelper::Patch.register(send(patch))
      end
      # Makes sure, that ProjectType has the same associatons as Project!
      AdvancedPluginHelper::Associations.register(ProjectType)
      AdvancedPluginHelper::Patch.apply do
        { klass: RedmineTableCalculation,
          method: :add_table_custom_fields }
      end
      AdvancedPluginHelper::Patch.apply do
        { klass: RedmineTableCalculation,
          method: :add_helper }
      end
    end

    private

    def project_extension_patch
      { klass: Project,
        patch: RedmineTableCalculation::Extensions::ProjectPatch,
        strategy: :include }
    end

    def project_override_patch
      { klass: Project,
        patch: RedmineTableCalculation::Overrides::ProjectPatch,
        strategy: :prepend }
    end

    def add_table_custom_fields
      return if CustomFieldsHelper::CUSTOM_FIELDS_TABS.any? { |tab| tab[:name] == 'TableCustomField' }

      table_custom_fields = { name: 'TableCustomField',
                              partial: 'custom_fields/index',
                              label: :table_calculation }
      CustomFieldsHelper::CUSTOM_FIELDS_TABS << table_custom_fields
      Redmine::FieldFormat::RecordList.customized_class_names << 'Table'
    end

    def add_helper
      ProjectsController.send :helper, SpreadsheetsHelper
    end
  end
end
