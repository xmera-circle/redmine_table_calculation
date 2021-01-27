# frozen_string_literal: true

# This file is part of the Plugin Redmine Table Calculator.
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

module RedmineTableCalculator
  module_function

  def partial
    'settings/redmine_table_calculator_settings'
  end

  def defaults
    attr = [attr_one, attr_two]
    attr.inject(&:merge)
  end

  def attr_one
    { attr_one: '' }
  end

  def attr_two
    { attr_two: '' }
  end
end