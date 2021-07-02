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

module TableCalculation
  module Copyable
    ##
    # Returns an unsaved copy of an object.
    #
    # @note Associates won't be copied.
    #
    def copy(attributes = nil)
      copy = self.class.new
      copy.attributes = self.attributes.dup.except(*attributes_to_ignore)
      copy.attributes = attributes if attributes
      copy
    end

    module_function

    ##
    # List of strings with attributes which should be ignored when copying.
    #
    # @example
    #   def attributes_to_ignore
    #     %w[id parent_id]
    #   end
    #
    def attributes_to_ignore
      raise NotImplementedError
    end
  end
end
