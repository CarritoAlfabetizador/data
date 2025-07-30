#!/bin/bash

# Ruta base de los assets (podés cambiarla si está en otro lugar)
BASE_DIR="assets"

# Recorre cada subdirectorio dentro de assets/
for dir in "$BASE_DIR"/*/; do
  # Elimina la barra final y extrae el nombre del subdirectorio
  id=$(basename "$dir")

  echo "Procesando carpeta: $id"

  # Renombrar imagen JPG si existe
  for img in "$dir"*.jpg "$dir"*.jpeg "$dir"*.JPG "$dir"*.JPEG; do
    [ -e "$img" ] || continue  # Salta si no hay archivo
    mv "$img" "$dir/${id}.jpg"
    echo "→ Imagen renombrada: ${id}.jpg"
    break
  done

  # Renombrar audio MP3 si existe
  for audio in "$dir"*.mp3 "$dir"*.MP3; do
    [ -e "$audio" ] || continue  # Salta si no hay archivo
    mv "$audio" "$dir/${id}.mp3"
    echo "→ Audio renombrado: ${id}.mp3"
    break
  done
done

echo "✅ Renombramiento completado."
