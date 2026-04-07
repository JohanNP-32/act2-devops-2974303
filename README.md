# Actividad 2 DevOps

## Descripción
Esta actividad implementa un flujo de trabajo automatizado para la gestión de infraestructura en la nube (AWS). Combina el poder de **Python (Boto3)** para la administración de cómputo y **Bash** para la automatización de respaldos en almacenamiento persistente (S3). 

El objetivo principal es demostrar la **orquestación de servicios** mediante un script central (`deploy.sh`) que elimina el *hardcoding* mediante el uso de archivos de configuración externos, siguiendo estándares profesionales de DevOps.

## Flujo Git y Metodología
Para el desarrollo de esta actividad se aplicó la metodología **GitFlow**, asegurando un historial de cambios limpio y trazable:

* **Main:** Rama de producción con el código estable.
* **Develop:** Rama de integración para nuevas funcionalidades.
* **Feature Branches:** Ramas temporales para el desarrollo de módulos específicos (`feature/script-ec2`, `feature/script-s3`, `feature/orquestacion`).


## Tecnologías Utilizadas
* **Lenguajes:** Python 3.9+ y Bash.
* **Cloud:** Amazon Web Services (EC2 y S3).
* **SDK:** Boto3 (AWS SDK para Python).
* **Control de Versiones:** Git y GitHub.

## Configuración del Entorno
Los parámetros globales se gestionan en el archivo `config/config.env`. Esto permite que los scripts sean reutilizables en diferentes entornos sin modificar el código fuente:

```env
INSTANCE_ID=i-0f8fd0a0b924dfadb
BUCKET_NAME=mi-bucket-devops-ejemplo
DIRECTORY=./data
REGION=us-east-1
```

---

Instrucciones de Uso
Para ejecutar la orquestación completa, asegúrese de tener permisos de ejecución en los scripts y utilice el orquestador principal:

1. Dar permisos:
   ```bash
   chmod +x deploy.sh s3/backup_s3.sh
   ```
2. Ejecutar el Orquestador:
  El script requiere 4 parámetros: <accion_ec2> <id_instancia> <directorio_local> <nombre_bucket>.
  ```bash
  ./deploy.sh <accion> <id_instancia> <directorio> <bucket>
  ```

---

Ejemplos de Ejecución
A continuación, se muestran ejemplos de cómo interactuar con el sistema:

Iniciar instancia y respaldar datos:
./deploy.sh iniciar i-0f8fd0a0b924dfadb ./data mi-bucket-devops-johan

Detener instancia y respaldar logs:
./deploy.sh detener i-0f8fd0a0b924dfadb ./logs mi-bucket-devops-johan

---

Estructura del Repositorio
ec2/: Módulo de Python para gestión de instancias (Listar, Iniciar, Detener, Terminar).

s3/: Script de Bash para compresión y subida de respaldos.

config/: Archivos de configuración y variables de entorno.

logs/: Registros de auditoría de cada despliegue.

data/: Directorio de origen para pruebas de backup.

