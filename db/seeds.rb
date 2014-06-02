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

Category.create([{ url: 'verificacion', name: 'Verificación', order: 1 },
                 { url: 'hoy-no-circula', name: 'Hoy no circula', order: 2 },
                 { url: 'infracciones', name: 'Infracciones', order: 3 },
                 { url: 'tenencia', name: 'Tenencia', order: 4 }])

Contact.create([{ name: 'Secretaría del Medio Ambiente', 
                  phone: '1234 5678', phone_schedule: '10 a 5', 
                  email: 'contacto@sedema.df.gob.mx',
                  address: 'Av. Tlaxcoaque No. 8, Col. Centro Histórico, Distrito Federal',
                  address_schedule: '9 a 6' },
                { name: 'Secretaría de Finanzas',
                  phone: '8765 4321', phone_schedule: '11 a 4', 
                  email: 'contacto@sefin.df.gob.mx',
                  address: 'Dr. Lavista No. 144, Col. Doctores, Distrito Federal',
                  address_schedule: '10 a 3' }])

Answer.create([{ category_id: 1, contact_id: 1, url: 'verificacion-a',
                 title: 'Pregunta A verificación', body: 'Respuesta A verificación' },
               { category_id: 1, contact_id: 1, url: 'verificacion-b',
                 title: 'Pregunta B verificación', body: 'Respuesta B verificación' },
               { category_id: 1, contact_id: 1, url: 'verificacion-c',
                 title: 'Pregunta C verificación', body: 'Respuesta C verificación' },
               { category_id: 1, contact_id: 1, url: 'verificacion-d',
                 title: 'Pregunta D verificación', body: 'Respuesta D verificación' },
               { category_id: 1, contact_id: 1, url: 'verificacion-e',
                 title: 'Pregunta E verificación', body: 'Respuesta E verificación' }])

Answer.create([{ category_id: 2, contact_id: 1, url: 'hoy-no-circula-a',
                 title: 'Pregunta A hoy no circula', body: 'Respuesta A hoy no circula' },
               { category_id: 2, contact_id: 1, url: 'hoy-no-circula-b',
                 title: 'Pregunta B hoy no circula', body: 'Respuesta B hoy no circula' },
               { category_id: 2, contact_id: 1, url: 'hoy-no-circula-c',
                 title: 'Pregunta C hoy no circula', body: 'Respuesta C hoy no circula' },
               { category_id: 2, contact_id: 1, url: 'hoy-no-circula-d',
                 title: 'Pregunta D hoy no circula', body: 'Respuesta D hoy no circula' },
               { category_id: 2, contact_id: 1, url: 'hoy-no-circula-e',
                 title: 'Pregunta E hoy no circula', body: 'Respuesta E hoy no circula' }])

Answer.create([{ category_id: 3, contact_id: 2, url: 'infracciones-a',
                 title: 'Pregunta A infracciones', body: 'Respuesta A infracciones' },
               { category_id: 3, contact_id: 2, url: 'infracciones-b',
                 title: 'Pregunta B infracciones', body: 'Respuesta B infracciones' },
               { category_id: 3, contact_id: 2, url: 'infracciones-c',
                 title: 'Pregunta C infracciones', body: 'Respuesta C infracciones' },
               { category_id: 3, contact_id: 2, url: 'infracciones-d',
                 title: 'Pregunta D infracciones', body: 'Respuesta D infracciones' },
               { category_id: 3, contact_id: 2, url: 'infracciones-e',
                 title: 'Pregunta E infracciones', body: 'Respuesta E infracciones' }])

Answer.create([{ category_id: 4, contact_id: 2, url: 'tenencia-a',
                 title: 'Pregunta A tenencia', body: 'Respuesta A tenencia' },
               { category_id: 4, contact_id: 2, url: 'tenencia-b',
                 title: 'Pregunta B tenencia', body: 'Respuesta B tenencia' },
               { category_id: 4, contact_id: 2, url: 'tenencia-c',
                 title: 'Pregunta C tenencia', body: 'Respuesta C tenencia' },
               { category_id: 4, contact_id: 2, url: 'tenencia-d',
                 title: 'Pregunta D tenencia', body: 'Respuesta D tenencia' },
               { category_id: 4, contact_id: 2, url: 'tenencia-e',
                 title: 'Pregunta E tenencia', body: 'Respuesta E tenencia' }])
