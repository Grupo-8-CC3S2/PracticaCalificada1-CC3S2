# bash y su sintaxis
## #!    -e -u -
``!#/usr/bin/env bash ``
el sistema debe usar bash para la ejecucion del script 
set -e  ó  set -o errexit
set -u  ó  set -o nounset 
set -o pipefail
usamos el comando interno para configurar el comportamiento 
o activar la deteccion de errores en a ejecucion de comandos
cmd1 | cmd2  | cmd3
con set -e bash guarda el estado de salida del ultimo comando 
en '$?'  pero si , por ejemplo, cmd2 = 12, cmd3 = 0
$? es 0 , se ejeecuto con exito pero no es asi pues el pipeline falla debido a cmd2.
`` cmd1 ← 0 errores ← true | cmd ← 2 ← false  | cm3 ← 0 ← true``
mientras que set -o pipefail 
analiza todos los comandos del pipeline y guarda el exit status del primero comando que falla , o el estado de salida del ultimo cmd en el pipeline, luego sera -e quien use $? para indicar que la ejecucion esta correcto o fallo
terminando o no la ejecucion del shell script, que esta siendo interpretado por bash
algo acerca de #!/usr/bin/env,  #! indica que el script no es un binario ejecutable que kernel pueda cargar directamente , lo que se hace es llamar a env quien buscara a bash para usarlo como interptete y ejecutar el script
 buscar ( bash )

## IFS 
acerca del separador de campo 
bash usa IFS: 
1. para separar la salida de un comando  en palabras de acuerdo al IFS

IFS = ":"
salida = $(printf 'a:b:c\n')
for x in $salida; do 
    echo "$x"
done
a
b
c
*nota* : $ es un operador de expansion osea un operador que obtiene el valor de $(VARIABLE) de la variable.

en el caso actual 

usamos IFS = $'\n'  '\n' es una cadena \ + n , \n es para bash \ n caracteres normales. entonces se usa IFS=$'\n' IFS ← salto de linea como separador (ANSI-C quoting) de modo que bash lo interpreta como salto de linea.
y ademas agregamos '\t'  

## umask 
es un comando especial para configurar los permisos de archivos y directorios nuevos, los nuevos archivos se cren con permisos 
propietario-grupo-otros
rw-rw-rw 666 , y directorios nuevos con rwxrwxrwx 777
entonces umask 027 , hace la resta binaria 666-027 = 640  rw -r ---
        777-027 = 750  rwx-r ---
6 = 110 (r=1, w=1, x=0)
Usuario: 110  (rw-)
Grupo:   110  (rw-)
Otros:   110  (rw-)

0 = 000
2 = 010
7 = 111
la resta es   & ~umask
110 & (complemento(000))  
110 & 111   = 110  rw  = 6 y asi los 

110 & 101  =  100  = 4

110 & 000 = 000 = 0
640  = rw- r- .
           
demas

# comando de sustitucion $()

variablee = $( )  asigna a ala variable la salida , el argumento debe ser un comando ls (externo) o echo (interno)

salida = $(ls /home/esau | wc -l)

# set  -o noclobber
comando para configurar orpciones de shell, variables en entorno interna...
-o cambiamos una opcion de shell por su nombre
noclobber previene sobreescribir archivos existentes mediante el  operador de redireccion > 
pero si añadir si >> , es el equivalente a append()
echo "texto" > a.txt

# ${VAR} 
operador de expansion mas general 
permite agregar modificadores $VAR
ahora VAR puede ser modificado
:- usa la var como contenedor solo si esta vacia
:= asginacion a la variable
:+ solo si existe 

${PYTHON:-python3} 
ademas PY = " " permite que el resultado sea una cadena 

# se tienen las configuraciones previas para el rastreo de errores, variables declaradas , configuracion de permisos, manejo de reescritura , creacio de un directorio temporal, ahora se 

dig @[servidordns] tipo nombre

-- "lo que sigue son cadenas"

para ejecutar 
TARGET=example.com DNS_SERVER=8.8.8.8 ./archivo_bash

make run OBJETIVO=example.com SERVIDOR=8.8.8.8

sudo TARGET=example.com DNS_SERVER=8.8.8.8 bash ./src/dns_check.sh