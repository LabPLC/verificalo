Verifícalo
==========

[![Build Status](https://travis-ci.org/LabPLC/verificalo.svg?branch=master)](https://travis-ci.org/LabPLC/verificalo)
[![Dependency Status](https://gemnasium.com/LabPLC/verificalo.svg)](https://gemnasium.com/LabPLC/verificalo)
[![Coverage Status](https://coveralls.io/repos/LabPLC/verificalo/badge.png?branch=master)](https://coveralls.io/r/LabPLC/verificalo?branch=master)
[![Code Climate](https://codeclimate.com/github/LabPLC/verificalo.png)](https://codeclimate.com/github/LabPLC/verificalo)

Sitio web para responsabilizar a los automovilistas particulares de la
CDMX sobre sus obligaciones y el impacto del auto buscando fomentar el
uso inteligente de este medio de transporte.

Las obligaciones de los automovilistas particulares son aprobar la
prueba de emisiones contaminantes (verificación), respetar el hoy no
circula y pagar sus tenencias e infracciones. Buscamos responsabilizar
a los ciudadanos sobre sus obligaciones con un punto de contacto único
para informarse y recordarles vía correo electrónico, celular o
teléfono sobre estas obligaciones.

La principal fuente de contaminantes en la CDMX es el transporte y el
impacto del auto particular es que de todos los medios de transporte es
el mas contaminante ya que traslada un número limitado de pasajeros y
sus emisiones por km-pasajero son 5 veces mayores que un Microbus y
15 veces mayores que un Metrobus. Buscamos responsabilizar a los
ciudadanos sobre su impacto con una calculadora de emisiones
contaminantes.

El uso inteligente del auto significa utilizar transporte público en
nuestros trayectos rutinarios a hora pico (casa-trabajo) y solo
utilizar el auto para viajes en los se vaya a una velocidad regular
para consumir menos combustible. Buscamos fomentar el uso inteligente
del auto presentando al usuario las posibles alternativas al auto en un
solo lugar.

Características
---------------

- Consulta por placa de auto:
  - Vigencia de verificación
  - Próximo periodo para verificar
  - Adeudos de infracciones
  - Adeudos de tenencias
  - Hoy no circula

- Notificaciones por correo electrónico o llamada telefónica:
  - Recordatorio antes y durante el periodo para verificar
  - Aviso de nuevos adeudos por infracciones o tenencias
  - Recordatorio mensual de adeudos pendientes
  - Recordatorio del hoy no circula semanal o sabatino

- Respuestas:
  - Verificentros por delegación
  - Verificentros mas cercanos por colonia o código postal

### Capturas de pantalla

#### Página de inicio
![Página de inicio](/doc/img/screenshoot-1.jpg?raw=true "Página de inicio")
#### Consulta por placa
![Consulta por placa](/doc/img/screenshoot-2.jpg?raw=true "Consulta por placa")
#### Suscripción a notificaciones
![Suscripción a notificaciones](/doc/img/screenshoot-3.jpg?raw=true "Suscripción a notificaciones")
#### Respuestas
![Donde llevar su auto a verificar](/doc/img/screenshoot-4.jpg?raw=true "Donde llevar su auto a verificar")
#### Busqueda de verificentros
![Verificentros más cercanos](/doc/img/screenshoot-5.jpg?raw=true "Verificentros más cercanos")

Datos Abiertos
--------------

Verificalo es posible gracias a los datos y API del [Laboratorio de
Datos](http://datos.labplc.mx), especificamente:

- [API de Vehículos](http://datos.labplc.mx/movilidad/vehiculos.info)
- [Datos de Verificentros](http://datos.labplc.mx/datasets/view/verificentros)

Contibuye
---------

Verificalo es [Software
Libre](http://es.wikipedia.org/wiki/Software_libre) y todos estan
invitados a mejorar el proyecto.

Puedes utilizar nuestro [Issue
Tracker](https://github.com/LabPLC/verificalo/issues) para reportar
errores o problemas que encuentres con la aplicación así como proponer
nuevas funcionalidades.

Si deseas colaborar en el desarrollo de la aplicación nos encantaría
trabajaras sobre un nuevo branch dentro de un fork de nuestro deposito
y solicitaras un pull request con tus cambios para integrarlos. Para
más información de esta modalidad de colaboración puedes consultar:

- [Contributing to Open Source on GitHub](https://guides.github.com/activities/contributing-to-open-source/)
- [Fork A repo](https://help.github.com/articles/fork-a-repo)
- [Creating a pull request](https://help.github.com/articles/creating-a-pull-request)

Desarrollo
----------

Verificalo esta construido con el framework [Ruby on
Rails](http://rubyonrails.org/) y utiliza la base de datos
[PostgreSQL](http://www.postgresql.org/)

### Requisitos

- PostgreSQL 9.3
- Ruby 2.0.0
- Servidor de correo SMTP (por ejemplo [mailgun](http://www.mailgun.com/))
- Cuenta de [Mapbox](http://www.mapbox.com/)

### Instalación para desarrolladores

**Crear el usuario y base de datos para el ambiente de desarrollo**

    $ createuser -U postgres -s verificalo_dev
    $ createdb -U postgres verificalo_dev

**Clonar el deposito**

    $ git clone https://github.com/LabPLC/verificalo

**Instalar dependencias**

    $ cd verificalo
    $ bundle install

**Copiar la configuración de ejemplo**

    $ cp config/application.yml.sample config/application.yml
    $ cp config/database.yml.sample config/database.yml

**Configurar la aplicación**

Ingresar en la seccion `development` de `config/database.yml` el
usuario y base de datos de PostgreSQL.

Ingresar en `config/application.yml` la configuración del servidor STMP
y el id de la cuenta de Mapbox.

**Ejecutar el servidor de rails**
  
    $ rails server

### Pruebas automatizadas

**Crear el usuario y base de datos para el ambiente de pruebas**

    $ createuser -U postgres -s verificalo_test
    $ createdb -U postgres verificalo_test

**Ejecutar las pruebas**

    $ rspec -fd

Acerca
------

Verificalo fue escrito durante el programa de [Codigo Ciudad de
México](http://codigo.labplc.mx) del [Laboratorio para la
Ciudad](http://labplc.mx) en asociación con [Code for
America](http://codeforamerica.org/).
