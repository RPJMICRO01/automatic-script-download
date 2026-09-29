#!/bin/bash

# Colores para la terminal
blueC="\e[0;34m\033[1m"
endC="\033[0m\e[0m"

# Función para salir limpiamente con Ctrl+C
function ctrl_c(){ 
    echo -e "\n\n[!] Saliendo...\n"
    exit 1
}
trap ctrl_c INT

# Verificamos si existe el archivo de listas
if [ ! -f "lista.txt" ]; then
    echo -e "[!] No se encuentra el archivo lista.txt"
    exit 1
fi



# Pedimos los datos interactivos al usuario
echo -n "[?] Ingresa el nombre de la serie (ej: The.Simpsons) : "
read serie

echo -n "[?] Ingresa el número de temporada (ej: 01, 02 ,03) : "
read temporada

echo -n "[?] Ingresa el número de episodio con el que inicia la lista (ej: 1,2,3) : "
read episodio


echo -e "\n${blueC}[+] Iniciando descargas...${endC}\n"

# Leemos el archivo línea por línea de forma eficiente
while IFS= read -r direccion; do
    # Ignorar líneas vacías por seguridad
    [ -z "$direccion" ] && continue

    echo -e "${blueC}[+] Descargando: ${serie}.S${temporada}.E${episodio}${endC}"

    # Descargamos el archivo con wget
    wget -q --show-progress "$direccion" -O "temp_video.mp4"

    # Si la descarga es exitosa, lo renombramos con el formato deseado
    if [ $? -eq 0 ]; then
        mv "temp_video.mp4" "${serie}.S${temporada}.E${episodio}.mp4"
        echo -e "[✓] Guardado como: ${serie}.S${temporada}.E${episodio}.mp4\n"
    else
        echo -e "[!] Error al descargar la dirección ${direccion}\n"
        rm -f "temp_video.mp4"
    fi

    # Incrementamos el número de episodio para la siguiente vuelta
    ((episodio++))

done < lista.txt

echo -e "${blueC}[+] ¡Todas las descargas han finalizado!${endC}"
