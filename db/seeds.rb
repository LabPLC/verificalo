# -*- coding: utf-8 -*-

require 'csv'
require 'i18n'

AdminUser.create(email: 'admin@verificalo.mx', 
                 password: 'verificalo',
                 password_confirmation: 'verificalo')

Delegacion.create([{ url: 'alvaro-obregon', name: 'Álvaro Obregón' },
                   { url: 'azcapotzalco', name: 'Azcapotzalco' },
                   { url: 'benito-juarez', name: 'Benito Juárez' },
                   { url: 'coyoacan', name: 'Coyoacán' },
                   { url: 'cuajimalpa', name: 'Cuajimalpa de Morelos' },
                   { url: 'cuauhtemoc', name: 'Cuauhtémoc' },
                   { url: 'gustavo-a-madero', name: 'Gustavo A. Madero' },
                   { url: 'iztacalco', name: 'Iztacalco' },
                   { url: 'iztapalapa', name: 'Iztapalapa' },
                   { url: 'magdalena-contreras', name: 'Magdalena Contreras' },
                   { url: 'miguel-hidalgo', name: 'Miguel Hidalgo' },
                   { url: 'milpa-alta', name: 'Milpa Alta' },
                   { url: 'tlahuac', name: 'Tláhuac' },
                   { url: 'tlalpan', name: 'Tlalpan' },
                   { url: 'venustiano-carranza', name: 'Venustiano Carranza' },
                   { url: 'xochimilco', name: 'Xochimilco' }])

CSV.foreach('db/data/verificentros.csv', :headers => true) do |r|
  next unless r['DIRECCION']
  d = Delegacion.find_by(url: r['DELEGACION'].downcase.gsub(/\s+/, '-'))
  unless d
    d = Delegacion.where("unaccent(lower(name)) = ?", r['DELEGACION'].downcase).first
  end
  unless d
    puts '! delegacion not found: ' + r['DELEGACION']
    next
  end
  Verificentro.create(number: r['VERIFICENTRO'], 
                      name: r['RAZON SOCIAL'], 
                      address: r['DIRECCION'], 
                      delegacion_id: d.id, 
                      phone: r['TELEFONOS'],
                      lat: r['LATITUD'],
                      lon: r['LONGITUD'])
end

Category.create([{ url: 'verificacion', name: 'Verificación', priority: 1 },
                 { url: 'hoy-no-circula', name: 'Hoy no circula', priority: 2 },
                 { url: 'infracciones', name: 'Infracciones', priority: 3 },
                 { url: 'tenencia', name: 'Tenencia', priority: 4 }])

Contact.create([{ name: 'Secretaría del Medio Ambiente', 
                  phone: '1234 5678', phone_schedule: '10 am a 5 pm', 
                  email: 'contacto@sedema.df.gob.mx',
                  address: 'Av. Tlaxcoaque No. 8, Col. Centro Histórico, Distrito Federal',
                  address_schedule: '9 am a 6 pm', lat: '19.423219', lon: '-99.134159' },
                { name: 'Secretaría de Finanzas',
                  phone: '8765 4321', phone_schedule: '11 am a 4 pm', 
                  email: 'contacto@sefin.df.gob.mx',
                  address: 'Dr. Lavista No. 144, Col. Doctores, Distrito Federal',
                  address_schedule: 'de 10 am hasta 3 pm' }])

Answer.create([{ category_id: 2, url: 'hoy-no-circula-a',
                 title: 'Pregunta A hoy no circula', body: '<p>Respuesta A hoy no circula</p>' },
               { category_id: 2, url: 'hoy-no-circula-b',
                 title: 'Pregunta B hoy no circula', body: '<p>Respuesta B hoy no circula</p>' },
               { category_id: 2, url: 'hoy-no-circula-c',
                 title: 'Pregunta C hoy no circula', body: '<p>Respuesta C hoy no circula</p>' }])

Answer.create([{ category_id: 3, contact_id: 2, url: 'infracciones-a',
                 title: 'Pregunta A infracciones', body: '<p>Respuesta A infracciones</p>' },
               { category_id: 3, contact_id: 2, url: 'infracciones-b',
                 title: 'Pregunta B infracciones', body: '<p>Respuesta B infracciones</p>' },
               { category_id: 3, contact_id: 2, url: 'infracciones-c',
                 title: 'Pregunta C infracciones', body: '<p>Respuesta C infracciones</p>' }])

Answer.create([{ category_id: 4, contact_id: 2, url: 'tenencia-a',
                 title: 'Pregunta A tenencia', body: '<p>Respuesta A tenencia</p>' },
               { category_id: 4, contact_id: 2, url: 'tenencia-b',
                 title: 'Pregunta B tenencia', body: '<p>Respuesta B tenencia</p>' },
               { category_id: 4, contact_id: 2, url: 'tenencia-c',
                 title: 'Pregunta C tenencia', body: '<p>Respuesta C tenencia</p>' }])

Answer.create([{ category_id: 1, contact_id: 1, url: 'verificacion-a',
                 title: 'Pregunta A verificación', body: '<p>Respuesta A verificación</p>',
                 related_1_id: 1, related_2_id: 2, related_3_id: 3 },
               { category_id: 1, contact_id: 1, url: 'verificacion-b',
                 title: 'Pregunta B verificación', body: '<p>Respuesta B verificación</p>',
                 related_1_id: 1, related_2_id: 2, related_3_id: 3 },
               { category_id: 1, contact_id: 1, url: 'verificacion-c',
                 title: 'Pregunta C verificación', body: '<p>Respuesta C verificación</p>',
                 related_1_id: 1, related_2_id: 2, related_3_id: 3 },
               { category_id: 1, contact_id: 1, url: 'verificacion-d',
                 title: 'Pregunta D verificación', body: '<p>Respuesta D verificación</p>',
                 related_1_id: 1, related_2_id: 2, related_3_id: 3 },
               { category_id: 1, contact_id: 1, url: 'verificacion-e',
                 title: 'Pregunta E verificación', body: '<p>Respuesta E verificación</p>',
                 related_1_id: 1, related_2_id: 2, related_3_id: 3 }])
