# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'query plate info' do
  subject { page }
  
  describe 'visit home' do
    before { visit info_path }
    it { should have_field('plate') }
    it { should have_button('Continuar') }
    
    describe 'query plate' do
      before do
        fill_in('plate', with:  '123abc')
        click_button('Continuar') 
      end
      it { should have_content('123ABC') }
      # TODO
    end
  end

end
