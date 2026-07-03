#!/bin/bash

TIEMPO_ESPERA=1

if [ "$(id -u)" -ne 0 ]; then
  echo "This program requires to be executed as superuser."
  pkexec sudo -p bash "$(realpath "$0")"
  exit 0
fi

while true; do

  echo " >>> Attempt #$TIEMPO_ESPERA. <<< "

  if bluetoothctl list | grep -q "Controller"; then
    echo "Controller detected."
    break
  fi

  # 1. Parar el servicio de Bluetooth
  systemctl stop bluetooth

  # 2. PAUSAR el gestor de red para que libere 'bnep' (no perderás internet de forma permanente)
  systemctl stop NetworkManager 2>/dev/null

  # Matar procesos rebeldes
  killall -9 bluetoothd 2>/dev/null
  sleep 1

  # 3. Descargar módulos (ahora bnep no debería oponer resistencia)
  modprobe -r -v bnep
  modprobe -r -v rfcomm
  modprobe -r -v hidp
  modprobe -r -v hci_uart
  modprobe -r -v btusb
  modprobe -r -v btintel
  modprobe -r -v btrtl
  modprobe -r -v btmtk
  modprobe -r -v btbcm

  # 4. Intentar descargar el núcleo por si acaso
  if ! modprobe -r -v bluetooth; then
      echo "---"
      echo "Si ves esto, dinos qué sale abajo:"
      lsmod | grep bluetooth
      echo "---"
  fi

  # 5. Volver a cargar los módulos limpios
  modprobe -v bluetooth
  modprobe -v btusb
  modprobe -v bnep
  modprobe -v rfcomm
  modprobe -v hidp
  modprobe -v btintel
  modprobe -v btrtl
  modprobe -v btmtk
  modprobe -v btbcm

  # 6. Reactivar los servicios (Bluetooth y Red)
  systemctl start NetworkManager 2>/dev/null
  systemctl start bluetooth

  sleep $TIEMPO_ESPERA
  TIEMPO_ESPERA=$((TIEMPO_ESPERA+1))
done

echo "Done."
exit 0
