#!/bin/bash


ASSETS_DIR="assets"
OUTPUT_FILE="sonidos.json"

echo "--- INICIO DE DEPURACIÓN ---"
echo "Directorio de activos a procesar: $ASSETS_DIR"

if [ ! -d "$ASSETS_DIR" ]; then
    echo "ERROR: El directorio '$ASSETS_DIR' no existe. Asegúrate de ejecutar el script en la carpeta correcta."
    exit 1
fi

entries=()
total_dirs=0

echo "Listando todos los directorios encontrados en '$ASSETS_DIR':"
find "$ASSETS_DIR" -maxdepth 1 -mindepth 1 -type d
echo "----------------------------------------"

for dir in "$ASSETS_DIR"/*/; do
    [ -d "$dir" ] || continue
    
    id=$(basename "$dir")
    
    # Busca la imagen .jpg, .jpeg O .png
    image_file=$(find "$dir" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) -print -quit)
    
    # Busca el audio .mp3
    audio_file=$(find "$dir" -maxdepth 1 -name "*.mp3" -print -quit)
    
    echo "Procesando directorio: $id"
    echo "  -> Buscando JPG/JPEG/PNG..."
    echo "  -> Encontrado imagen: '$image_file'"
    echo "  -> Buscando MP3..."
    echo "  -> Encontrado audio: '$audio_file'"
    
    if [ -n "$image_file" ] && [ -n "$audio_file" ]; then
        image_name=$(basename "$image_file")
        id_lower=$(echo "$id" | tr '[:upper:]' '[:lower:]')
        escaped_image_name=$(printf "%s" "$image_name" | sed 's/"/\\"/g')
        json_entry="\"$id_lower\": { \"title\": \"$id\", \"image\": \"$escaped_image_name\" }"
        entries+=("$json_entry")
        total_dirs=$((total_dirs+1))
        echo "  -> JSON válido, agregado a la lista."
    else
        echo "  -> Saltando: No se encontró una imagen o un archivo .mp3."
    fi
    echo "----------------------------------------"
done

echo "--- FIN DE DEPURACIÓN ---"
echo "Total de directorios procesados con éxito: $total_dirs"
echo "Generando el archivo JSON final en '$OUTPUT_FILE'."

printf "{\n%s\n}" "$(IFS=$',\n'; echo "${entries[*]}")" > "$OUTPUT_FILE"

echo "Contenido de '$OUTPUT_FILE':"
cat "$OUTPUT_FILE"