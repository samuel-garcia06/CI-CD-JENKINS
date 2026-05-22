import { Component } from '@angular/core';

interface Metric {
  value: string;
  label: string;
  detail: string;
}

interface PipelineStage {
  name: string;
  summary: string;
  evidence: string;
}

interface DeliveryCheckpoint {
  title: string;
  description: string;
}

@Component({
  selector: 'app-root',
  standalone: true,
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'Practica CI/CD lista para defender y desplegar';

  subtitle =
    'Un frontend Angular mas trabajado, empaquetado con Docker y automatizado con Jenkins para demostrar un flujo CI/CD real de principio a fin.';

  metrics: Metric[] = [
    {
      value: '4',
      label: 'disparadores',
      detail: 'manual, push, cron y proyecto upstream'
    },
    {
      value: '2',
      label: 'imagenes Docker',
      detail: 'runtime Nginx en Alpine y Debian'
    },
    {
      value: '100%',
      label: 'pipeline trazable',
      detail: 'lint, test, build, release, deploy y checks'
    }
  ];

  stages: PipelineStage[] = [
    {
      name: 'Control de calidad',
      summary: 'El pipeline valida el codigo con ESLint y ejecuta pruebas unitarias con cobertura.',
      evidence: 'npm run lint · npm run test:ci'
    },
    {
      name: 'Construccion reproducible',
      summary: 'Angular se compila en modo produccion y se empaqueta como artefacto listo para distribuir.',
      evidence: 'dist/ + tar.gz archivado en Jenkins'
    },
    {
      name: 'Release con dos imagenes',
      summary: 'Se generan dos imagenes del mismo software para demostrar portabilidad del despliegue.',
      evidence: 'Dockerfile.alpine · Dockerfile.debian'
    },
    {
      name: 'Despliegue automatizado',
      summary: 'Jenkins publica las imagenes y actualiza el servidor remoto sin intervencion manual.',
      evidence: 'docker compose pull && up -d por SSH'
    },
    {
      name: 'Verificacion posterior',
      summary: 'Tras el despliegue se comprueba la URL publicada y se deja un reporte utilizable en la defensa.',
      evidence: 'scripts/ci/post-deploy-check.sh'
    }
  ];

  checkpoints: DeliveryCheckpoint[] = [
    {
      title: 'Repositorio remoto y ramas',
      description: 'La practica esta preparada para integrarse con GitHub y defender un flujo con ramas, merges y ejecucion por push.'
    },
    {
      title: 'Parametros y notificaciones',
      description: 'El Jenkinsfile acepta entorno, tag, URL y activacion del despliegue, ademas de correo automatico en exito o fallo.'
    },
    {
      title: 'Plugins y trazabilidad',
      description: 'Se apoya en SSH Publisher, Email Extension y archivado de artefactos para demostrar un uso avanzado de Jenkins.'
    }
  ];

  stack = [
    'Angular 21',
    'Jenkins declarativo',
    'Docker y Docker Hub',
    'Nginx como runtime',
    'SSH para despliegue',
    'Karma + Jasmine + ESLint'
  ];
}
