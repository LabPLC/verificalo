# -*- coding: utf-8 -*-
require 'csv'
require 'i18n'
require 'database_cleaner'

DatabaseCleaner.clean_with :truncation, { only: ['admin_users',
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
                 phone: '5134 2380', phone_schedule: 'extensión 1690, 9 am a 5 pm',
                 email: 'contacto@sedema.df.gob.mx',
                 address: 'Av. Tlaxcoaque No. 8, Col. Centro Histórico, Distrito Federal',
                 address_schedule: '9 am a 4 pm', lat: '19.423219', lon: '-99.134159' })

# 1
Answer.create({ category_id: 1, contact_id: 1, related_1_id: 2, related_2_id: 3, related_3_id: 4, related_4_id: 7,
                title: '¿Qué es la verificación vehícular?', url: 'que-es-la-verificacion',
                body: '<p class="lead">Los vehículos son una de las fuentes más importantes de contaminantes del aire en la Ciudad de México, por eso la Secretaría del Medio Ambiente cuenta con un programa para asegurar que los vehículos que circulan en el Distrito Federal tienen la menor emisión posible de contaminantes, este programa se conoce como Programa de Verificación Vehicular. Además de asegurar una menor contaminación, fomenta también el mantenimiento preventivo y correctivo del vehículo. El programa es de carácter obligatorio para todos los autos matriculados en el Distrito Federal.</p>

<p>Los vehículos automotores registrados en el D.F. deberán realizar y aprobar una verificación de emisiones vehiculares cada semestre, salvo aquellos que obtengan un holograma doble cero (00), en cuyo caso la unidad estará exenta de verificar sus emisiones hasta por tres semestres posteriores al semestre en que obtuvo un holograma 00.</p><p class="lead">Los vehículos nuevos o usados que se registren por primera vez en el Distrito Federal deberán ser verificados dentro de los 180 días naturales contados a partir de la fecha de la tarjeta de circulación.</p>

<p>Los vehículos matriculados en el Distrito Federal que ya han sido verificados en sus emisiones vehiculares deberán continuar verificando conforme al color del engomado o al último dígito numérico de sus placas de circulación en los siguientes términos:</p>

<table class="table table-bordered">
<thead><tr><th colspan="2">&nbsp;</th><th colspan="2">Período para verificar</th></tr>
<tr><th>Color del engomado</th><th>Último dígito de la placa</th><th>1er semestre</th><th>2º semestre</th></tr></thead>
<tbody>
<tr><td bgcolor="#ffff66">Amarillo</td><td>5 ó 6</td><td>enero y febrero</td><td>julio y agosto</td></tr>
<tr><td bgcolor="#ff99cc">Rosa</td><td>7 ó 8</td><td>febrero y marzo</td><td>agosto y septiembre</td></tr>
<tr><td bgcolor="#ff3333">Rojo</td><td>3 ó 4</td><td>marzo y abril</td><td>septiembre y octubre</td></tr>
<tr><td bgcolor="#339900">Verde</td><td>1 ó 2</td><td>abril y mayo</td><td>octubre y noviembre</td></tr>
<tr><td bgcolor="#66ccff">Azul</td><td>9 ó 0</td><td>mayo y junio</td><td>noviembre y diciembre</td></tr>
</tbody></table>

<p>El proceso de verificación de emisiones vehiculares aplica a todos los automotores matriculados en el Distrito Federal y los que portan placas metropolitanas, con excepción de los tractores agrícolas, la maquinaria dedicada a las industrias de la construcción y minera, las motocicletas, los vehículos eléctricos, los vehículos con matrícula de auto antiguo, automotores con matrícula demostradora y aquellos cuya tecnología impida la aplicación de la Norma Oficial Mexicana correspondiente (algunos vehículos híbridos y unidades a gas natural con sistema de combustión empobrecida).</p>' })

# 2
Answer.create({ category_id: 1, contact_id: 1, related_1_id: 3, related_2_id: 4, related_3_id: 5,
                title: '¿Qué necesito para verificar mi auto?', url: 'que-necesito-para-verificar',
                body: '<p class="lead">Los documentos que deberá llevar y mostrar el propietario, poseedor o conductor del vehículo que se presenta a verificar, en original y copia simple (salvo la factura del auto, en cuyo caso y por seguridad sólo debe llevar copia simple), dejando copia simple en el Verificentro de cada documento requerido, de acuerdo a la siguiente tabla:</p>

<table class="table table-bordered">
<thead><tr><th>Requisitos</th><th>Verificación por 1a Vez en el DF</th><th>Verificación regular</th><th>Verificación con cambio de placa (baja y alta)</th><th>Verificación extemporánea</th><th>Verificación de vehículos a gas</th><th>Verificación con cambio convertidor catalítico</th><th>Verificaciones voluntarias</th></tr></thead>
<tbody>
<tr><td>Tarjeta de circulación</td><td>Si (indicando trámite 1 ó 2)</td><td>Si</td><td>Si</td><td>Si</td><td>Si</td><td>Si</td><td>Si</td></tr>
<tr><td>Copia Factura y/o contrato de arrendamiento</td><td>Sólo si es nuevo y requiere 00 por 1ª, 2ª o 3ª ocasión</td><td>-</td><td>Sólo si es nuevo y requiere 00 por 1ª, 2ª o 3ª ocasión</td><td>Sólo si es nuevo y requiere 00 por 1ª, 2ª o 3ª ocasión</td><td>Sólo usa gas de origen (agencia)</td><td>-</td><td>Sólo si es nuevo y requiere 00 por 1ª, 2ª o 3ª ocasión</td></tr>
<tr><td>Constancia de verificación próxima anterior</td><td>-</td><td>Si</td><td>Sólo si tiene registro previo en el DF</td><td>-</td><td>Si</td><td>Si (rechazo)</td><td>-</td></tr>
<tr><td>Multa por verificación extemporánea</td><td colspan="7">Sólo si venció periodo de verificación y/o 180 días naturales<br /> (Obtener Formato Universal para pagar la multa por verificación extemporánea, Clave 50, en <a href="http://www.finanzas.df.gob.mx/formato_lc/conceptos.php" target="_blank">http://www.finanzas.df.gob.mx/formato_lc/conceptos.php</a>)</td>
</tr>
<tr><td>Baja por cambio de placa</td><td>Sólo si proviene de otra entidad</td><td>-</td><td>Si</td><td>-</td><td>Sólo si realizó cambio de placa</td><td>Sólo si realizó cambio de placa</td><td>-</td></tr>
<tr><td>Sustitución</td><td>Sólo si es taxi</td><td>-</td><td>Sólo si es taxi</td><td>-</td><td>Sólo si es taxi</td><td>-</td><td>-</td></tr>
<tr><td>Autorización DGGCA uso Gas LP</td><td>Sólo si usa gas y requiere holograma 0</td><td>Sólo si usa gas y requiere holograma 0</td><td>Sólo si usa gas y requiere holograma 0</td><td>Solo si usa gas y requiere holograma 0</td><td>Sólo si requiere holograma 0</td><td>-</td><td>-</td></tr>
<tr><td>Garantía cambio convertidor</td><td>-</td><td>Sólo si presenta rechazo PIREC</td><td>Sólo si presenta rechazo PIREC</td><td>Sólo si deriva de rechazo PIREC</td><td>-</td><td>Si</td><td>Sólo si deriva de rechazo PIREC</td></tr>
</tbody>
</table>

<p>Todos los casos requieren el no adeudo de infracciones y tenencias para lo cual se podrá realizar la consulta correspondiente en: <a href="http://www.finanzas.df.gob.mx/sma/consulta_ciudadana.php" target="_blank">http://www.finanzas.df.gob.mx/sma/consulta_ciudadana.php</a> para infracciones y <a href="http://www.finanzas.df.gob.mx/consultas_pagos/consulta_adeudosten.php" target="_blank">http://www.finanzas.df.gob.mx/consultas_pagos/consulta_adeudosten.php</a> para tenencias. Consultas que serán validadas por el Verificentro cuando el vehículo se presente a verificar.</p>

<p>En caso de no presentar la constancia de verificación vehicular, la unidad podrá ser verificada siempre y cuando el equipo GDF09 presente en pantalla la verificación vehicular de su período inmediato anterior).</p>

<p>En caso de que no exista el registro de la verificación vehicular anterior en la base de datos, el vehículo no podrá verificar hasta que no se pague una multa por verificación extemporánea.</p>

<p>Si el ciudadano tiene el certificado de su verificación vehicular anterior, deberá presentarse en el Módulo de Atención Ciudadana de la Dirección General de Gestión de la Calidad del Aire de la Secretaría del Medio Ambiente del Gobierno del Distrito Federal “DGGCA”, ubicada en Tlaxcoaque número 8, Planta Baja, Colonia Centro, Delegación Cuauhtémoc, C.P. 06090, México, Distrito Federal, en el horario comprendido entre las 9:00 y las 14:00 horas de lunes a viernes, en donde se corroborará la realización de la verificación de emisiones vehiculares y, de ser el caso, se realizarán las acciones correspondientes para que el vehículo sea verificado.</p>

<p>En el caso de los vehículos sancionados dentro del Programa de Vehículos Contaminantes, se deberán presentar los documentos definidos a lo largo del numeral 13 del Programa de Verificación Vehicular vigente.<br /><br /><a href="http://www.consejeria.df.gob.mx/portal_old/uploads/gacetas/52bf9eb19f707.pdf" target="_blank" title="Gaceta Oficial del Distrito Federal">Consulta aquí el Programa de Verificación Vehicular Obligatorio del Primer Semestre 2014</a></p>' })

# 3
Answer.create({ category_id: 1, contact_id: 1,  related_1_id: 2, related_3_id: 4, related_4_id: 8,
                title: '¿Donde puedo verificar mi auto?', url: 'verificentros',
                body: 'Verificentros de la Ciudad de México por delegación o cercanos donde puede verificar su auto' })

# 4
Answer.create({ category_id: 1, contact_id: 1, related_1_id: 1, related_2_id: 2, related_3_id: 3,
                title: '¿Cuál es el costo de la verificación?', url: 'cuanto-cuesta-verificacion',
                body: '<p class="lead">Para el segundo semestre de 2013, el costo por los servicios de verificación vehicular es de $383.00 para todo tipo de Constancia de Verificación (00, 0, 2, Rechazo y Evaluación Técnica) que se entregue al usuario.</p>

<p>Las verificaciones pares serán gratuitas cuando la verificación non que les antecede sea un rechazo vehicular, siempre y cuando la verificación par se realice en el mismo Verificentro en que se obtuvo el rechazo vehicular. La gratuidad excluye el pago por verificación extemporánea.</p>

<p>La oportunidad de una siguiente verificación gratuita no será aplicable en el caso de verificaciones practicadas en los últimos siete días naturales del período de verificación del automotor.</p>

<p>La tarifa por la expedición de las reposiciones de Constancias de Verificación (holograma y/o certificado), será la que establezca el Código Fiscal del Distrito Federal.</p>

<p>La multa por verificación extemporánea tiene un costo de 20 Días de Salario Mínimo General Vigente. Para el segundo semestre de 2013 es de: $1295.00.</p>

<p><strong>La vigencia del pago de la multa es de 30 días naturales a partir del pago de la misma, siendo el tiempo que se tiene para poder realizar y aprobar la verificación vehicular del automotor.</strong></p>

<p>Antes de pagar su multa por verificación extemporánea, asegúrese de no tener adeudos de tenencia y/o infracciones de tránsito, con el objeto de evitar que se venza la vigencia del pago de su multa y que tenga la obligación de volver a pagarla.</p>'})

# 5
Answer.create({ category_id: 1, contact_id: 1, related_1_id: 2, related_2_id: 3,
                title: 'Mi pago de adeudos NO aparece', url: 'mi-pago-no-aparece',
                body: '<p class="lead">Los propietarios o poseedores de los vehículos que no hayan sido verificados en su periodo de verificación debido a falta de actualización oportuna de pagos de tenencias o infracciones al Reglamento de Tránsito Metropolitano, en el sistema de consulta de la Secretaría de Finanzas, se les permitirá verificar sus emisiones sin el pago de multa por verificación extemporánea, siempre y cuando tramiten y les sea autorizada la condonación del pago por parte de la Secretaría de Finanzas del Gobierno del Distrito Federal, de acuerdo a lo siguiente:</p>

<ol>
<li>Cuando el propietario o poseedor del automotor haya acudido a realizar su trámite de corrección o aclaración de pagos ante alguna Administración Tributaria o Administración Auxiliar dentro del período de verificación correspondiente, y no hubiese podido realizar la verificación de emisiones por falta de actualización del sistema de consulta de adeudos que opera la Secretaría de Finanzas, se deberá acudir a cualquier Administración Tributaria o Administración Auxiliar y expresar en el formato denominado “volante de aclaraciones” o en escrito libre, el motivo del trámite de corrección o aclaración de pagos, debiendo presentar en original y copia:<ol>
<li>El pago sujeto a aclaración o corrección</li>
<li>Tarjeta de circulación</li>
<li>Identificación del contribuyente (en caso de representación, el documento con el que se acredite personalidad)</li>
</ol></li>
<li>Cuando el propietario o poseedor del automotor haya realizado algún pago de infracciones y/o tenencia en el último día del período correspondiente de verificación vehicular, deberá acudir a cualquier Administración Tributaria o Administración auxiliar y expresar en el formato denominado “volante de aclaraciones” o en escrito libre, el motivo del trámite de corrección o aclaración de pagos, debiendo presentar en original y copia los mismos documentos establecidos en los incisos 1), 2) y 3).</li>
</ol>

<p>Posterior a la realización de este trámite, el propietario o poseedor de la unidad deberá acudir al Módulo de Atención Ciudadana de la “DGGCA”, ubicada en Tlaxcoaque número 8, Planta Baja, Colonia Centro, Delegación Cuauhtémoc, C.P. 06090, México, Distrito Federal, para obtener un oficio que le permita circular para poder llevar su unidad a verificar y para que se libere del adeudo al vehículo registrado en los equipos de verificación de emisiones vehiculares. Este oficio se entregará sólo si en el sistema de consulta de la Secretaría de Finanzas se muestra la leyenda “Permitir Verificar”, con lo cual el vehículo podrá ser verificado sin el pago de multa por verificación vehicular extemporánea.</p>'})

# 6
Answer.create({ category_id: 1, contact_id: 1, related_1_id: 1, related_2_id: 2, related_3_id: 3,
                title: '¿Vigencia del holograma doble cero?', url: 'vigencia-doble-cero',
                body: '<p>La constancia de verificación en su tipo doble cero podrá otorgarse a:</p>
<ol>
<li>Unidades híbridas (gasolina – electricidad) de cualquier modelo y renovarlo hasta en dos ocasiones.</li>
<li>Unidades a gasolina modelos 2007 a 2010 y renovarlo hasta en dos ocasiones, siempre y cuando cumplan con los requisitos establecidos al respecto.</li>
<li>Unidades nuevas a gasolina modelo 2011 y posteriores, por una sola ocasión,</li>
</ol>

<p>La vigencia de cada holograma 00 que se otorgue se calculará a partir de la fecha de adquisición de la unidad, misma que se obtendrá de la factura, carta factura de la unidad o contrato de arrendamiento.</p>

<p>Los vehículos que porten holograma 00 cuya vigencia llegue a su término durante el Programa de Verificación en curso, mantendrán el beneficio de exención a las restricciones a la circulación establecidas en el Programa “Hoy No Circula”, en tanto realizan su próxima verificación (haya ocurrido o no un cambio de matrícula) de conformidad con lo siguiente:</p>

<ol>
<li>Si la vigencia del holograma 00 culmina en el periodo de verificación correspondiente a la terminación de la placa del vehículo, deberá verificar en dicho periodo, pudiendo hacerlo desde el primero hasta el último día de su periodo, aún si la vigencia del holograma no ha concluido.</li>
<li>Si el período de verificación al que corresponden las placas ha concluido o no ha iniciado, deberán verificar desde el día siguiente de vencimiento de su holograma y hasta el último día de su período próximo inmediato de verificación vehicular de acuerdo a la terminación de su placa.</li>
</ol>

<p><a href="/sedema/images/archivos/verificacion-hoy-no-circula/verificacion-vehicular/listado-vehiculos-holograma-00.pdf" target="_blank">Listado de vehículos que pueden obtener el holograma “00” por más de una ocasión</a></p>'})

# 7
Answer.create({ category_id: 1, contact_id: 1, related_1_id: 1, related_2_id: 2,
                title: 'Autos exentos de la verificación', url: 'vehiculos-exentos-verificacion',
                body: '<p class="lead">Vehículos exentos del Programa de Verificación Vehicular y del Acuerdo que Establece las Medidas para Limitar la Circulación de Vehículos Automotores en las en las Vialidades del Distrito Federal, para Controlar y Reducir la Contaminación Atmosférica y Contingencias Ambientales conocido como “Programa Hoy No Circula”:</td>
<table class="table table-bordered">
<thead><tr><th>Marca</th><th>Submarca</th></tr></thead>
<tbody>
<tr><td>Hyundai</td><td>Blue City Hibrido (CNG-eléctrico)</td></tr>
<tr><td>Hyundai</td><td>HD 120 (GNC)</td></tr>
<tr><td>Hyundai</td><td>Super Aero City (GNC)</td></tr>
<tr><td>Toyota</td><td>Prius (eléctrico-gasolina)</td></tr>
<tr><td>Vehizero</td><td>Ecco C (eléctrico-gasolina)</td></tr>
<tr><td>Nissan</td><td>Leaf (eléctrico)</td></tr>
<tr class="alt"><td>BMW</td><td>ActiveHybrid 5 (eléctrico-gasolina)</td></tr>
<tr><td>BMW</td><td>X6 ActiveHybrid (eléctrico-gasolina)</td></tr>
<tr class="alt"><td>BMW</td><td>Serie 3 active hibrid</td></tr>
<tr><td>BMW</td><td>Mini E</td></tr>
<tr class="alt"><td>Porsche</td><td>Cayene hibrido V6 3.0</td></tr>
<tr><td>Porsche</td><td>Touareg hibrido V6 3.0</td></tr>
</tbody>
</table>'})

# 8
Answer.create({ category_id: 1, contact_id: 1, related_1_id: 2, related_2_id: 3,
                title: 'Convertidor catalítico en mal estado', url: 'rechazo-convertidor-catalitico',
                body: '<p class="lead">Durante la prueba de verificación se evalúa la eficiencia del convertidor catalítico mediante la lectura de los gases de escape, generándose un rechazo en aquellas unidades de pasajeros de uso particular modelos 1991 a 2003 o de transporte público, mercantil y privado de carga, y transporte público de pasajeros modelos 1991 a 2006, cuyos convertidores catalíticos hayan perdido eficiencia en la conversión.</p>

<p>La constancia de verificación no aprobatoria que se entregue deberá contener la leyenda: “Falla en la eficiencia del convertidor catalítico, debe acudir a un Taller PIREC autorizado y ubicado en el Distrito Federal o a una agencia automotriz a cambiar este dispositivo anticontaminante, así como a realizar el diagnóstico y las reparaciones necesarias al motor de su vehículo”.</p>

<p>El usuario NO podrá verificar nuevamente, hasta haber realizado el cambio del convertidor catalítico y, en su caso, reparación o afinación de su unidad, toda vez que un convertidor catalítico puede fallar por que se haya cumplido su vida útil o debido a problemas eléctricos y/o mecánicos del vehículo que lo hayan afectado.</p>

<p>Posterior a la reparación, el Taller o Agencia debe entregar al usuario la garantía del convertidor catalítico y de las reparaciones realizadas. Con estos elementos se podrá acudir nuevamente al Verificentro y realizar la verificación correspondiente cuyo resultado definirá el tipo de holograma que obtendrá.</p>

<p>El PIREC se ha creado para propiciar la sustitución del convertidor catalítico inoperante y el mantenimiento del motor de tu vehículo. De esta forma se reduce la contaminación protegiendo tu salud y la de tus hijos.</p>

<ul>
<li>Amigo automovilista, si has recibido un certificado de rechazo PIREC, tu convertidor catalítico ha dejado de operar, con lo que tu unidad por lo menos ha duplicado sus emisiones contaminantes.</li>
<li>Por lo anterior, en caso de haber recibido un certificado de rechazo PIREC:<ol type="a">
<li>No atiendas recomendaciones de coyotes o pre verificadores, toda vez que los documentos resultantes que obtengas, pueden ser falsos o robados, en cuyo caso quedarás involucrado en un problema legal.</li>
<li>Evita obtener de forma fraudulenta tu certificado de verificación ya que los datos de tu vehículo quedan grabados en una base de datos, por lo que cualquier alteración en el procedimiento quedará registrada, y tu vehículo podrá ser detenido en la calle, o bien durante el próximo semestre no podrá ser verificado hasta atender el trámite correspondiente.</li>
<li>Asiste sólo a los Talleres Autorizados PIREC, mismos que se encuentran distribuidos en la Ciudad de México.</li>
</ol></li>
</ul>

<p>Si en la prueba de verificación correspondiente obtuviste un rechazo por falla en la eficiencia del convertidor catalítico, el Taller Autorizado PIREC deberá:</p>
<ul>
<li>Realizar un diagnóstico del estado mecánico del vehículo, con el fin de detectar las causas que motivaron que el convertidor catalítico dejara de operar eficientemente.</li>
<li>Llevar a cabo las reparaciones del motor que sean necesarias, para asegurar el buen funcionamiento del mismo, así como cambiar el convertidor catalítico.</li>
<li>Otorgar, por escrito el diagnóstico y las reparaciones realizadas al motor de tu vehículo, así como entregar la póliza de garantía del convertidor catalítico.</li>
</ul>

<p><strong>Recuerda:</strong></p>
<ul>
<li>Una buena reparación y mantenimiento periódico garantiza el buen estado del vehículo.</li>
<li>Un convertidor catalítico nunca debe fallar; si esto ocurre, entonces existe un problema.</li>
<li>En caso de ser rechazado o no obtener el holograma máximo permitido para tu vehículo, regresar al Taller Autorizado PIREC para reclamar la garantía.</li>
<li>Solo reemplazar el convertidor catalítico no resuelve el problema, se requiere revisar y en su caso reparar el motor.</li>
</ul>'})

# 9
Answer.create({ category_id: 2, contact_id: 1, related_1_id: 10, related_2_id: 11, related_3_id: 12,
                title: '¿En qué consiste el Hoy No Circula?', url: 'que-es-hoy-no-circula',
                body: '<p class="lead">Dentro del parque vehicular que circula en la ciudad existen vehículos cuya tecnología o estado mecánico ya no permite garantizar un mínimo de emisiones contaminantes. El porcentaje de este tipo de vehículos disminuye año con año, sin embargo, para evitar que estos vehículos tengan un impacto significativo en la calidad del aire, se limita su circulación una vez a la semana de lunes a viernes y un sábado de cada mes, este programa se conoce como Hoy No Circula. En el caso de los vehículos que provienen de otros estados o del extranjero, no es posible conocer con certidumbre los niveles de emisión por lo tanto, se incluyen dentro del programa Hoy No Circula.</p>
<p>Los vehículos de combustión interna matriculados en el Distrito Federal o Estado de México que porten holograma 2 deben dejar de circular de lunes a sábado de las 5:00 a las 22:00 horas, con base en el último dígito numérico de la placa de matrícula y/o del color de la calcomanía de circulación permanente (engomado), con excepción del transporte local público de pasajeros cuya restricción será de las 10:00 a las 22:00 horas.</p>

<p>La restricción aplica de acuerdo a lo establecido en la siguiente tabla:</p>

<table class="table table-bordered">
<thead><tr><th>Día</th><th>Limitación de la circulación</th></tr></thead>
<tbody>
<tr><td>Lunes</td><td>Amarillo* (5 y 6)**</td></tr>
<tr><td>Martes</td><td>Rosa* (7 y 8)**</td></tr>
<tr><td>Miércoles</td><td>Rojo* (3 y 4)**</td></tr>
<tr><td>Jueves</td><td>Verde* (1 y 2)**</td></tr>
<tr><td>Viernes</td><td>Azul* (9, 0, matrículas que carecen de números o automotores con permisos de circulación)</td></tr>
<tr><td>Sábado</td><td>El segundo sábado de cada mes los vehículos con engomado color rosa y terminación de placas 7 y 8;<br /> El tercer sábado de cada mes los vehículos con engomado color rojo y terminación de placas 3 y 4;<br /> El cuarto sábado de cada mes los vehículos con engomado color verde terminación de placas 1 y 2; y<br /> El quinto sábado, en aquellos meses que lo contengan, los vehículos con engomado color azul y terminación de placas 9 y 0, así como matrículas que carecen de números o automotores con permisos de circulación.</td></tr>
</tbody>
</table>

<p>* Último dígito numérico de la placa de matrícula.</p>
<p>** Color del engomado que contiene el número de la matrícula.</p>' })

# 10
Answer.create({ category_id: 2, contact_id: 1, related_1_id: 12, related_2_id: 9,
                title: 'El Hoy No Circula y autos de otros estados', url: 'autos-otros-estados',
                body: '<p class="lead">Los vehículos de combustión interna con placas del extranjero o de un estado que no sea el Distrito Federal o el Estado de México deben dejar de circular de lunes a sábado de las 5:00 a las 22:00 horas, con base en el último dígito numérico de la placa de matrícula y/o del color de la calcomanía de circulación permanente (engomado). La restricción aplica de acuerdo a lo establecido en la siguiente tabla:</p>

<table class="table table-bordered">
<thead><tr><th>Día</th><th>Limitación de la circulación</th></tr></thead>
<tbody>
<tr><td>Lunes</td><td>Amarillo* (5 y 6)**</td></tr>
<tr><td>Martes</td><td>Rosa* (7 y 8)**</td></tr>
<tr><td>Miércoles</td><td>Rojo* (3 y 4)**</td></tr>
<tr><td>Jueves</td><td>Verde* (1 y 2)**</td></tr>
<tr><td>Viernes</td><td>Azul* (9, 0, matrículas que carecen de números o automotores con permisos de circulación)</td></tr>
<tr><td>Sábado</td><td>El primer sábado de cada mes los vehículos con engomado color amarillo y terminación de placas 5 y 6;<br /> El segundo sábado de cada mes los vehículos con engomado color rosa y terminación de placas 7 y 8;<br /> El tercer sábado de cada mes los vehículos con engomado color rojo y terminación de placas 3 y 4;<br /> El cuarto sábado de cada mes los vehículos con engomado color verde terminación de placas 1 y 2; y<br /> El quinto sábado, en aquellos meses que lo contengan, los vehículos con engomado color azul y terminación de placas 9 y 0, así como matrículas que carecen de números o automotores con permisos de circulación.</td></tr>
</tbody>
</table>

<p>* Color del engomado que contiene el número de la matrícula.</p>
<p>** Último dígito numérico de la placa de matrícula.</p>

<p>Además, las unidades de servicio particular y unidades ligeras de carga (automóviles, camionetas tipo van y pick up), deben dejar de circular de lunes a viernes en el horario comprendido entre las 05:00 a las 11:00 horas. (Están exentas de esta restricción las unidades conocidas como 350 o tres y media toneladas).</p>

<p>Por ejemplo: un vehículo de uso particular proveniente de Aguascalientes cuyo último dígito numérico sea “6”, deberá dejar de circular los lunes de cada semana y el primer sábado de cada mes de las 05:00 a las 22:00 horas; asimismo deberá dejar de circular de martes a viernes de cada semana de las 05:00 a las 11:00 horas.</p>'})

# 11
Answer.create({ category_id: 2, contact_id: 1, related_1_id: 9, related_2_id: 10, related_3_id: 12,
                title: 'Autos exentos del Hoy No Circula', url: 'vehiculos-extenos-hoy-no-circula',
                body: '<p class="lead">Están exentos del Programa Hoy No Circula:</p>
<ol>
<li>Los vehículos que obtengan un holograma vigente “00” ó “0” como resultado de la realización de una prueba de verificación vehicular en el Distrito Federal o en los Centros de Verificación de entidades reconocidas por la Secretaría del Medio Ambiente del Gobierno del Distrito Federal (estas entidades son: Estado de México, Guanajuato, Hidalgo, Querétaro, Puebla, Morelos, Michoacán y Tlaxcala).</li>
<li>Las motocicletas de cualquier tipo en tanto existan Normas Oficiales Mexicanas aplicables a estos automotores.</li>
<li>Los vehículos que porten la matrícula de vehículo antiguo emitida por alguna autoridad competente.</li>
<li>Los vehículos que transporten o sean conducidos por personas con discapacidad y que además cuenten con las placas para vehículos de personas con discapacidad, o porten el documento o autorización que para tal efecto expida la autoridad correspondiente.</li>
<li>Los vehículos destinados a servicios médicos, seguridad pública, bomberos, rescate y protección civil, servicios urbanos, servicio público federal de transporte de pasajeros, unidades de cualquier tipo que atiendan alguna emergencia médica, así como los vehículos que la Secretaría del Medio Ambiente del Gobierno del Distrito Federal determine a través del establecimiento de programas o convenios, mediante los cuales se reduzcan sus niveles de emisión, y los vehículos que por su peso y dimensiones estén imposibilitados de verificar (tractores agrícolas, la maquinaria dedicada a las industrias de la construcción y minera).</li>
<li>Los vehículos que porten placas de demostración.</li>
<li>Los vehículos destinados a prestar el servicio de transporte escolar que cuenten con la autorización de la autoridad correspondiente, o bien aquellos autobuses propiedad de instituciones académicas que presten el servicio de transporte de alumnos o personal.</li>
<li>Los vehículos de procedencia extranjera o los matriculados en entidades federativas distintas al Distrito Federal y Estado de México que circulen portando un Pase Turístico vigente otorgado por la Secretaría del Medio Ambiente del Gobierno del Distrito Federal (<a href="http://www.paseturistico.df.gob.mx/" target="_blank">www.paseturistico.df.gob.mx</a>).</li>
<li>Los vehículos cuya tecnología impida la aplicación de la Norma Oficial Mexicana correspondiente (algunos vehículos híbridos y unidades a gas natural que operan con mezclas aire – combustible empobrecidas, revisar las submarcas exentas en la sección <a href="http://www.sedema.df.gob.mx/index.php/verificacion-hoy-no-circula/verificacion-vehicular" target="_blank"><em>Verificación vehicular</em></a>), no importando la entidad federativa en donde fue registrado el automotor.</li>
<li>Automotores que no emitan contaminantes derivados de la combustión, tales como los que utilizan energía solar, eléctrica, entre otros.</li>
<li>Los automotores registrados en el Distrito Federal que hayan realizado un cambio de matrícula y porten algún holograma vigente de los tipos “00” ó “0” obtenido con la matrícula anterior.</li>
</ol>
<p>Los vehículos de procedencia extranjera o los matriculados en entidades federativas distintas al Distrito Federal y Estado de México que obtengan un holograma “2” como resultado de la realización de una prueba de verificación vehicular en Centros de Verificación del Distrito Federal, del Estado de México o de Centros de Verificación de entidades reconocidas por la Secretaría del Medio Ambiente del Gobierno del Distrito Federal, de conformidad con los criterios establecidos en el presente Programa, quedarán exentos de la restricción a la circulación, solamente, en los días en que les aplica la restricción de las 5:00 a las 11:00 horas (siempre y cuando no esté declarada una Precontingencia o Contingencia Ambiental).</p>' })

# 12
Answer.create({ category_id: 2, contact_id: 1, related_1_id: 9, related_2_id: 10,
                title: '¿Qué es el Pase Turístico?', url: 'pase-turistico',
                body: '<p class="lead">Para los vehículos con placas de algún Estado (sin incluir a los matriculados en el D.F. y el Estado de México) o del extranjero existe la posibilidad de obtener un “Pase Turístico Metropolitano” que les permite circular todos los días a cualquier hora durante la vigencia del documento, en vialidades del Distrito Federal y del Estado de México.</p>

<p>El Pase se otorga de manera gratuita, pudiendo obtenerse un Pase Turístico Metropolitano por 7 días continuos (2 veces al semestre) o por 14 días continuos (una vez al semestre).</p>

<p>Para obtenerlo deberá entrar a la página de Pase Turístico a través del portal electrónico de la Secretaría del Medio Ambiente del DF http://www.paseturistico.df.gob.mx/pasetur/. Es necesario que cuente con una dirección de correo electrónico personal, evitando utilizar cuentas de Hotmail o Live ya que este tipo de cuentas no permite que se reciban correos del Sistema de Pase Turístico; asimismo deberá tener a la mano la tarjeta de circulación de su vehículo.</p>

<p>El procedimiento para tramitar un Pase Turístico es el siguiente:</p>

<ul>
<li>Entrar a la página de Pase Turístico - <a href="http://www.paseturistico.df.gob.mx/" target="_blank">www.paseturistico.df.gob.mx</a></li>
<li>Iniciar su registro al capturar su correo electrónico</li>
<li>El Sistema de Pase Turístico le enviará un correo con una dirección electrónica a su correo registrado</li>
<li>Ingresar a la liga electrónica y llenar el registro con sus datos generales. Cuando envíe esta información, el Sistema le enviará a su vez otro correo (a su correo registrado) con una clave de acceso</li>
<li>Con su correo electrónico y su clave de acceso podrá ingresar al Sistema</li>
<li>En la pestaña de Registro de Automóviles deberá registrar los datos de su vehículo que se encuentran en la tarjeta de circulación. Al capturar la placa solo utilizar números y letras, sin dejar espacios en blanco.</li>
<li>Cuando haya registrado los datos de su vehículo podrá generar su Pase, indicando si lo requiere por 7 ó 14 días. Es necesario considerar la fecha en que el vehículo circulará en algún municipio de la Zona Metropolitana del Valle de México, para que el periodo del pase contemple esta fecha.</li>
<li>Con los datos ingresados al sistema se generarán dos pases turísticos, uno emitido por el Distrito Federal y otro por el Estado de México.</li>
<li>Una vez tramitado el Pase, lo deberá imprimir (los dos oficios generados) y pegarlos en un lugar visible en el vehículo durante el periodo de vigencia de los mismos.</li>
</ul>' })
