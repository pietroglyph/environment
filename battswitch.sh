#!/usr/bin/env bash

BAT_CHARGE_CFG="Custom:50-85"
if [[ "$1" == "g" ]]; then
  BAT_CHARGE_CFG="Standard"
fi

printf "UEFI setup password: "
read -s UEFI_PASS
printf "\n"

doas cctk --PrimaryBattChargeCfg="$BAT_CHARGE_CFG" --ValSetupPwd="$UEFI_PASS"

unset UEFI_PASS
