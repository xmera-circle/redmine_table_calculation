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

module TableCalculation
  module Overrides
    module ProjectPatch
      def self.prepended(base)
        base.singleton_class.prepend(ClassMethods)
        base.prepend(InstanceMethods)
      end

      module ClassMethods; end
      module InstanceMethods
        ##
        # Adds the options[:only] hash to the call_hook.
        #
        # @ override Project#copy
        #
        def copy(project, options={})
          project = project.is_a?(Project) ? project : Project.find(project)
          selection = options[:only]
          to_be_copied = %w[members wiki versions issue_categories issues queries boards documents]
          to_be_copied = to_be_copied & Array.wrap(selection) if selection

          Project.transaction do
            if save
              reload

              self.attachments = project.attachments.map do |attachment|
                attachment.copy(container: self)
              end

              to_be_copied.each do |name|
                send "copy_#{name}", project
              end
              Redmine::Hook.call_hook(:model_project_copy_before_save,
                                      source_project: project,
                                      destination_project: self,
                                      selection: selection)
              save
            else
              false
            end
          end
        end
      end
    end
  end
end

# Apply patch
Rails.configuration.to_prepare do
  unless Project.included_modules.include?(TableCalculation::Overrides::ProjectPatch)
    Project.prepend TableCalculation::Overrides::ProjectPatch
  end
end
