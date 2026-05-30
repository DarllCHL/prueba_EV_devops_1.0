# pipeline-devops-2026--mayo-22-05-2026

# 🚀 Pipeline CI/CD - Microservicio BDGet
### Ingeniería DevOps - DOY0101 | Evaluación Parcial N°2
**Estudiantes:** Matias Bustos
                 Robeerto Gonzalez

---

## 📋 Descripción

Este repositorio contiene el microservicio **BDGet** desarrollado con Spring Boot, contenerizado con Docker e integrado en un pipeline CI/CD completo implementado con GitHub Actions. El pipeline automatiza todo el ciclo de vida del microservicio: análisis de seguridad, pruebas unitarias, análisis de calidad de código, construcción y despliegue automático en un entorno local simulado.

---

## 🏗️ Arquitectura del Pipeline

El pipeline se compone de 5 jobs que se ejecutan de forma secuencial:

Snyk Security Scan → Run Tests with JaCoCo → SonarCloud Analysis → Build Jar → Deploy with Docker Compose

### Jobs del Pipeline

| Job | Herramienta | Descripción |
|-----|-------------|-------------|
| Snyk Security Scan | Snyk | Escaneo de vulnerabilidades en dependencias Maven |
| Run Tests with JaCoCo | JUnit + JaCoCo | Ejecución de pruebas unitarias y reporte de cobertura |
| SonarCloud Analysis | SonarCloud | Análisis estático de calidad y seguridad del código |
| Build Jar | Maven | Empaquetado del microservicio en archivo JAR |
| Deploy with Docker Compose | Docker + Self-hosted Runner | Despliegue automático en entorno local |

---

## 🐳 Contenedores (IE1 - IE5)

### Dockerfile
El microservicio está contenerizado usando una estrategia **multi-stage build** para optimizar el tamaño de la imagen final:

- **Stage 1 (Build):** `eclipse-temurin:17-jdk-alpine` — compila el proyecto con Maven
- **Stage 2 (Runtime):** `eclipse-temurin:17-jre-alpine` — imagen liviana solo con JRE
- Usuario no-root por seguridad (`appuser`)
- Puerto expuesto: `8085`

### Docker Compose
Orquestación del microservicio con:
- Healthcheck configurado
- Política de reinicio `unless-stopped`
- Variables de entorno para conexión a Oracle DB

---

## 🔒 Análisis de Seguridad (IE3)

### Snyk
- Escaneo de dependencias Maven en cada push
- Umbral de bloqueo: vulnerabilidades de severidad **alta**
- Si Snyk detecta vulnerabilidades críticas, el pipeline se detiene y los jobs siguientes no se ejecutan
- Reporte JSON generado y subido como artefacto

### Dependabot
- Configurado para revisar dependencias Maven **semanalmente**
- Abre Pull Requests automáticos cuando detecta actualizaciones
- Integrado con SonarCloud para analizar cada PR automáticamente

---

## 🧪 Pruebas Automatizadas (IE2)

- Framework: **JUnit 5**
- Cobertura: **JaCoCo**
- Tests implementados:
  - `StudentControllerTest` — pruebas del controlador REST
  - `StudentServiceImplTest` — pruebas de la capa de servicio
  - `StudentModelTest` — pruebas del modelo de datos
- Reporte de cobertura subido como artefacto en cada ejecución

---

## ☁️ Despliegue Automático (IE4)

El despliegue se realiza mediante un **self-hosted runner** instalado en la máquina local, lo que permite:

1. El pipeline de CI corre en los servidores de GitHub (Snyk, Tests, Sonar, Build)
2. El job de **Deploy** se ejecuta directamente en la máquina local
3. Docker construye la imagen y levanta el contenedor automáticamente
4. El contenedor queda corriendo en Docker Desktop después de cada push

### Trazabilidad
Cada push a `main` dispara el pipeline completo, garantizando que:
- El código pasa por análisis de seguridad antes de desplegarse
- Las pruebas unitarias validan el comportamiento del microservicio
- SonarCloud certifica la calidad del código
- El despliegue solo ocurre si todos los pasos anteriores son exitosos

---

## 🔧 Configuración de Secrets

Los siguientes secrets deben estar configurados en el repositorio:

| Secret | Descripción |
|--------|-------------|
| `SNYK_TOKEN_2` | Token de autenticación de Snyk |
| `SONAR_TOKEN_2` | Token de autenticación de SonarCloud |

---

## 📁 Estructura del Proyecto

bdget-main/
├── .github/
│   ├── workflows/
│   │   └── main.yml          # Pipeline CI/CD
│   └── dependabot.yml        # Configuración Dependabot
├── src/
│   ├── main/java/            # Código fuente
│   └── test/java/            # Pruebas unitarias
├── Dockerfile                # Imagen Docker multi-stage
├── docker-compose.yml        # Orquestación de contenedores
└── pom.xml                   # Dependencias Maven

---

## ▶️ Cómo ejecutar localmente

```bash
# Clonar el repositorio
git clone https://github.com/DarllCHL/prueba_EV_devops_1.0.git

# Levantar con Docker Compose
docker compose up -d

# Verificar que está corriendo
docker compose ps
```

La aplicación estará disponible en `http://localhost:8085`

la decision de usar ese puerto fue porque tengo otros proyectos corriendo, solamente eso

---

## 🤖 Uso de Inteligencia Artificial

Durante el desarrollo de esta evaluación se utilizó **Claude (Anthropic)** como herramienta de apoyo para la construcción y depuración del pipeline CI/CD, configuración del Dockerfile optimizado y resolución de errores en GitHub Actions. Todas las decisiones técnicas, implementación y comprensión del proyecto son propias del estudiante. Referencia: https://bibliotecas.duoc.cl/ia

arreglar lo siguiente:

° la parte de que se conecte a una base de datos de oracle, tenemos que hacer que corra en local, que se levante el sitio atravez de dockers en el puerto 8085
°