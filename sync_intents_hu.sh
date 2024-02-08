#!/bin/sh
cd /tmp
apk add unzip
wget https://github.com/home-assistant/intents/archive/refs/heads/main.zip
unzip main.zip -d /tmp/intents
if [ ! -d "/config/custom_sentences" ]; then
  mkdir -p /config/custom_sentences
fi
if [ ! -d "/config/custom_sentences/hu" ]; then
  mkdir -p /config/custom_sentences/hu
fi
if [ -s "/config/custom_sentences/hu/responses.yaml" ]; then
  echo "A /config/custom_sentences/hu/responses.yaml fájl nem üres. Szeretnéd törölni a meglévő tartalmat és frissíteni? [y/N]"
  read -r answer

  if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    echo "Törlés és frissítés..."
    > /config/custom_sentences/hu/responses.yaml
    for file in /tmp/intents/intents-main/responses/hu/*; do
      if [ -s "$file" ]; then
        cat "$file" >> /config/custom_sentences/hu/responses.yaml
      fi
    done
  else
    echo "A responses.yaml fájl frissítése kihagyva."
  fi
else
  for file in /tmp/intents/intents-main/responses/hu/*; do
    if [ -s "$file" ]; then
      cat "$file" >> /config/custom_sentences/hu/responses.yaml
      echo "---" >> /config/custom_sentences/hu/responses.yaml
    fi
  done
fi
cp -r /tmp/intents/intents-main/sentences/hu/* /config/custom_sentences/hu/
echo "A fájlok összefűzése és másolása megtörtént."
