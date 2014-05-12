#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2014 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
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
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

require 'spec_helper'
require 'features/work_packages/work_packages_page'

shared_context 'Toggable fieldset examples' do
  let(:toggable_title_selector) { 'legend a span' }
  let(:toggable_content_selector) { 'span.hidden-for-sighted' }
  let(:find_toggable_title_selector) { lambda { find(toggable_title_selector, text: fieldset_name) } }
  let(:find_toggable_content_selector) { lambda { |link| link.find(toggable_content_selector, visible: false) } }

  shared_context 'find toggle label' do
    let(:link) { find_toggable_title_selector.call.find(:xpath, '..') }

    it { expect(find_toggable_content_selector.call(link)).not_to be_nil }
  end

  shared_examples_for 'toggable fieldset initially collapsed' do
    it_behaves_like 'collapsed fieldset'

    describe 'initial state' do
      it_behaves_like 'toggle state set collapsed'
    end

    describe 'after click' do
      before { find_toggable_title_selector.call.click }

      it_behaves_like 'expanded fieldset'
    end
  end

  shared_examples_for 'toggable fieldset initially expanded' do
    it_behaves_like 'expanded fieldset'

    describe 'initial state' do
      it_behaves_like 'toggle state set expanded'
    end

    describe 'after click' do
      before { find_toggable_title_selector.call.click }

      it_behaves_like 'collapsed fieldset'
    end
  end

  shared_examples_for 'toggle state set collapsed' do
    include_context 'find toggle label'

    it { expect(find_toggable_content_selector.call(link).text(:all)).to include(I18n.t('js.label_collapsed')) }
  end

  shared_examples_for 'toggle state set expanded' do
    include_context 'find toggle label'

    it { expect(find_toggable_content_selector.call(link).text(:all)).to include(I18n.t('js.label_expanded')) }
  end

  shared_context 'collapsed CSS' do
    let(:collapsed_class_name) { 'collapsed' }
  end

  shared_examples_for 'collapsed fieldset' do
    include_context 'collapsed CSS'

    it { expect(find_toggable_title_selector.call.find(:xpath, '../../..')[:class]).to include(collapsed_class_name) }
  end

  shared_examples_for 'expanded fieldset' do
    include_context 'collapsed CSS'

    it { expect(find_toggable_title_selector.call.find(:xpath, '../../..')[:class]).not_to include(collapsed_class_name) }
  end
end
