# Docker

¿Qué es Docker?

> Docker es una plataforma de código abierto que facilita la creación, el despliegue y la ejecución de aplicaciones en contenedores. Los contenedores son entornos ligeros y portátiles que contienen todo lo necesario para ejecutar una aplicación, incluidas las bibliotecas, dependencias y código.

Una simple guia para entender Docker

Requisitos recomendados

- Conocimientos básicos de Desarrollo Web
- Conocimientos básicos sobre protocolos de red
- Uso de terminal linux y windows

Requisitos Necesarios

- [Docker desktop](https://www.docker.com/products/docker-desktop/)
- [Docker Engine](https://docs.docker.com/engine/install/)
  > Docker Engine es opcional si tienes Docker Desktop ya que lo instala automáticamente.

## Docker image

¿Qué es una imagén Docker?

> Es una plantilla de solo lectura que define su contenedor. La imagen contiene el código que se ejecutará, incluida cualquier definición para cualquier biblioteca o dependencia que el código necesite

## Docker container

¿Qué es un contenedor de Docker?

> Un contenedor de Docker es un conocido contenedor ejecutable, independiente, ligero que integra todo lo necesario para ejecutar una aplicación, incluidas bibliotecas, herramientas del sistema, código y tiempo de ejecución.

## Docker pull

Para utilizar imagenes Docker podemos usar **Docker HUB** que nos proporciona imagenes ya prediseñadas de muchos entornos, en este caso **node**

[Docker HUB](https://hub.docker.com/)

## Utilizando una Imagén de NodeJS

```bash
docker pull node
```

Se recomiendan las imagenes Alpine ya que son más ligeras, pero ya que es una demostración utilizaremos la última versión.

En caso de **error** en el que la imagen Docker no se inicia con normalidad podemos utilizar el siguiente comando que iniciará nuestra imagen en un contenedor:

```bash
docker run -d -it node
```

## Creando Imagenes Docker personalizadas | Dockerfile

¿Qué es un Dockerfile?

> Es un archivo de texto que contiene las instrucciones para construir una imagen de Docker. Define el entorno y la configuración necesarios para ejecutar la aplicación.

En la carpeta `Lección 1 - Docker Image - API` tenemos un simple proyecto de NodeJs que montaría un servidor con Express, vamos a montar una imagén desde 0.

Por lo tanto creamos un archivo llamado Dockerfile en dicho proyecto.

```bash
# Podemos ejecutar el siguiente comando en una bash de linux en la raiz del proyecto
cd L1*; echo "" > Dockerfile
```

Ahora podemos crear nuestra imagén personalizada

Dockerfile

```dockerfile
FROM node:17-alpine

# WORKDIR: Es donde queremos que se ejecuten los comandos que le indicaremos a Docker
WORKDIR /app

# Directorio del la App | Directorio en el Contenedor Docker
# Un . indica que es el lugar dónde estamos actualmente
COPY . .

# RUN: Comunica a Docker que ejecute el siguiente comando
RUN npm install

# Exponer los Puertos para el contenedor
EXPOSE 4000

# Comandos a ejecutar DESPUES de haber montado la imagén
CMD [ "node", "app.js"]
```

Ahora en la carpeta en la que esta la imagén docker hacemos build de esta misma para poder usarla en un contenedor.

```bash
docker build -t my_app .
#docker build -t <nombre_app> <directorio>
```

Una vez finalizado podremos observa esta imagén en nuestro Docker desktop

## Dockerignore

Este simplemente es un archivo con indiciaciones para Docker que ignore archivos, carpetas que no queremos que se suban al contenedor como en este caso **_node_modules_**, similar a `.gitignore` si has trabajado con este.

Puede ser útil para casos en los que se esta utilizando dicho proyecto de forma local y lo queremos subir a un Contenedor para posteriormente ser utilizado en _Kubernetes_ por ejemplo.

.dockerignore

```bash
# Ignora los modulos de node para que no se copien en la imagén
node_modules

# En este caso ignoraria todos los archivos que cumplan dicha extensión, en este caso los archivos de texto
*.txt
```

## Montar el Contenedor con la Terminal

Obtener todas las imagenes existentes en nuestro Docker

```bash
docker images

#Obtendremos
#Repository | Tag | Image ID | Created | Size
```

Levantar la imagén Docker

```bash
# docker run <repository>
# docker run --name <nombre_personalizado> <nombre_imagen>
docker run --name myapp_c1 my_app
```

Pero tenemos un pequeño problema, este contenedor no lo podremos visitar desde nuestro `http://localhost:4000` así que debemos exponerlo al navegador.

```bash

# Listamos los contenedores
docker ps

# Detenemos el contenedor
# docker stop <nombre__contenedor | id_contenedor>
# Podemos darle el nombre o la id
docker stop my_app

# Iniciamos el contenedor, pero esta vez exponiendolo al navegador
# docker run --name <nombre_contenedor> <nombre_imagen> -p <puerto_local>:<puerto_imagen>
docker run --name my_app_c2 -p 4000:4000 my_app
```

Ahora podemos visitar la app en nuestro navegador

```bash
http://localhost:4000/
```

Podemos obtener una información más adecuada sobre los contenedores activos y finalizados con el comando `docker ps -a`

## Caching de capas

Imaginemos que queremos montar denuevo la imagén anterior, pero en otro contenedor, podríamos ahorrar tiempo si ya tuvieramos una **_cache_** de dichas imagenes.

Docker se encarga de esto automáticamente, pero puede llegar a ser un problema cuando querramos actualizar la app con algunos cambios hechos.

```bash
# Esto creará la imagén denuevo, pero con los nuevos cambios
docker build -t my_app3 .
```

En los registros de la terminal poedmos observar lo siguiente.

```bash
 => CACHED [2/4] WORKDIR /app
 => CACHED [3/4]
```
Por tanto podríamos decir que Docker ***Recuerda*** que hemos hecho esto antes.

Vamos a realizar un pequeño cambio a nuestro proyecto de NodeJs ya que queremos hacer ***cache*** a nuestros modulos de npm así no tenemos que ejecutar dicho comando denuevo.

```dockerfile
FROM node:17-alpine

WORKDIR /app

# Copiamos el package.json antes así podremos instalar las dependencias
COPY package.json .

# Movemos este comando antes de copiar la app
RUN npm install

COPY . .


EXPOSE 4000

CMD [ "node", "app.js"]
```

Recibimos en la terminal

```bash
CACHED [4/4] RUN npm install
```

Por lo tanto ha funcionado!


## Eliminando imagenes

Ahora tenemos un problema estamos creando imagenes sin parar y a lo mejor queremos eliminar algunas en especifico para ello tenemos los siguientes comandos.

```bash
#Listamos las imagenes
docker images

#docker image rm <nombre_imagen>
docker image rm my_app5

#Eliminar imagenes que tienen contenedores, por lo tanto estan en 'uso'
docker image rm -f my_app6

#Listamos las imagenes para verificar
docker images
```
## Eliminando Contenedores

```bash
docker container rm <nombre_contenedor>
```

## Versiones de imagenes

```bash
#docker build -t <nombre_app>:<version_tag>
docker build -t my_app:v1 .
```

## Fuentes

[Docker Crash Course](https://youtu.be/31ieHmcTUOk?si=CflT7FgUEm7HbYXe)

[Qué es Docker - Amazon Web Services](https://aws.amazon.com/es/docker/)

[Qué es Docker - Oracle](https://www.oracle.com/es/cloud/cloud-native/container-registry/what-is-docker/#:~:text=Un%20contenedor%20de%20Docker%20es,c%C3%B3digo%20y%20tiempo%20de%20ejecuci%C3%B3n.)

[Aprende Docker - Microsoft](https://learn.microsoft.com/es-es/training/modules/intro-to-docker-containers/)

[Docker CLI Cheat Sheet](https://docs.docker.com/get-started/docker_cheatsheet.pdf)