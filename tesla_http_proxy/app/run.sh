#!/usr/bin/with-contenv bashio
set -e

# read options
export CONFIG_PATH=/data/options.json
export KEY_NAME="$(bashio::config 'key_name')"
export VIN="$(bashio::config 'vin')"

export GNUPGHOME=/data/gnugpg
export PASSWORD_STORE_DIR=/data/password-store

if [ -f /share/tesla/private.pem ]; then
  printf "\n### Found existing keypair ###\n"
else
  printf "\n### Generating keypair ###\n"
  openssl ecparam -genkey -name prime256v1 -noout > private.pem
	openssl ec -in private.pem -pubout > public.pem
  printf "\n### Requesting vehicle access ###\n"
  printf "\n### Tap your NFC card or keyfob on the center console and then tap 'Confirm' on the vehicle screen. ###\n"
 	/root/bin/tesla-control -vin $VIN -ble add-key-request public.pem owner cloud_key
  # TODO check for success
  mkdir -p /share/tesla
  cp private.pem /share/tesla/private.pem
fi
