# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Static pages' do
  subject { page }

  describe 'Home page' do
    before { visit root_path }
    it { should have_title('Verifícalo') }
    it { should have_content('Conozca sus obligaciones como automovilista particular de la Ciudad de México') }
    it { should have_field('plate') }
    it { should have_button('Consulta') }
    it { should have_link('Suscribirse', href: avisos_path) }
    it { should have_link('Preguntar', href: respuestas_path) }
  end

end
