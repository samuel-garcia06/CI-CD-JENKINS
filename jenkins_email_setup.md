# Configuracion de correo en Jenkins

Este proyecto ya usa `emailext` en el [`Jenkinsfile`](/home/samuel/Escritorio/CI-CD/Jenkinsfile), asi que la parte que faltaba es la configuracion real de Jenkins para que pueda enviar correos.

## 1. Plugin necesario

Instala en Jenkins:

- `Email Extension`

Opcional pero recomendable:

- `Mailer`

## 2. Donde se configura

En Jenkins entra en:

- `Manage Jenkins`
- `Configure System`

Busca estas secciones:

- `Jenkins Location`
- `Extended E-mail Notification`
- `E-mail Notification`

## 3. Configuracion minima recomendada

### Jenkins Location

Rellena:

- `Jenkins URL`: la URL publica de tu Jenkins
- `System Admin e-mail address`: tu correo

Esto sirve para que los enlaces del correo apunten bien a la consola del build.

### Extended E-mail Notification

Rellena:

- `SMTP server`: el servidor SMTP de tu proveedor
- `SMTP Port`: normalmente `587` con TLS o `465` con SSL
- `Credentials`: usuario y password o app password
- `Use SMTP Authentication`: activado
- `Use SSL` o `Use TLS`: segun el proveedor
- `Default user e-mail suffix`: opcional
- `Default Content Type`: `text/plain` o `text/html`
- `Default Recipients`: opcional

Luego pulsa:

- `Advanced`
- `Test configuration by sending test e-mail`

## 4. Configuracion para Gmail

Si usas Gmail, lo mas normal es:

- `SMTP server`: `smtp.gmail.com`
- `Port`: `587`
- `Use TLS`: activado
- `Authentication`: activada
- `Username`: tu correo de Gmail
- `Password`: una `App Password` de Google, no tu password normal

## 5. Configuracion para Outlook o Microsoft 365

Valores habituales:

- `SMTP server`: `smtp.office365.com`
- `Port`: `587`
- `Use TLS`: activado
- `Authentication`: activada
- `Username`: tu correo
- `Password`: la clave o metodo permitido por tu cuenta

## 6. Configuracion para tu proyecto

Tu pipeline ya esta preparado para enviar correo:

- en exito
- en fallo

Y ahora acepta destinatario por parametro:

- `EMAIL_TO`

Si no indicas nada, usa por defecto:

- `samuelgarciaayala@gmail.com`

## 7. Como demostrarlo en el video

Enseña:

1. `Manage Jenkins > Configure System`
2. la seccion `Extended E-mail Notification`
3. la prueba de envio correcta
4. una build correcta con correo de exito
5. una build fallida con correo de error

## 8. Que correos manda este Jenkinsfile

### Si la ejecucion sale bien

Incluye:

- nombre del job
- numero de build
- entorno
- tag generado
- URL verificada
- enlace a la consola

### Si la ejecucion falla

Incluye:

- nombre del job
- numero de build
- ultima fase registrada
- entorno
- enlace a la consola

## 9. Comprobacion final

Para que funcione de verdad, tienen que cumplirse estas 4 cosas:

- plugin `Email Extension` instalado
- servidor SMTP configurado en Jenkins
- credenciales validas
- Jenkins con salida a internet hacia el servidor SMTP
