# Practica CI/CD - Angular con Jenkins

## Que incluye

- Frontend Angular con una landing mas trabajada para la demo.
- Pipeline Jenkins con `lint`, pruebas, cobertura, build, release, despliegue y comprobaciones finales.
- Dos imagenes Docker del mismo software:
  - [`Dockerfile.alpine`](/home/samuel/Escritorio/CI-CD/Dockerfile.alpine)
  - [`Dockerfile.debian`](/home/samuel/Escritorio/CI-CD/Dockerfile.debian)

## Flujo del pipeline

1. `push` a GitHub o ejecucion manual en Jenkins.
2. Checkout e instalacion de dependencias con `npm ci`.
3. Analisis estatico con `npm run lint`.
4. Pruebas unitarias con cobertura mediante `npm run test:ci`.
5. Build de Angular para produccion.
6. Empaquetado del artefacto desplegable.
7. Construccion de las dos imagenes Docker.
8. Publicacion automatica en Docker Hub.
9. Despliegue remoto por SSH.
10. Verificacion post-despliegue y archivado de reportes.

## Disparadores soportados

- Ejecucion manual.
- `githubPush()`.
- `cron()`.
- `upstream()`.

## Estructura principal

- [`Jenkinsfile`](/home/samuel/Escritorio/CI-CD/Jenkinsfile)
- [`docker-compose.yml`](/home/samuel/Escritorio/CI-CD/docker-compose.yml)
- [`deploy/remote-deploy.sh`](/home/samuel/Escritorio/CI-CD/deploy/remote-deploy.sh)
- [`scripts/ci/post-deploy-check.sh`](/home/samuel/Escritorio/CI-CD/scripts/ci/post-deploy-check.sh)
- [`ENTREGA_JENKINS.md`](/home/samuel/Escritorio/CI-CD/ENTREGA_JENKINS.md)

## Configuracion necesaria en Jenkins

- Credencial `DOCKER_CREDS` para Docker Hub.
- Configuracion `SSH_DEPLOY_CONFIG` del plugin SSH Publisher.
- Plugin `Email Extension` para los correos automaticos.
- Nodo con Node.js, Docker y Chrome o Chromium disponibles.

## Comandos locales

```bash
npm install
npm run lint
npm run test:ci
npm run build
docker build -f Dockerfile.alpine -t angular-demo:alpine .
docker build -f Dockerfile.debian -t angular-demo:debian .
```
