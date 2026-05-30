@echo off
echo Levantando contenedor Docker...
docker-compose down
docker-compose up --build
pause