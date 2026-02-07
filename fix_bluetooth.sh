TIEMPO_ESPERA=1

if [ "$(id -u)" -ne 0 ]; then
  echo "This program requires to be executed as superuser."
  pkexec sudo -p bash $(realpath $0)
  exit 0
fi

while true; do

  echo " >>> Attempt #$TIEMPO_ESPERA. <<< "

  if bluetoothctl list | grep -q "Controller"; then
    echo "Controller detected."
    break
  fi

  systemctl stop bluetooth

  rmmod -v bnep
  rmmod -v btusb
  rmmod -v bluetooth
  rmmod -v btintel
  rmmod -v btrtl
  rmmod -v btmtk
  rmmod -v btbcm
  rmmod -v rfcomm
  rmmod -v bluetooth

  modprobe -v bnep
  modprobe -v btusb
  modprobe -v bluetooth
  modprobe -v btintel
  modprobe -v btrtl
  modprobe -v btmtk
  modprobe -v btbcm
  modprobe -v rfcomm
  modprobe -v bluetooth

  systemctl start bluetooth

  sleep $TIEMPO_ESPERA
  TIEMPO_ESPERA=$((TIEMPO_ESPERA+1))
done

echo "Done."
exit 0
