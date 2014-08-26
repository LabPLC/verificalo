# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'info views' do
  subject { page }
  
  describe 'home' do
    before { visit root_path }
            
    # navbar
    it { should_not have_link('Información', href: root_path) }
    # footer
    it { should have_link('Acerca de Verifícalo', href: acerca_path) }
    it { should have_link('Contáctanos', href: 'mailto:contacto@verificalo.mx') }
    it { should have_link('Código para la Ciudad de México', href: 'http://codigo.labplc.mx') }
    # jumbotron
    it { should have_css('div.jumbotron', text: /ingresa la placa/i) }
    it { should have_field('plate') }
    it { should have_button('Consulta') }
    # grid
    it { should have_link('Recordatorios', href: recordatorios_path) }
    it { should have_link('¡Suscríbete!', href: recordatorios_path) }
    it { should have_link('Preguntas y respuestas', href: respuestas_path) }
    it { should have_link('Preguntar', href: respuestas_path) }
    # content
    it { should have_title('Verifícalo') }
    
    describe 'query' do
      before do
        stub_datalab('verificacion_multiple_vins')
        fill_in('plate', with: '123ABC')
        click_button('Consulta') 
      end

      it { should have_css('h1', text: /auto 123abc/i) }
      it { should have_content(/hay más de un auto verificado con esa placa/i) }
      it { should have_field('vin', count: 2) }
      it { should have_button('Continuar') }

      describe 'choose vin with verificacion' do
        before do
          choose('1234567890ABCDEFG')
          click_button('Continuar') 
        end

        # header
        it { should have_css('h1', text: /auto 123abc/i) }
        it { should have_link('Cambiar placa', href: root_path) }
        it { should have_link('Cambiar número de serie', href: url_for({ controller: 'info',
                                                                         action: 'reset',
                                                                         plate: '123ABC',
                                                                         item: 'vin',
                                                                         only_path: true })) }
        # verificacion
        it { should have_content(/el próximo periodo para verificar tu auto inicia el (.+) y termina el/i) }
        it { should have_link('Mi historial de verificaciones', href: url_for({ controller: 'info',
                                                                                action: 'verificaciones', 
                                                                                plate: '123ABC',
                                                                                only_path: true })) }
        # hoy no circula
        it { should have_content(/tu auto obtuvo el holograma dos en su última verificación/i) }
        # infracciones
        it { should have_content(/tu auto no tiene infracciones sin pagar/i) }
        it { should have_link('Mi historial de infracciones', href: url_for({ controller: 'info',
                                                                              action: 'infracciones', 
                                                                              plate: '123ABC',
                                                                              only_path: true })) }
        # tenencias
        it { should have_content(/tu auto no tiene adeudos de tenencia/i) }
        # call to action
        it { should have_link('¡Suscríbete!', href: recordatorios_path) }

        describe 'verificaciones history' do
          before { click_link('Mi historial de verificaciones') }
          # header
          it { should have_css('h1', text: /auto 123abc/i) }
          it { should have_link('Cambiar placa', href: root_path) }
          it { should have_link('Cambiar número de serie', href: url_for({ controller: 'info',
                                                                           action: 'reset',
                                                                           plate: '123ABC',
                                                                           item: 'vin',
                                                                           only_path: true })) }
          # verificaciones
          it { should have_css('h2', text: /verificaciones/i) }
          it { should have_link('Regresar', href: url_for({ controller: 'info',
                                                            action: 'results',
                                                            plate: '123ABC',
                                                            only_path: true })) }
        end

        describe 'infracciones history' do
          before { click_link('Mi historial de infracciones') }

          # header
          it { should have_css('h1', text: /auto 123abc/i) }
          it { should have_link('Cambiar placa', href: root_path) }
          it { should have_link('Cambiar número de serie', href: url_for({ controller: 'info',
                                                                           action: 'reset',
                                                                           plate: '123ABC',
                                                                           item: 'vin',
                                                                           only_path: true })) }
          # infracciones
          it { should have_css('h2', text: /infracciones/i) }
          it { should have_link('Regresar', href: url_for({ controller: 'info',
                                                            action: 'results',
                                                            plate: '123ABC',
                                                            only_path: true })) }
        end
      end

      describe 'choose vin without verificacion' do
        before do
          choose('1234567890TUVWXYZ')
          click_button('Continuar') 
        end

        it { should have_css('h1', text: /auto 123abc/i) }
        it { should have_content(/su auto nunca ha aprobado la verificación/i) }
        it { should have_field('registration[day]') }
        it { should have_select('registration[month]') }
        it { should have_field('registration[year]') }
        it { should have_button('Continuar') }

        describe 'enter registration date' do
          before do
            fill_in('registration[day]', with: Date.today.months_ago(2).day)
            select(I18n.t('date.month_names')[Date.today.months_ago(2).month], from: 'registration[month]')
            fill_in('registration[year]', with: Date.today.months_ago(2).year)
            click_button('Continuar')            
          end

          # header
          it { should have_css('h1', text: /auto 123abc/i) }
          it { should have_link('Cambiar placa', href: root_path) }
          it { should have_link('Cambiar número de serie', href: url_for({ controller: 'info',
                                                                           action: 'reset',
                                                                           plate: '123ABC',
                                                                           item: 'vin',
                                                                           only_path: true })) }
          it { should have_link('Cambiar fecha de alta', href: url_for({ controller: 'info',
                                                                         action: 'reset',
                                                                         plate: '123ABC',
                                                                         item: 'alta',
                                                                         only_path: true })) }
          # verificaciones
          it { should have_content(/tu auto debe aprobar la verificación a más tardar el/i) }
          it { should have_link('Mi historial de verificaciones', href: url_for({ controller: 'info',
                                                                                  action: 'verificaciones', 
                                                                                  plate: '123ABC',
                                                                                  only_path: true })) }
          # hoy no circula
          it { should have_content(/nunca has verificado tu auto y como su placa termina en/i) }
          # infracciones
          it { should have_content(/tu auto no tiene infracciones sin pagar/i) }
          it { should have_link('Mi historial de infracciones', href: url_for({ controller: 'info',
                                                                                action: 'infracciones', 
                                                                                plate: '123ABC',
                                                                                only_path: true })) }
          # tenencias
          it { should have_content(/tu auto no tiene adeudos de tenencia/i) }
          # call to action
          it { should have_link('¡Suscríbete!', href: recordatorios_path) }
        end
      end
    end
  end
end
