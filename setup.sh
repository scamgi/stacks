#!/bin/bash

# --- Script di bootstrap per un nuovo Raspberry Pi ---
# Eseguire con: curl -sL https://indirizzo_raw_del_tuo_script | bash

echo "=== Inizio del Bootstrap del Raspberry Pi ==="

# 1. Aggiornamento del Sistema
sudo apt update && sudo apt upgrade -y

# 2. Installazione di pacchetti essenziali
sudo apt install -y git ufw docker.io docker-compose

# 3. Configurazione di Docker
echo "Aggiungo l'utente 'pi' (o il tuo utente) al gruppo docker..."
sudo usermod -aG docker ${USER}
echo "Docker configurato. Dovrai fare logout/login per applicare le modifiche al gruppo."

# 4. Configurazione del Firewall (UFW)
echo "Configurazione del firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh      # 22/tcp
sudo ufw allow http     # 80/tcp
sudo ufw allow https    # 443/tcp
sudo ufw allow 51820/udp  # Per WireGuard
# Aggiungi qui altre porte che ti servono
sudo ufw enable

# # 5. Preparazione dell'SSD
# echo "Configurazione del punto di mount per l'SSD..."
# SSD_MOUNT_POINT="/mnt/ssd"
# sudo mkdir -p ${SSD_MOUNT_POINT}
# # NOTA: Questo presume che tu abbia già partizionato e formattato l'SSD.
# # Aggiungi qui il comando per montarlo e aggiungerlo a /etc/fstab se necessario.
# # Esempio: sudo mount /dev/sda1 ${SSD_MOUNT_POINT}
# # Esempio fstab: echo 'UUID=IL_TUO_UUID ${SSD_MOUNT_POINT} ext4 defaults,auto,users,rw,nofail 0 0' | sudo tee -a /etc/fstab

echo "=== Bootstrap completato! ==="
echo "Azioni richieste:"
echo "1. Riavvia il sistema o fai logout/login per applicare i permessi di Docker."
echo "2. Vai in ogni cartella dentro 'stacks', copia .env.template in .env e inserisci i valori."
echo "3. Avvia i tuoi stack con 'docker compose up -d'."
