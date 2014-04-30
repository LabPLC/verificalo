# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'info request' do
  subject { page }
  
  describe 'visit info' do
    before { visit info_path }
    it { should have_field('plate') }
    it { should have_button('Continuar') }
    
    describe 'query plate' do
      before do
        fill_in('plate', with:  '123abc')
        click_button('Continuar') 
      end
      # TODO
    end
  end

end
