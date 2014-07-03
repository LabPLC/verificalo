# -*- coding: utf-8 -*-
require 'csv'
require 'i18n'
require 'database_cleaner'

DatabaseCleaner.clean_with :truncation, { only: [ 'admin_users',
                                                  'delegaciones',
                                                  'verificentros',
                                                  'categories',
                                                  'contacts',
                                                  'answers' ] }

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
                 { url: 'hoy-no-circula', name: 'Hoy No Circula', priority: 2 }])
                 #{ url: 'infracciones', name: 'Infracciones', priority: 3 },
                 #{ url: 'tenencia', name: 'Tenencia', priority: 4 }])

Contact.create({ name: 'Secretaría del Medio Ambiente', 
                 phone: '5134 2380',
                 address: 'Av. Tlaxcoaque No. 8, Col. Centro Histórico, Distrito Federal',
                 address_schedule: '9 am a 6 pm', lat: '19.423219', lon: '-99.134159' })

Contact.create({ name: 'Dirección Ejecutiva de Vigilancia Ambiental', 
                 phone: '5278 9931', phone_schedule: 'extensión 4550 de 8&nbsp;am a 8:30&nbsp;pm',
                 address: 'Av. Tlaxcoaque No. 8, Col. Centro Histórico, Distrito Federal',
                 address_schedule: '9&nbsp;am a 1:30&nbsp;pm', lat: '19.423219', lon: '-99.134159' })

Contact.create({ name: 'Dirección General de Inspección Policiaca', 
                 phone: '5242 5000', phone_schedule: 'extensiones 1120, 1121, 1122 y 1171' })

# verificacion

# 1
Answer.create({ category_id: 1, contact_id: 1, related_1_id: 2, related_2_id: 3, related_3_id: 5, related_4_id: 6, related_5_id: 15,
                title: '¿Qué es la verificación vehícular?', url: 'que-es-la-verificacion',
                source: 'http://www.sedema.df.gob.mx/sedema/index.php/verificacion-hoy-no-circula/verificacion-vehicular/objetivo-aplicacion-programa-verificacion-vehicular',
                body: '<p class="lead">Los autos son una de las fuentes más importantes de contaminantes del aire en la Ciudad de México, por eso la Secretaría del Medio Ambiente cuenta con un programa para asegurar que los vehículos que circulan en la Ciudad de México emitan la menor cantidad posible de contaminantes, este programa se conoce como Programa de Verificación Vehicular. Además de asegurar una menor contaminación, fomenta también el mantenimiento preventivo y correctivo del auto. El programa es de carácter obligatorio para todos los autos matriculados en la Ciudad de México.</p>'})

# 2
Answer.create({ category_id: 1, contact_id: 1, related_1_id: 3, related_2_id: 6, related_3_id: 4, related_4_id: 7, related_5_id: 9,
                title: '¿Cuando debo verificar mi auto?', url: 'cuando-verificar',
                source: 'http://www.sedema.df.gob.mx/sedema/index.php/verificacion-hoy-no-circula/verificacion-vehicular/calendario-verificacion',
                body: '<p class="lead">Los autos deberán realizar y aprobar la verificación de emisiones vehiculares cada semestre, salvo para el caso de los que obtengan un holograma <strong>doble cero</strong>, en cuyo caso el auto estará exento de verificar sus emisiones hasta por tres semestres posteriores al semestre en que se obtuvo.</p>

<p>Los vehículos matriculados en el Distrito Federal y que ya han sido verificados en sus emisiones vehiculares en su período anterior, deberán continuar verificando conforme al color del engomado o al último dígito numérico de las placas de circulación del vehículo en los siguientes términos.</p>

<table class="table table-bordered text-center">
<thead><tr><th colspan="2">&nbsp;</th><th colspan="2" class="text-center">Período para verificar</th></tr>
<tr><th class="text-center">Color del engomado</th><th class="text-center">Último dígito de la placa</th><th class="text-center">1er semestre</th><th class="text-center">2do semestre</th></tr></thead>
<tbody>
<tr><td bgcolor="#ffff66"><strong>Amarillo</strong></td><td>5 ó 6</td><td>enero y febrero</td><td>julio y agosto</td></tr>
<tr><td bgcolor="#ff99cc"><strong>Rosa</strong></td><td>7 ó 8</td><td>febrero y marzo</td><td>agosto y septiembre</td></tr>
<tr><td bgcolor="#ff3333"><strong>Rojo</strong></td><td>3 ó 4</td><td>marzo y abril</td><td>septiembre y octubre</td></tr>
<tr><td bgcolor="#339900"><strong>Verde</strong></td><td>1 ó 2</td><td>abril y mayo</td><td>octubre y noviembre</td></tr>
<tr><td bgcolor="#66ccff"><strong>Azul</strong></td><td>9 ó 0</td><td>mayo y junio</td><td>noviembre y diciembre</td></tr>
</tbody></table>' })

# 3
Answer.create({ category_id: 1, contact_id: 1,  related_1_id: 6, related_2_id: 4, related_3_id: 2, related_4_id: 7, related_5_id: 9,
                title: '¿Donde puedo verificar mi auto?', url: 'verificentros',
                body: 'Verificentros de la Ciudad de México por delegación o cercanos donde puede verificar su auto' })

# 4
Answer.create({ category_id: 1, contact_id: 1, related_1_id: 6, related_2_id: 3, related_3_id: 2, related_4_id: 9,
                title: '¿Cuál es el costo de la verificación?', url: 'cuanto-cuesta-la-verificacion',
                source: 'http://www.sedema.df.gob.mx/sedema/index.php/verificacion-hoy-no-circula/verificacion-vehicular/tarifas-verificacion',
                body: '<p class="lead">El costo por los servicios de verificación vehicular que presten los Verificentros, es de $398.00 (Trescientos noventa y ocho pesos 00/100 M.N.) para todo tipo de Constancia de Verificación (Holograma doble cero, cero, uno, dos, rechazo y evaluación técnica) que se entregue al usuario.</p>

<p>La verificación podrá ser gratuita cuando la verificación non que le anteceda sea un rechazo vehicular, siempre y cuando la verificación par se realice en el mismo Verificentro en que se obtuvo el rechazo vehicular. La gratuidad excluye el pago por verificación extemporánea. La oportunidad de una siguiente verificación gratuita no será aplicable en el caso de verificaciones practicadas en los últimos siete días naturales del período de verificación del auto.</p>

<p>La tarifa por la expedición de las reposiciones de Constancias de Verificación (holograma y/o certificado), será la que establezca el Código Fiscal del Distrito Federal.</p>

<p>Las copias de documentos necesarios para realizar la verificación vehicular de cada unidad, que el propietario o poseedor del automotor a verificar llegase a solicitar a los Verificentros, deberá ser cobrada en un máximo de un peso por cada copia fotostática solicitada, no estando obligado el Verificentro a prestar dicho servicio.</p>

<p>La Constancia del tipo exento se expedirá sin costo alguno.</p>'})

# 5
Answer.create({ category_id: 1, contact_id: 1, related_1_id: 15, related_2_id: 2, related_3_id: 3, related_4_id: 6, related_5_id: 9,
                title: '¿Qué holograma puede obtener mi auto?', url: 'que-holograma-puede-obtener-mi-auto',
                source: 'http://www.sedema.df.gob.mx/sedema/index.php/verificacion-hoy-no-circula/verificacion-vehicular/hologramas-que-se-pueden-obtener',
                body: '<p>Los hologramas que puede obtener tu auto conforme al nuevo Programa de Verificación Vehicular son los siguientes:</p>
<table class="table table-bordered text-center">
<thead><tr><th class="text-center">Holograma</th><th class="text-center">Auto</th><th class="text-center">Vigencia de holograma</th></tr></thead>
<tbody>
<tr bgcolor="#29aae3"><td><strong>Exento</strong></td><td>Híbridos y eléctricos</td><td>8 años</td></tr>
<tr bgcolor="#8cc63e"><td><strong>Doble cero</strong></td><td>Modelo 2014 y posteriores</td><td>2 años a partir de la fecha de factura</td></tr>
<tr bgcolor="#ffc40c"><td><strong>Cero</strong></td><td>Modelo 2006 y posteriores</td><td>Semestral</td></tr>
<tr bgcolor="#f7933d"><td><strong>Uno</strong></td><td>Modelo 1999 y posteriores</td><td>Semestral</td></tr>
<tr bgcolor="#ed1b24"><td><strong>Dos</strong></td><td>Cualquier modelo</td><td>Semestral</td></tr>
</tbody></table>

<h4 class="title">Exento</h4>
<p>La constancia denominada <strong>exento</strong> para auto eléctricos e híbridos, la cual los exenta de la verificación vehicular y de las limitaciones del Programa Hoy No Circula podrá ser tramitada en el Módulo de Atención Ciudadana (Av. Tlaxcoaque No. 8, PB, Col. Centro Histórico, Del. Cuauhtémoc, C.P. 06090, México, Distrito Federal) sin costo, en un horario de 9:00 a 18:00 horas.</p>
<p>El Trámite podrá ser realizarlo por los propietarios o poseedores de autos eléctricos e híbridos matriculados en el Distrito Federal o que se encuentren en posesión de los fabricantes o distribuidores de autos nuevos y sin matrícula asignada.</p>
<p>Consulta el trámite y descarga el formato correspondiente en el apartado <em>Constancia denominada Exento para autoss eléctricos e híbridos</em> de la sección <a href="http://www.sedema.df.gob.mx/sedema/index.php/tramites/tramites-verificacion-vehicular-hoy-no-circula">Trámites / Verificación vehicular y Hoy No Circula</a> de la página de la Secretaría de Medio Ambiente.</p>
<p>Consulta el <a href="http://www.sedema.df.gob.mx/sedema/index.php/verificacion-hoy-no-circula/verificacion-vehicular/hologramas-que-se-pueden-obtener">listado de autos candidatos al holograma exento</a> en la página de la Secretaría del Medio Ambiente.</p>

<h4 class="title">Doble cero</h4>
<p>Podrán obtener este holograma:</p>
<ol>
<li>Unidades nuevas a gasolina año modelo 2014 y posteriores podrán obtener el holograma <strong>doble cero</strong> en su primera verificación o intentos posteriores para obtener el mismo, siempre y cuando sea dentro de los 365 días posteriores a la fecha de facturación, y cumplan con lo establecido en la norma NOM-163-SEMARNAT-ENER-SCFI-2013.</li>
<li>Unidades nuevas año modelo 2014 y posteriores a <em>diesel</em> con tecnología EURO V, EPA 2010 o posteriores con sistemas de control de emisiones del tipo filtros de partículas. Datos que deberán ser reportados por los fabricantes o importadores de autos a la Dirección General de Gestión de la Calidad del Aire.</li>
<li>Unidades nuevas año modelo 2014 y posteriores a Gas Natural Comprimido, que desde su fabricación utilicen este combustible como carburante.</li>
</ol>

<h4 class="title">Proceso de transición para obtener el holograma uno</h4>
<p>Los autos de uso particular a gasolina que cuenten o estén sujetos a un holograma <strong>dos</strong>, podrán acceder al holograma <strong>uno</strong>, siempre y cuando en el proceso de verificación vehicular acrediten el nivel de emisiones que les corresponde. El propietario podrá verificar su auto antes de su periodo de verificación debiendo pagar la verificación respectiva. El hecho de obtener el holograma <strong>uno</strong> no exime al propietario del auto de cumplir con su verificación en el periodo que le corresponda.</p>

<h4 class="title">Rechazo</h4>
<p>Esta constancia la obtendrán aquellos autos cuyas emisiones rebasen los valores máximos establecidos en los numerales 7.6.1 a 7.6.3 del Programa de Verificación Vehicular Obligatoria vigente y/o que no aprueben la revisión visual de humo y/o que carezcan de alguno de los componentes de control de emisiones del auto (tapón del tanque de almacenamiento de combustible, bayoneta de aceite, tapón de aceite, portafiltro de aire y tubo de escape para motores ciclo Otto, y se adiciona gobernador en el caso de unidades a diesel). Así mismo, se les entregará a los propietarios de las unidades que presenten falla en la operación del convertidor catalítico o que no presenten las condiciones operativas para realizar la prueba de verificación de emisiones vehiculares.</p>
<p>Este mismo documento se entregará al parque vehicular al que se practique una prueba de evaluación técnica.</p>'})

# 6
Answer.create({ category_id: 1, contact_id: 1, related_1_id: 3, related_2_id: 2, related_3_id: 7, related_4_id: 4, related_5_id: 9,
                title: '¿Qué necesito para verificar mi auto?', url: 'que-necesito-para-verificar',
                body: '<p class="lead">Consulte la tabla de <a href="http://www.sedema.df.gob.mx/sedema/index.php/verificacion-hoy-no-circula/verificacion-vehicular/requisitos-para-verificar">requisitos para verificar</a> en la página de la Secretaría del Medio Ambiente</p>' })

# 7
Answer.create({ category_id: 1, contact_id: 1,  related_1_id: 2, related_2_id: 3, related_3_id: 6, related_4_id: 9,
                source: 'http://www.sedema.df.gob.mx/sedema/index.php/verificacion-hoy-no-circula/verificacion-vehicular/vehiculos-con-multas',
                title: 'Verificación con multa', url: 'multa-verificacion',
                body: '<p>Los autos que sean llevados a verificar y que no hayan realizado este trámite en el semestre anterior o en el período de tiempo correspondiente, deberán pagar una multa por verificación vehicular extemporánea, de acuerdo a lo siguiente:</p>
<ul>
<li>Pagar una multa por verificación vehicular extemporánea por 20 DSMGV. La vigencia del pago de la multa es de 30 días naturales a partir del pago de la misma, siendo el tiempo que se tiene para poder realizar y aprobar la verificación vehicular del automotor.</li>
<li>En caso de no obtener una constancia de verificación aprobatoria en los 30 días establecidos, se deberá pagar otra multa por verificación vehicular extemporánea pero por un monto de 40 DSMGV, con lo cual se adquiere otro nuevo plazo de 30 días naturales para aprobar la verificación de emisiones.</li>
<li>En caso de no obtener una constancia de verificación aprobatoria en los 30 días establecidos en el numeral 9.1.2 del PVVO, se deberá pagar otra multa por verificación vehicular extemporánea pero por un monto de 80 DSMGV, con lo cual se adquiere otro nuevo plazo de 30 días naturales para aprobar la verificación de emisiones. Si el plazo para verificar se vence nuevamente sin que la unidad hubiese aprobado la verificación, se deberá pagar otra multa por verificación extemporánea por 80 DSMGV para obtener otros 30 días para poder verificar su unidad; este mecanismo se repetirá tantas veces sea necesario hasta que la unidad apruebe la verificación de emisiones vehiculares.</li>
</ul>
<p>Durante la vigencia del pago de la multa por verificación extemporánea, el auto sólo podrá circular para dirigirlo a un taller mecánico y/o a un Verificentro.</p>
<p>Los autos que no hayan sido verificados debido a robo de la unidad, siniestro, reparación mayor o alguna otra causa de fuerza mayor, se les ampliará el período para verificar las emisiones de su automóvil (a través de un permiso de ampliación del período de verificación de emisiones vehiculares), por lo que no se harán acreedores al pago por verificación extemporánea, siempre y cuando les sea autorizada la ampliación de período por la Dirección General de Gestión de la Calidad del Aire de la Secretaria del Medio Ambiente del Distrito Federal “DGGCA”, en cuyo caso deberán verificar la unidad durante el período de tiempo que se les indique en la ampliación del mismo.</p>

<p>Consulta los requisitos para tramitar la <em>Autorización de ampliación al periodo de verificación por robo, siniestro o reparación mayor</em> en la sección <a href="http://www.sedema.df.gob.mx/sedema/index.php/tramites/tramites-verificacion-vehicular-hoy-no-circula">Trámites / Verificación vehicular y Hoy No Circula</a> de la página de la Secretaría del Medio Ambiente.</p>

Los autos que no hayan sido verificados en su periodo de verificación debido a falta de actualización oportuna de pagos de tenencias o infracciones al Reglamento de Tránsito Metropolitano o al que le sustituya, en el sistema de consulta de la Secretaría de Finanzas, se les permitirá verificar sus emisiones sin el pago de multa por verificación extemporánea, siempre y cuando tramiten y les sea autorizada la condonación del pago por parte de la Secretaría de Finanzas del Gobierno del Distrito Federal.' })

# 8
Answer.create({ category_id: 1, contact_id: 1, related_1_id: 2, related_2_id: 3, related_3_id: 6, related_4_id: 9,
                title: 'Rechazo por convertidor catalítico', url: 'rechazo-convertidor-catalitico',
                source: 'http://www.sedema.df.gob.mx/sedema/index.php/verificacion-hoy-no-circula/verificacion-vehicular/vehiculos-con-rechazo-por-convertidor-catalitico',
                body: '<p class="lead">Durante la prueba de verificación se evaluará la eficiencia del convertidor catalítico mediante la lectura de los gases de escape, generándose un rechazo en aquellos vehículos cuyos convertidores catalíticos hayan perdido eficiencia en la conversión.</p>
<p>Debes acudir a un Taller PIREC autorizado y ubicado en el Distrito Federal o a una agencia automotriz a cambiar este dispositivo anticontaminante, así como a realizar el diagnóstico y las reparaciones necesarias al motor de su vehículo.</p>
<p>El vehículo no podrá ser verificado nuevamente hasta haber realizado el cambio de convertidor catalítico en un Taller PIREC autorizado o en las agencias concesionadas por los fabricantes de vehículos.</p>
<p><a href="http://www.sma.df.gob.mx/sistemas/pirec_talleres/consulta.php">Consulta la ubicación de los Talleres PIREC autorizados por la Dirección General de Gestión de la Calidad del Aire.</a></p>

<h4 class="title"p>Importante</h4>
<ul>
<li>Una buena reparación y mantenimiento periódico garantiza el buen estado del vehículo.</li>
<li>Un convertidor catalítico nunca debe fallar; si esto ocurre, entonces existe un problema.</li>
<li>En caso de ser rechazado o no obtener el holograma máximo permitido para tu vehículo, regresar al Taller Autorizado PIREC para reclamar la garantía.</li>
<li>Solo reemplazar el convertidor catalítico no resuelve el problema, se requiere revisar y en su caso reparar el motor.</li>
</ul>'})

# 9
Answer.create({ category_id: 1, contact_id: 2,  related_1_id: 6, related_2_id: 7, related_3_id: 8,
                title: 'Denuncia de abuso en los verificentros', url: 'denuncias-verificentros',
                source: 'http://www.sedema.df.gob.mx/sedema/index.php/verificacion-hoy-no-circula/verificacion-vehicular/denuncia',
                body: '<p class="lead">En caso de algún abuso en Verificentros del Distrito Federal podrá llamar desde el Verificentro ya que todos cuentan con línea directa al Centro de Inspección y Vigilancia Remota (CIVAR), el teléfono es gratuito y se encuentra en una caseta identificada con el nombre de <strong>VERIFICATEL</strong>. La llamada podrá ser atendida y vigilada a través del CIVAR.</p>

<p>También puede llamar al teléfono 52789931 ext 4550 desde cualquier lugar, en un horario de 8:00 a 20:30 horas y/o levantar una denuncia ante la Dirección Ejecutiva de Vigilancia Ambiental de la Secretaría del Medio Ambiente, de forma personal por Oficialía de Partes en el Edificio Juana de Arco ubicado en Tlaxcoaque No.8, Col. Centro Histórico, Delegación Cuauhtémoc, en planta baja, de lunes a viernes, en un horario de 9:00am a 1:30pm.</p>

<p>Los datos necesarios para dar seguimiento a una denuncia son:</p>

<ol>
<li>Nombre completo y datos de ubicación del denunciante. (Indicar dirección, teléfono y/o dirección de correo electrónico del denunciante para poder contactarlo de ser necesario).</li>
<li>Lugar de los hechos. (Señalar calle, número, colonia, Delegación, Código Postal o datos que permitan ubicar el predio).</li>
<li>Hechos denunciados. (Describir las obras o actividades que se denuncian y las afectaciones al medio ambiente en su caso).</li>
<li>Momento en que se suscitan los hechos. (Indicar cuando ocurrieron los hechos, o en su caso cuando iniciaron en caso de que sean continuos o permanentes).</li>
<li>Personas presuntas responsables. (Señalar el nombre de las personas responsables de los hechos).</li>
<li>Información complementaria. (referir si se tienen información respecto de permisos, licencias o autorizaciones que en su caso se hayan expedido por las autoridades).</li>
<li>Elementos probatorios. (Referir y anexar todas las pruebas que se tengan para acreditar los hechos, como son: documentos, fotografías y videos, entre otros).</li>'})

# hoy no circula

# 10
Answer.create({ category_id: 2, contact_id: 1, related_1_id: 15, related_2_id: 11, related_3_id: 14, related_4_id: 13, related_5_id: 12,
                title: '¿En qué consiste el Hoy No Circula?', url: 'que-es-hoy-no-circula',
                source: 'http://www.sedema.df.gob.mx/sedema/index.php/verificacion-hoy-no-circula/hoy-no-circula/por-que-se-modernizo-el-programa-hoy-no-circula',
                body: '<p class="lead">Dentro del parque vehicular que circula en la ciudad existen vehículos cuya tecnología o estado mecánico ya no permite garantizar un mínimo de emisiones contaminantes. El porcentaje de este tipo de vehículos disminuye año con año, sin embargo, para evitar que estos vehículos tengan un impacto significativo en la calidad del aire se limita su circulación y este programa se conoce como Hoy No Circula.</p>' })

# 11
Answer.create({ category_id: 2, contact_id: 1, related_1_id: 15, related_2_id: 12,
                title: 'Autos exentos del Hoy No Circula', url: 'vehiculos-extenos-hoy-no-circula',
                source: 'http://www.sedema.df.gob.mx/sedema/index.php/verificacion-hoy-no-circula/hoy-no-circula/exenciones',
                body: '<p>Están exentos del Programa Hoy No Circula los autos:</p>
<ol>
<li>Con holograma <strong>exento</strong>, <strong>doble cero</strong> o <strong>cero</strong>, obtenido como parte del proceso de verificación vehicular.</li>
<li>Que utilicen fuentes de energías no contaminantes o que no emitan contaminantes derivados de la combustión.</li>
<li>Servicios de emergencia, médicos, seguridad pública, bomberos, rescate, protección civil y servicios urbanos.</li>
<li>Cortejos fúnebres en servicio.</li>
<li>Transporte escolar con el permiso o autorización.</li>
<li>Conducidos por personas con discapacidad, con las placas de matrícula de identificación, distintivo o autorización.</li>
<li>De emergencia médica y cuenten con la autorización.</li>
<li>Servicio público federal de transporte de pasajeros con la autorización.</li>
<li>Cuando portan un distintivo o permiso especial otorgado por la Secretaría porque participan en alguno de los Programas especiales de Fuentes Móviles.</li>
<li>Cuando eres foráneo, vienes de vacaciones y portas un <a href="www.paseturistico.df.gob.mx">Pase Turístico</a> vigente otorgado por la Secretaría del Medio Ambiente.</li>
<li>Los tractores agrícolas, la maquinaria dedicada a las industrias de la construcción y minera, las motocicletas, los vehículos eléctricos, los vehículos con matrícula de auto antiguo y/o clásico, automotores con matrícula de demostración y/o traslado.</li>
</ol>' })

# 12
Answer.create({ category_id: 2, contact_id: 3, related_1_id: 15, related_2_id: 14, related_3_id: 10,
                title: 'Denuncia de abuso por policías de tránsito', url: 'denuncias-policias-transito',
                source: 'http://www.sedema.df.gob.mx/sedema/index.php/verificacion-hoy-no-circula/verificacion-vehicular/denuncia',
                body: '<p class="lead">En caso de algún abuso por personal de tránsito del Distrito Federal puede llamar a la Secretaría de Seguridad Pública, Dirección General de Inspección Policiaca, teléfono 01 (55) 5242 5000 extensiones 1120, 1121, 1122 y 1171.</p>'})

# 13
Answer.create({ category_id: 2, contact_id: 1, related_1_id: 15, related_2_id: 14, related_3_id: 12,
                title: 'Sanciones', url: 'sanciones-hoy-no-circula',
                source: 'http://www.sedema.df.gob.mx/sedema/index.php/verificacion-hoy-no-circula/hoy-no-circula/sanciones',
                body: '<p class="lead">Los vehículos y conductores de fuentes móviles o vehículos que circulen en las vialidades y calles de la Ciudad de México que infrinjan las medidas previstas en este Programa, se harán acreedores a las sanciones establecidas en el Reglamento de la Ley Ambiental del Distrito Federal en Materia de Verificación Vehicular; así como, en el Reglamento de Tránsito Metropolitano o el que le sustituya y demás disposiciones aplicables, sin perjuicio de que sean retirados de circulación y remitidos al depósito vehicular, en el que deberán permanecer hasta que se pague la multa correspondiente, y en el caso de los vehículos detenidos durante Contingencia Ambiental, también habrá que esperar a que la misma concluya.</p>
<p>El Reglamento de la Ley Ambiental del Distrito Federal en Materia de Verificación Vehicular establece:</p>
<p><em>... Artículo 45. -La multa por circular con vehículos automotores en un día que tengan restringida la circulación conforme a lo dispuesto en la Ley, en este Reglamento, en acuerdos, programas o cualquier otra disposición jurídica aplicable, será de 24 días de Salario Mínimo vigente en el Distrito Federal. ...</em></p>

<p>Reglamento de Tránsito Metropolitano del Distrito Federal, que a la letra dice:</p>

<p><em>... Artículo 7. - Los conductores deberán acatar los programas ambientales y no circular en vehículos que tengan restricciones, los días y horas correspondientes. ...</em></p>
<p><em>.. a). Sanción con multa equivalente en días del salario mínimo general vigente en el Distrito Federal 20 días y remisión del vehículo al depósito ...</em></p>'})

# 14
Answer.create({ category_id: 2, contact_id: 1, related_1_id: 15, related_2_id: 13, related_3_id: 12,
                title: 'Calendario', url: 'calendario-hoy-no-circula',
                source: 'http://www.sedema.df.gob.mx/sedema/index.php/verificacion-hoy-no-circula/hoy-no-circula/calendario-del-programa-hoy-no-circula',
                body: '<p><img class="img-responsive" src="http://www.sedema.df.gob.mx/sedema/images/verificacion-hoy-no-circula/hoy-no-circula/calendario-hoy-nocircula_.jpg"></p>'})

# 15
Answer.create({ category_id: 2, contact_id: 1, related_1_id: 11, related_2_id: 13, related_3_id: 10, related_4_id: 12,
                title: 'Hologramas y limitaciones a la circulación', url: 'hologramas-hoy-no-circula',
                source: 'http://www.sedema.df.gob.mx/sedema/index.php/verificacion-hoy-no-circula/hoy-no-circula/en-que-consiste-el-programa-hoy-no-circula',
                body: '<p class="lead">Los hologramas a los que hace referencia el Programa Hoy no Circula, son los que se obtienen bajo los criterios del Programa de Verificación Vehicular Obligatorio Vigente en el Distrito Federal.</p>
<h4 class="title">Holograma exento, doble cero y cero</h4>
<p>La circulación de los autos que porten holograma <strong>exento</strong> o que hayan obtenido en el proceso de verificación vehicular el holograma <strong>doble cero</strong> o <strong>cero</strong>, quedarán exentos de todas las limitaciones establecidas en el Programa Hoy No Circula.</p>

<h4 class="title">Holograma uno</h4>
<p>La circulación de los autos que hayan obtenido en el proceso de verificación vehicular el holograma <strong>uno</strong>, se limita un día entre semana y dos sábados por cada mes, en un horario de las 05:00 a las 22:00 horas, con base en el último dígito numérico de su placa de acuerdo con la siguiente tabla:</p>
<table class="table table-bordered text-center">
<thead><tr><th class="text-center">Color del engomado</th><th class="text-center">Último dígito de la placa</th><th class="text-center" colspan="2">No pueden circular de las 5 a las 22 horas</th></tr>
</thead>
<tbody>
<tr><td bgcolor="#ffff66"><strong>Amarillo</strong></td><td>5 ó 6</td><td>lunes</td>
<td class="text-left" rowspan="5" style="vertical-align: middle;">
<p>Conforme al último dígito de la placa:</p>
<ul>
<li><p>Primer y tercer sábado de cada mes descansan números impares.</p></li>
<li><p>Segundo y cuarto sábado de cada mes descansan números pares.</p></li>
</ul>
</td>
</tr>
<tr><td bgcolor="#ff99cc"><strong>Rosa</strong></td><td>7 u 8</td><td>martes</td></tr>
<tr><td bgcolor="#ff3333"><strong>Rojo</strong></td><td>3 ó 4</td><td>miércoles</td></tr>
<tr><td bgcolor="#339900"><strong>Verde</strong></td><td>1 ó 2</td><td>jueves</td></tr>
<tr><td bgcolor="#66ccff"><strong>Azul</strong></td><td>9 ó 0</td><td>viernes</td></tr>
</tbody>
</table>

<h4 class="title">Holograma dos</h4>
<p>La circulación de los autos  que hayan obtenido en el proceso de verificación vehicular el holograma <strong>dos</strong>, se limita un día entre semana, en un horario de las 05:00 a las 22:00 horas, con base en el último dígito de la placa, y todos los sábados sin importar su último dígito numérico, de acuerdo a la siguiente tabla:</p>
<table class="table table-bordered text-center">
<thead><tr><th class="text-center">Color del engomado</th><th class="text-center">Último dígito de la placa</th><th class="text-center" colspan="2">No pueden circular de las 5 a las 22 horas</th></tr>
</thead>
<tbody>
<tr><td bgcolor="#ffff66"><strong>Amarillo</strong></td><td>5 ó 6</td><td>lunes</td><td rowspan="5" style="vertical-align: middle;"><p>Todos los sábados</p></td></tr>
<tr><td bgcolor="#ff99cc"><strong>Rosa</strong></td><td>7 u 8</td><td>martes</td></tr>
<tr><td bgcolor="#ff3333"><strong>Rojo</strong></td><td>3 ó 4</td><td>miércoles</td></tr>
<tr><td bgcolor="#339900"><strong>Verde</strong></td><td>1 ó 2</td><td>jueves</td></tr>
<tr><td bgcolor="#66ccff"><strong>Azul</strong></td><td>9 ó 0</td><td>viernes</td></tr>
</tbody>
</table>'})
