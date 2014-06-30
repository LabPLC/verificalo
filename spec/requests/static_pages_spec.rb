# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'static pages views' do
  subject { page }
  
  describe 'about' do
    before { visit acerca_path }

    # navbar
    it { should have_link('Información', href: root_path) }
    it { should have_link('Recordatorios', href: recordatorios_path) }
    it { should have_link('Preguntas y respuestas', href: respuestas_path) }
    # footer
    it { should_not have_link('Acerca de Verifícalo', href: acerca_path) }
    it { should_not have_link('Contactanos', href: 'mailto:contacto@verificalo.mx') }
    # content
    it { should have_content('Acerca de Verifícalo') }
    it { should have_link('Manuel Rábade', href: 'http://twitter.com/manuelrabade') }
    it { should have_link('Alberto Barquin', href: 'http://twitter.com/_betoman') }
    it { should have_link('Código para la Ciudad de México', href: 'http://codigo.labplc.mx') }
    it { should have_link('Secretaria de Medio Ambiente', href: 'http://www.sedema.df.gob.mx') }
    it { should have_link('Secretaria de Finanzas', href: 'http://www.finanzas.df.gob.mx') }
    it { should have_link('deposito en GitHub', href: 'http://github.com/LabPLC/verificalo') }
    # box
    it { should have_link('contacto@verificalo.mx', href: 'mailto:contacto@verificalo.mx') }
    it { should have_link('codigo.labplc.mx', href: 'http://codigo.labplc.mx') }
    it { should have_link('github.com/labplc/verificalo', href: 'http://github.com/labplc/verificalo') }
    # thanks
    it { should have_css('.thanks a img', count: 5) }
  end
end
