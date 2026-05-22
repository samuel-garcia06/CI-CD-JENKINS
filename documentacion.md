# Memoria de entrega - Practica CI/CD

## Alumno

Samuel

## Resumen del proyecto

La practica consiste en un frontend Angular desplegable con Nginx, automatizado mediante Jenkins y empaquetado con Docker. El objetivo es demostrar un flujo CI/CD profesional, reproducible y defendible.

## Herramientas utilizadas

- Jenkins como orquestador principal.
- GitHub como repositorio remoto.
- Angular 21 para el software base.
- ESLint para analisis estatico.
- Karma y Jasmine para pruebas unitarias y cobertura.
- Docker y Docker Hub para generar y publicar imagenes.
- SSH Publisher para despliegue remoto.
- Email Extension para notificaciones.

## Cumplimiento del enunciado

### 1. Control de versiones

- Repositorio remoto en GitHub.
- Uso recomendado de ramas para desarrollo e integracion.
- Commits descriptivos y frecuentes.
- Ejecucion automatica del pipeline al detectar `push`.

### 2. Integracion continua

El pipeline incluye:

1. `Checkout`
2. `Install` con `npm ci`
3. `Static Analysis` con `npm run lint`
4. `Unit Tests` con `npm run test:ci`
5. `Build Angular` con `npm run build`

Evidencias generadas:

- cobertura en `coverage/`
- artefacto desplegable en `artifacts/angular-frontend.tar.gz`
- trazabilidad completa en Jenkins

### 3. Generacion del artefacto

Se empaqueta el frontend compilado como artefacto comprimido y se generan dos imagenes Docker con el mismo software:

- [`Dockerfile.alpine`](/home/samuel/Escritorio/CI-CD/Dockerfile.alpine)
- [`Dockerfile.debian`](/home/samuel/Escritorio/CI-CD/Dockerfile.debian)

Ambos Dockerfiles incluyen `FROM`, `RUN`, `LABEL`, `ENV`, `COPY`, `VOLUME`, `EXPOSE` y `CMD`.

### 4. Publicacion automatica de imagenes

Jenkins construye y publica automaticamente:

- `samuelgarciaayala/angular-jenkins:alpine-latest`
- `samuelgarciaayala/angular-jenkins:alpine-BUILD`
- `samuelgarciaayala/angular-jenkins:debian-latest`
- `samuelgarciaayala/angular-jenkins:debian-BUILD`

### 5. Despliegue continuo

El despliegue se realiza sin intervencion manual mediante:

- copia automatica por SSH
- `docker compose pull`
- `docker compose up -d`
- limpieza de imagenes obsoletas

### 6. Pruebas post-despliegue y monitorizacion

Tras el despliegue se ejecuta [`scripts/ci/post-deploy-check.sh`](/home/samuel/Escritorio/CI-CD/scripts/ci/post-deploy-check.sh), que:

- valida la home publicada
- consulta la ruta `/health`
- genera un reporte en `reports/post-deploy-report.txt`

### 7. Automatizacion y jobs

Se cubren varios disparadores:

- manual
- `githubPush()`
- `cron('H 3 * * 1-5')`
- `upstream()` como trigger adicional

Se contemplan dos jobs enlazados:

- job principal de build, release y deploy
- job downstream opcional para verificacion o monitorizacion avanzada

### 8. Usuarios, parametros y notificaciones

Usuarios recomendados para la defensa:

- `admin-devops`
- `developer`
- `viewer`

Parametros del pipeline:

- `DEPLOY_ENV`
- `IMAGE_TAG`
- `APP_URL`
- `POST_DEPLOY_JOB`
- `PUSH_IMAGES`
- `DEPLOY_AFTER_BUILD`

Notificaciones configuradas:

- correo automatico en exito
- correo automatico en error indicando la ultima fase registrada

### 9. Seguridad o extensiones adicionales

La practica evidencia el uso de plugins de Jenkins para reforzar el pipeline:

- `SSH Publisher`
- `Email Extension`
- archivado de artefactos y reportes

## Estructura del repositorio

- [`Jenkinsfile`](/home/samuel/Escritorio/CI-CD/Jenkinsfile)
- [`Dockerfile.alpine`](/home/samuel/Escritorio/CI-CD/Dockerfile.alpine)
- [`Dockerfile.debian`](/home/samuel/Escritorio/CI-CD/Dockerfile.debian)
- [`docker-compose.yml`](/home/samuel/Escritorio/CI-CD/docker-compose.yml)
- [`deploy/remote-deploy.sh`](/home/samuel/Escritorio/CI-CD/deploy/remote-deploy.sh)
- [`scripts/ci/post-deploy-check.sh`](/home/samuel/Escritorio/CI-CD/scripts/ci/post-deploy-check.sh)
- [`src/app/app.component.ts`](/home/samuel/Escritorio/CI-CD/src/app/app.component.ts)

## Guion del video para el profesor

Objetivo: explicar toda la practica en menos de 10 minutos, enseñando evidencias reales y cubriendo todos los puntos del PDF.

## Preparacion antes de grabar

Deja abiertas estas ventanas o pestañas:

- repositorio remoto en GitHub
- Jenkins con el job principal
- configuracion del pipeline o pantalla de parametros
- Docker Hub con las dos imagenes
- servidor o URL desplegada
- correo o pantalla de notificaciones de Jenkins
- este documento como apoyo

Tambien te conviene tener ya preparada una build reciente correcta para no perder tiempo esperando demasiado.

## Guion minuto a minuto

### 0:00 - 0:40 | Presentacion general

Que enseñar:

- portada del proyecto o `README.md`
- nombre de la practica

Que decir:

"Esta es mi practica de CI/CD. He desarrollado una aplicacion web en Angular y he montado un pipeline completo con Jenkins para automatizar la integracion continua, la generacion de artefactos, la publicacion de imagenes Docker y el despliegue automatico. El objetivo principal no es la complejidad de la app, sino demostrar un flujo DevOps real y funcional."

### 0:40 - 1:40 | Estructura del proyecto y tecnologias

Que enseñar:

- arbol del proyecto
- [`Jenkinsfile`](/home/samuel/Escritorio/CI-CD/Jenkinsfile)
- [`Dockerfile.alpine`](/home/samuel/Escritorio/CI-CD/Dockerfile.alpine)
- [`Dockerfile.debian`](/home/samuel/Escritorio/CI-CD/Dockerfile.debian)
- [`docker-compose.yml`](/home/samuel/Escritorio/CI-CD/docker-compose.yml)
- [`deploy/remote-deploy.sh`](/home/samuel/Escritorio/CI-CD/deploy/remote-deploy.sh)

Que decir:

"La aplicacion esta hecha con Angular 21. Jenkins actua como orquestador principal del pipeline. Uso ESLint para calidad de codigo, Karma y Jasmine para pruebas unitarias, Docker para empaquetado, Docker Hub para publicar las imagenes, Nginx para servir el frontend y SSH Publisher para el despliegue remoto."

"En la estructura del proyecto, el archivo mas importante es el Jenkinsfile, donde se define el pipeline completo. Ademas, tengo dos Dockerfiles distintos para cumplir el requisito de generar dos imagenes diferentes con el mismo software."

### 1:40 - 2:30 | Control de versiones y repositorio remoto

Que enseñar:

- repositorio GitHub
- ramas
- historial de commits

Que decir:

"Todo el proyecto esta versionado en un repositorio remoto. Aqui puedo enseñar el historial de commits descriptivos y el uso de ramas para desarrollo e integracion. El pipeline se integra con este repositorio y se ejecuta automaticamente cuando detecta cambios mediante `push`."

Importante nombrar:

- repositorio remoto
- commits frecuentes y descriptivos
- uso de ramas
- integracion de cambios

### 2:30 - 3:20 | Disparadores y automatizacion

Que enseñar:

- configuracion del job en Jenkins
- `Jenkinsfile` en la zona de `triggers`
- pantalla de `Build with Parameters`

Que decir:

"El sistema demuestra varios disparadores de ejecucion, que es uno de los requisitos del enunciado. Tengo ejecucion manual desde Jenkins, ejecucion automatica por `push` con `githubPush()`, ejecucion periodica con `cron()` y un disparador adicional mediante `upstream()`, que permite encadenar proyectos."

"Ademas, el pipeline usa parametros de ejecucion como el entorno de despliegue, la etiqueta de imagen, la URL de validacion y la activacion o no del despliegue automatico."

Nombrar explicitamente:

- manual
- push
- cron
- trigger adicional
- parametros

### 3:20 - 5:20 | Fases del pipeline CI

Que enseñar:

- stages del job en Jenkins
- consola o stage view
- [`package.json`](/home/samuel/Escritorio/CI-CD/package.json)

Que decir:

"El pipeline de integracion continua tiene varias etapas. La primera es `Checkout`, donde Jenkins obtiene el codigo del repositorio. Despues ejecuta `Install` con `npm ci` para instalar dependencias de forma reproducible."

"La etapa `Static Analysis` realiza analisis estatico con `npm run lint`, cumpliendo la parte de calidad de codigo. Luego, en `Unit Tests`, se ejecutan las pruebas unitarias con cobertura usando `npm run test:ci`."

"Despues, en `Build Angular`, se compila la aplicacion para produccion con `npm run build`. Esto cumple la fase de construccion del software que pide el enunciado."

"Como evidencias, Jenkins guarda la cobertura y tambien genera un artefacto desplegable comprimido."

Debes mencionar aqui:

- analisis de calidad
- build
- pruebas estaticas
- pruebas unitarias
- cobertura
- artefacto

### 5:20 - 6:30 | Generacion y publicacion de imagenes Docker

Que enseñar:

- [`Dockerfile.alpine`](/home/samuel/Escritorio/CI-CD/Dockerfile.alpine)
- [`Dockerfile.debian`](/home/samuel/Escritorio/CI-CD/Dockerfile.debian)
- Docker Hub

Que decir:

"Para la fase de release genero dos imagenes Docker distintas que contienen el mismo software. En este caso uso dos variantes diferentes del sistema base: una con Alpine y otra con Debian. Esto cumple el requisito de tener dos imagenes diferentes."

"Los Dockerfiles incluyen las instrucciones exigidas en el PDF: `FROM`, `RUN`, `LABEL`, `ENV`, `COPY`, `VOLUME`, `EXPOSE` y `CMD`. Jenkins construye ambas imagenes y luego las publica automaticamente en Docker Hub."

"Aqui se pueden ver las dos variantes subidas al repositorio remoto de imagenes."

### 6:30 - 7:20 | Despliegue continuo

Que enseñar:

- [`docker-compose.yml`](/home/samuel/Escritorio/CI-CD/docker-compose.yml)
- [`deploy/remote-deploy.sh`](/home/samuel/Escritorio/CI-CD/deploy/remote-deploy.sh)
- stage `Deploy` en Jenkins

Que decir:

"Una vez generadas y publicadas las imagenes, Jenkins realiza el despliegue automatico sin intervencion manual. Para ello copia la configuracion necesaria al servidor remoto y ejecuta un script que hace `docker compose pull` y `docker compose up -d`."

"De esta forma, cada nueva version validada puede quedar desplegada automaticamente en el servidor."

### 7:20 - 8:10 | Pruebas post-despliegue y monitorizacion

Que enseñar:

- web ya desplegada
- ruta `/health`
- [`scripts/ci/post-deploy-check.sh`](/home/samuel/Escritorio/CI-CD/scripts/ci/post-deploy-check.sh)
- reporte generado

Que decir:

"Despues del despliegue se ejecutan pruebas funcionales basicas. En este proyecto se comprueba que la aplicacion responde correctamente y que el endpoint `/health` devuelve `ok`. Ademas, se genera un reporte con el resultado para dejar evidencia del estado del despliegue."

"Con esto cubro la parte del enunciado de pruebas post-despliegue y monitorizacion basica."

### 8:10 - 8:50 | Jobs enlazados, usuarios y notificaciones

Que enseñar:

- parametro `POST_DEPLOY_JOB`
- configuracion o captura del job downstream
- correo de exito o fallo

Que decir:

"El pipeline tambien contempla al menos dos jobs enlazados: el job principal y un job downstream opcional para verificaciones adicionales. Esto permite demostrar un flujo real entre trabajos."

"En Jenkins tambien se gestionan distintos usuarios y roles, por ejemplo administrador, desarrollador y visor. Ademas, el sistema envia notificaciones automaticas por correo tanto cuando la ejecucion termina correctamente como cuando falla, indicando el motivo o la fase del fallo."

Si no puedes enseñar usuarios reales:

"La gestion de usuarios se realiza dentro de Jenkins con perfiles diferenciados para administracion, ejecucion y consulta."

### 8:50 - 9:30 | Plugins extra o extensiones

Que enseñar:

- plugins usados en Jenkins
- evidencias en el pipeline

Que decir:

"Como extension adicional, he utilizado plugins de Jenkins para reforzar el sistema, especialmente `SSH Publisher` para el despliegue remoto y `Email Extension` para las notificaciones avanzadas. Tambien archivo artefactos y reportes, lo que mejora la trazabilidad del pipeline."

"Esto cubre la parte del enunciado relativa al uso avanzado de plugins o extensiones adicionales."

### 9:30 - 10:00 | Cierre

Que enseñar:

- resultado final del job en verde
- web desplegada

Que decir:

"En resumen, esta practica cumple las fases de control de versiones, integracion continua, generacion de artefactos, publicacion de imagenes, despliegue continuo, pruebas posteriores, automatizacion con distintos triggers, parametros, notificaciones y uso avanzado de Jenkins. Todo el flujo esta automatizado y preparado para un entorno real de trabajo."

## Checklist final para no olvidarte de nada

- explicar que usas Jenkins como herramienta CI/CD
- enseñar el repositorio remoto
- enseñar ramas y commits
- enseñar triggers manual, push, cron y otro adicional
- enseñar parametros del pipeline
- enseñar analisis estatico
- enseñar tests y cobertura
- enseñar build
- enseñar artefacto generado
- enseñar las dos imagenes Docker
- enseñar Docker Hub
- enseñar despliegue remoto
- enseñar pruebas post-despliegue
- enseñar reporte
- enseñar notificaciones
- mencionar usuarios o roles en Jenkins
- mencionar plugins o extension adicional

## Consejo para sacar mejor nota

No leas el documento palabra por palabra. Usa este guion como estructura, pero habla señalando evidencias reales en pantalla. Si algo no te da tiempo a ejecutar en vivo, enseña una build anterior correcta y explica claramente en que parte del pipeline se valida cada requisito.

## Archivos y lineas exactas que debes enseñar

Esta es la guia precisa para grabar. En cada bloque tienes el archivo, las lineas y que debes explicar para demostrar cada parte del PDF.

### 1. Presentacion del proyecto

Enseña:

- [README.md](/home/samuel/Escritorio/CI-CD/README.md:1)
- [README.md](/home/samuel/Escritorio/CI-CD/README.md:5)
- [README.md](/home/samuel/Escritorio/CI-CD/README.md:13)

Explica:

- que es una practica de CI/CD con Angular y Jenkins
- que el proyecto incluye frontend, pipeline, Docker, despliegue y verificacion final
- que el flujo general ya esta resumido en la documentacion

### 2. Software desarrollado

Enseña:

- [src/app/app.component.ts](/home/samuel/Escritorio/CI-CD/src/app/app.component.ts:27)
- [src/app/app.component.ts](/home/samuel/Escritorio/CI-CD/src/app/app.component.ts:32)
- [src/app/app.component.ts](/home/samuel/Escritorio/CI-CD/src/app/app.component.ts:50)
- [src/app/app.component.ts](/home/samuel/Escritorio/CI-CD/src/app/app.component.ts:78)
- [src/app/app.component.html](/home/samuel/Escritorio/CI-CD/src/app/app.component.html:1)
- [src/app/app.component.html](/home/samuel/Escritorio/CI-CD/src/app/app.component.html:35)

Explica:

- que el software es pequeno pero funcional, como pide el enunciado
- que la app sirve para demostrar visualmente el pipeline
- que has mejorado un poco la interfaz para que la practica se vea mas trabajada

### 3. Repositorio remoto, ramas y commits

Enseña:

- el repositorio en GitHub
- la pestaña de ramas
- el historial de commits

Como apoyo:

- [documentacion.md](/home/samuel/Escritorio/CI-CD/documentacion.md:22)

Explica:

- que todo esta bajo control de versiones en remoto
- que has usado ramas
- que los commits son descriptivos y frecuentes
- que Jenkins esta integrado con el repositorio

### 4. Herramienta CI/CD elegida

Enseña:

- la vista del job en Jenkins
- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:1)

Explica:

- que Jenkins es la herramienta principal del pipeline
- que toda la automatizacion se define de forma declarativa en el `Jenkinsfile`

### 5. Parametros del pipeline

Enseña:

- pantalla `Build with Parameters` en Jenkins
- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:17)

Explica:

- `DEPLOY_ENV`: entorno objetivo
- `IMAGE_TAG`: etiqueta manual de imagen
- `APP_URL`: URL para pruebas post-despliegue
- `POST_DEPLOY_JOB`: job downstream opcional
- `PUSH_IMAGES`: decide si publicar en Docker Hub
- `DEPLOY_AFTER_BUILD`: decide si desplegar automaticamente

### 6. Disparadores de ejecucion

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:26)

Explica:

- linea 27: disparo automatico por `push`
- linea 28: ejecucion periodica con `cron`
- linea 29: disparador adicional con `upstream`
- ademas, lanzamiento manual desde Jenkins

### 7. Estructura de etapas del pipeline

Enseña:

- stage view o Blue Ocean
- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:32)

Explica:

- que el pipeline esta dividido por fases claras
- que esto permite seguir el ciclo completo desde integracion hasta despliegue

### 8. Instalacion reproducible

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:41)

Explica:

- que `npm ci` asegura instalaciones limpias y reproducibles en CI

### 9. Analisis de calidad del codigo

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:48)
- [package.json](/home/samuel/Escritorio/CI-CD/package.json:5)
- [.eslintrc.json](/home/samuel/Escritorio/CI-CD/.eslintrc.json:1)

Explica:

- que `Static Analysis` ejecuta `npm run lint`
- que el script `lint` esta definido en `package.json`
- que `.eslintrc.json` configura el analisis estatico para TypeScript y templates Angular

### 10. Pruebas unitarias y cobertura

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:55)
- [package.json](/home/samuel/Escritorio/CI-CD/package.json:8)
- la carpeta `coverage/` o el informe HTML

Explica:

- que el pipeline ejecuta pruebas unitarias
- que `test:ci` activa cobertura
- que Jenkins archiva la cobertura como evidencia

### 11. Build del software

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:67)
- [package.json](/home/samuel/Escritorio/CI-CD/package.json:6)

Explica:

- que Angular necesita una fase de build para generar el frontend compilado
- que esto cumple la etapa de construccion del software

### 12. Artefacto desplegable

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:71)
- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:76)

Explica:

- que el pipeline empaqueta un `.tar.gz` con los ficheros necesarios
- que ese artefacto queda archivado en Jenkins

### 13. Construccion de dos imagenes Docker

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:83)
- [Dockerfile.alpine](/home/samuel/Escritorio/CI-CD/Dockerfile.alpine:1)
- [Dockerfile.debian](/home/samuel/Escritorio/CI-CD/Dockerfile.debian:1)

Explica:

- que se construyen dos imagenes distintas del mismo software
- que una usa Alpine y otra Debian
- que asi cumples el requisito de dos imagenes diferentes

### 14. Instrucciones Docker obligatorias

Enseña:

- [Dockerfile.alpine](/home/samuel/Escritorio/CI-CD/Dockerfile.alpine:10)
- [Dockerfile.debian](/home/samuel/Escritorio/CI-CD/Dockerfile.debian:10)

Explica:

- `FROM`: lineas 1 y 10
- `RUN`: lineas 5, 8 y 13 en Alpine; lineas 5, 8 y 13-17 en Debian
- `LABEL`: linea 11
- `ENV`: linea 12
- `COPY`: lineas 4, 7, 14 y 15 en Alpine; 4, 7, 18 y 19 en Debian
- `VOLUME`: linea 16 en Alpine y 20 en Debian
- `EXPOSE`: linea 17 en Alpine y 21 en Debian
- `CMD`: linea 18 en Alpine y 22 en Debian

### 15. Publicacion automatica en Docker Hub

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:100)
- Docker Hub con las tags publicadas

Explica:

- que Jenkins usa credenciales seguras
- que publica automaticamente las imagenes construidas
- que esta fase forma parte del pipeline

### 16. Despliegue automatico

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:118)
- [deploy/remote-deploy.sh](/home/samuel/Escritorio/CI-CD/deploy/remote-deploy.sh:1)
- [docker-compose.yml](/home/samuel/Escritorio/CI-CD/docker-compose.yml:1)

Explica:

- que Jenkins copia ficheros y ejecuta el despliegue por SSH
- que el script hace `docker compose pull` y `docker compose up -d`
- que no hay intervencion manual

### 17. Servicio desplegado y monitorizacion basica

Enseña:

- [docker-compose.yml](/home/samuel/Escritorio/CI-CD/docker-compose.yml:2)
- [docker-compose.yml](/home/samuel/Escritorio/CI-CD/docker-compose.yml:10)
- [nginx.conf](/home/samuel/Escritorio/CI-CD/nginx.conf:12)
- la web desplegada
- la ruta `/health`

Explica:

- que `docker-compose` define el servicio, el puerto y el healthcheck
- que Nginx expone `/health` devolviendo `ok`
- que eso sirve para comprobacion funcional y monitorizacion basica

### 18. Pruebas post-despliegue

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:143)
- [scripts/ci/post-deploy-check.sh](/home/samuel/Escritorio/CI-CD/scripts/ci/post-deploy-check.sh:1)
- el reporte `reports/post-deploy-report.txt`

Explica:

- que tras desplegar se lanza una comprobacion automatica
- que se valida la home y el endpoint `/health`
- que el resultado se guarda en un reporte

### 19. Jobs enlazados

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:158)
- si lo tienes creado, la pantalla del job downstream

Explica:

- que existe un job principal y otro downstream opcional
- que esto demuestra enlazado entre trabajos reales

### 20. Notificaciones por correo

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:175)
- un correo de exito o de error

Explica:

- que el bloque `success` manda notificacion cuando todo va bien
- que el bloque `failure` manda notificacion cuando algo falla
- que el correo de error indica la ultima fase registrada

### 21. Usuarios y roles en Jenkins

Enseña:

- si puedes, la pantalla de usuarios en Jenkins
- como apoyo, [documentacion.md](/home/samuel/Escritorio/CI-CD/documentacion.md:91)

Explica:

- que has contemplado perfiles como administrador, desarrollador y visor
- que eso cubre la parte de gestion de usuarios de la herramienta

### 22. Plugins o extensiones adicionales

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:124)
- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:177)
- [README.md](/home/samuel/Escritorio/CI-CD/README.md:41)

Explica:

- que usas `SSH Publisher` para despliegue remoto
- que usas `Email Extension` con `emailext` para correos avanzados
- que el archivado de artefactos y reportes mejora la trazabilidad

### 23. Cierre del video

Enseña:

- el job en verde en Jenkins
- Docker Hub con las imagenes
- la web desplegada
- el reporte final

Explica:

- que el proyecto cubre control de versiones, integracion continua, artefactos, Docker, publicacion, despliegue, pruebas, triggers, parametros, notificaciones y extensiones
- que todo el flujo funciona de extremo a extremo

## Orden de pantallas recomendado

1. `README.md`
2. web Angular funcionando
3. `app.component.ts` y `app.component.html`
4. GitHub con ramas y commits
5. Jenkins job principal
6. `Jenkinsfile`
7. `package.json` y `.eslintrc.json`
8. reporte de cobertura
9. `Dockerfile.alpine` y `Dockerfile.debian`
10. Docker Hub
11. `docker-compose.yml` y `remote-deploy.sh`
12. web desplegada y `/health`
13. `post-deploy-check.sh` y reporte
14. correo de notificacion

## Consejo final

No enseñes archivos completos. Ve directamente a las lineas indicadas, explica que demuestran y pasa al siguiente bloque. Asi el video queda mas claro, mas rapido y mas profesional.

## Guion practico: que digo, que enseño y para que sirve

Esta es la version mas util para grabar. En cada bloque tienes las tres cosas juntas:

- lo que dices
- el archivo o pantalla que enseñas mientras lo dices
- para que sirve cada cosa

### 1. Inicio del video

Di:

"Esta es mi practica de CI/CD. He desarrollado una aplicacion web en Angular 21 y he montado un pipeline con Jenkins para automatizar validacion, construccion, empaquetado, publicacion y despliegue."

Enseña:

- [README.md](/home/samuel/Escritorio/CI-CD/README.md:1)
- [README.md](/home/samuel/Escritorio/CI-CD/README.md:13)

Para que sirve:

- `README.md`: sirve para presentar el proyecto y resumir el flujo completo antes de entrar al detalle.

### 2. Aplicacion desarrollada

Di:

"El software desarrollado es pequeno pero funcional. He hecho una web sencilla en Angular para demostrar el pipeline de forma visual y que la practica se vea mejor presentada."

Enseña:

- [src/app/app.component.ts](/home/samuel/Escritorio/CI-CD/src/app/app.component.ts:27)
- [src/app/app.component.ts](/home/samuel/Escritorio/CI-CD/src/app/app.component.ts:32)
- [src/app/app.component.html](/home/samuel/Escritorio/CI-CD/src/app/app.component.html:1)

Para que sirve:

- `app.component.ts`: contiene los datos que muestra la interfaz, como metricas, etapas del pipeline y puntos de defensa.
- `app.component.html`: pinta la pagina principal y demuestra que la aplicacion existe realmente y no es solo documentacion.

### 3. Control de versiones

Di:

"Todo el proyecto esta bajo control de versiones en un repositorio remoto. He trabajado con ramas, commits descriptivos e integracion de cambios."

Enseña:

- GitHub: repositorio principal
- GitHub: ramas
- GitHub: historial de commits

Para que sirve:

- GitHub: sirve como repositorio remoto y como origen de los cambios que disparan Jenkins.

### 4. Herramienta CI/CD elegida

Di:

"La herramienta CI/CD elegida es Jenkins. Toda la automatizacion del proyecto esta definida en el pipeline declarativo del Jenkinsfile."

Enseña:

- Jenkins: pantalla del job principal
- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:1)

Para que sirve:

- Jenkins: ejecuta el pipeline.
- `Jenkinsfile`: define todas las fases automatizadas de la practica.

### 5. Parametros y disparadores

Di:

"El pipeline usa parametros de ejecucion y varios disparadores, como ejecucion manual, push, cron y un trigger adicional por proyecto upstream."

Enseña:

- Jenkins: `Build with Parameters`
- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:17)
- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:26)

Para que sirve:

- bloque `parameters`: sirve para personalizar la ejecucion sin tocar codigo.
- bloque `triggers`: sirve para automatizar cuando se lanza el pipeline.

### 6. Instalacion y calidad del codigo

Di:

"La fase de integracion continua empieza instalando dependencias con npm ci y despues valida la calidad del codigo con ESLint."

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:41)
- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:48)
- [package.json](/home/samuel/Escritorio/CI-CD/package.json:5)
- [.eslintrc.json](/home/samuel/Escritorio/CI-CD/.eslintrc.json:1)

Para que sirve:

- `npm ci` en `Jenkinsfile`: sirve para instalaciones reproducibles.
- script `lint` en `package.json`: sirve para ejecutar analisis estatico.
- `.eslintrc.json`: sirve para definir reglas de calidad para TypeScript y Angular templates.

### 7. Pruebas unitarias y cobertura

Di:

"Despues se ejecutan pruebas unitarias con cobertura para comprobar que el software funciona y dejar evidencia medible en Jenkins."

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:55)
- [package.json](/home/samuel/Escritorio/CI-CD/package.json:8)
- carpeta `coverage/`

Para que sirve:

- stage `Unit Tests`: sirve para validar el comportamiento del codigo.
- script `test:ci`: sirve para lanzar pruebas unitarias en modo CI con cobertura.
- `coverage/`: sirve como evidencia para el profesor y para Jenkins.

### 8. Build del software y artefacto

Di:

"Cuando las validaciones pasan, Jenkins construye la aplicacion Angular y genera un artefacto desplegable comprimido."

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:67)
- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:71)
- [package.json](/home/samuel/Escritorio/CI-CD/package.json:6)

Para que sirve:

- stage `Build Angular`: sirve para compilar el frontend para produccion.
- comando `tar` del artefacto: sirve para empaquetar los ficheros necesarios para release o auditoria.

### 9. Dos imagenes Docker

Di:

"Para cumplir el enunciado genero dos imagenes Docker distintas con el mismo software: una basada en Alpine y otra en Debian."

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:83)
- [Dockerfile.alpine](/home/samuel/Escritorio/CI-CD/Dockerfile.alpine:1)
- [Dockerfile.debian](/home/samuel/Escritorio/CI-CD/Dockerfile.debian:1)

Para que sirve:

- stage `Build Docker Images`: sirve para construir ambas variantes automaticamente.
- `Dockerfile.alpine`: sirve para empaquetar la app sobre una imagen ligera.
- `Dockerfile.debian`: sirve para empaquetar la misma app sobre otra base distinta.

### 10. Instrucciones obligatorias de Docker

Di:

"Los Dockerfiles incluyen todas las instrucciones que pide el PDF: FROM, RUN, LABEL, ENV, COPY, VOLUME, EXPOSE y CMD."

Enseña:

- [Dockerfile.alpine](/home/samuel/Escritorio/CI-CD/Dockerfile.alpine:10)
- [Dockerfile.debian](/home/samuel/Escritorio/CI-CD/Dockerfile.debian:10)

Para que sirve:

- `FROM`: define la imagen base.
- `RUN`: instala paquetes o prepara el contenedor.
- `LABEL`: añade metadatos.
- `ENV`: define variables de entorno.
- `COPY`: copia configuracion y build al contenedor.
- `VOLUME`: declara almacenamiento persistente.
- `EXPOSE`: documenta el puerto.
- `CMD`: arranca Nginx.

### 11. Publicacion en Docker Hub

Di:

"Una vez construidas, Jenkins publica automaticamente las imagenes en Docker Hub usando credenciales seguras."

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:100)
- Docker Hub con las etiquetas

Para que sirve:

- stage `Push Docker Images`: sirve para subir las imagenes a un registro remoto.
- Docker Hub: sirve como repositorio de imagenes para despliegue.

### 12. Despliegue continuo

Di:

"Despues Jenkins despliega automaticamente en el servidor remoto por SSH, sin intervencion manual."

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:118)
- [deploy/remote-deploy.sh](/home/samuel/Escritorio/CI-CD/deploy/remote-deploy.sh:1)
- [docker-compose.yml](/home/samuel/Escritorio/CI-CD/docker-compose.yml:1)

Para que sirve:

- stage `Deploy`: sirve para transferir y ejecutar el despliegue.
- `remote-deploy.sh`: sirve para hacer `pull`, `up -d` y limpieza en el servidor.
- `docker-compose.yml`: sirve para definir como se ejecuta el contenedor desplegado.

### 13. Pruebas post-despliegue y monitorizacion

Di:

"Tras el despliegue se comprueba automaticamente que la web responde y que el endpoint de salud devuelve ok."

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:143)
- [scripts/ci/post-deploy-check.sh](/home/samuel/Escritorio/CI-CD/scripts/ci/post-deploy-check.sh:1)
- [nginx.conf](/home/samuel/Escritorio/CI-CD/nginx.conf:12)
- la URL `/health`

Para que sirve:

- stage `Post-Deploy Checks`: sirve para validar el despliegue.
- `post-deploy-check.sh`: sirve para comprobar la home y `/health` y generar un reporte.
- `nginx.conf`: sirve para definir el endpoint de salud del servicio.

### 14. Jobs enlazados, usuarios y notificaciones

Di:

"El sistema contempla un job principal y otro downstream opcional, distintos roles de usuario en Jenkins y correos automaticos en caso de exito o error."

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:158)
- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:175)
- Jenkins: usuarios o roles
- un correo de notificacion

Para que sirve:

- stage `Trigger Downstream Job`: sirve para enlazar varios jobs.
- bloque `post`: sirve para enviar notificaciones automaticas.
- usuarios de Jenkins: sirven para gestionar acceso y responsabilidades.

### 15. Plugins o extensiones adicionales

Di:

"Ademas uso plugins avanzados como SSH Publisher y Email Extension, que refuerzan la funcionalidad del pipeline."

Enseña:

- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:124)
- [Jenkinsfile](/home/samuel/Escritorio/CI-CD/Jenkinsfile:177)
- Jenkins: lista de plugins si la tienes abierta

Para que sirve:

- `sshPublisher`: sirve para desplegar remotamente desde Jenkins.
- `emailext`: sirve para enviar correos mas completos que la notificacion basica.

### 16. Cierre

Di:

"En resumen, la practica cubre control de versiones, integracion continua, build, pruebas, cobertura, artefactos, dos imagenes Docker, publicacion, despliegue continuo, verificacion final, disparadores, parametros, notificaciones y extensiones adicionales."

Enseña:

- Jenkins en verde
- Docker Hub
- web desplegada
- reporte final

Para que sirve:

- resultado final del job: demuestra que el flujo completo funciona.
- web desplegada: demuestra el resultado visible.
- reporte final: demuestra la verificacion posterior al despliegue.
