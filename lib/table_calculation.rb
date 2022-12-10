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

# Extensions
require 'table_calculation/extensions/project_patch'
require 'table_calculation/extensions/project_type_patch'

# Hooks
require 'table_calculation/hooks/view_layouts_base_html_head_hook_listener'
require 'table_calculation/hooks/model_project_copy_before_save_hook_listener'
require 'table_calculation/hooks/view_projects_copy_only_items_hook_listener'
require 'table_calculation/hooks/view_projects_show_right_hook_listener'

# Overrides
require 'table_calculation/overrides/project_patch'

# Others
require 'table_calculation/copyable'
require 'table_calculation/sortable'
