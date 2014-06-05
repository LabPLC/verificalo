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

Contact.create({ name: 'Secretaría del Medio Ambiente', 
                 phone: '5134 2380', phone_schedule: 'extensión 1690, 9 am a 5 pm',
                 email: 'contacto@sedema.df.gob.mx',
                 address: 'Av. Tlaxcoaque No. 8, Col. Centro Histórico, Distrito Federal',
                 address_schedule: '9 am a 4 pm', lat: '19.423219', lon: '-99.134159' })

Answer.create([{ category_id: 1, contact_id: 1, related_1_id: 2,
                 title: '¿Donde puedo verificar mi auto?', url: 'verificentros',
                 body: 'Verificentros de la Ciudad de México por delegación o cercanos donde puede verificar su auto' }])

Answer.create([{ category_id: 1, contact_id: 1, related_1_id: 1,
                 title: '¿Qué es la verificación vehícular?', url: 'que-es-la-verificacion',
                 body: '<p class="lead">Los automoviles son una de las fuentes más importantes de contaminación del aire en la Ciudad de México.</p><p class="lead">La verificación es el programa de la Secretaría del Medio Ambiente para asegurar que los vehículos que circulan en la Ciudad de México emitan la menor cantidad posible de contaminantes.</p>' }])
