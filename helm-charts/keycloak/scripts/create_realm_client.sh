#!/bin/sh

# Based on https://suedbroecker.net/2020/08/04/how-to-create-a-new-realm-with-the-keycloak-rest-api/
# More info https://www.keycloak.org/docs-api/18.0/rest-api/index.html#_realms_admin_resource

# Set the needed parameters
GRANT_TYPE=password
CLIENT_ID=admin-cli
KEYCLOAK_ENDPOINT="http://keycloak"
CONFIG="/config/realm-client-config.json"

echo "Adding utilities"
apk --update add curl

echo "----------------------------------"
echo "Waiting for Keycloak to be ready:"
echo "Endpoint for Keycloak: '${KEYCLOAK_ENDPOINT}'"
MAX_ATTEMPS=24
DELTA_TIME=5
attemp=0
SUCCESS=false
while [ ${attemp} -lt ${MAX_ATTEMPS} ]
do
    attemp=$((attemp+1))
    curl -s "${KEYCLOAK_ENDPOINT}/realms/master"
    if [ $? -eq 0 ]; then
        SUCCESS=true
        echo $(date), "Keycloak is ready"
        break
    fi
    echo $(date), "($attemp/$MAX_ATTEMPS)", "Keycloak is not ready yet"
    sleep $DELTA_TIME
done
if [ ${attemp} -eq ${MAX_ATTEMPS} ]; then
    if [ "${SUCCESS}" = "false" ]; then
        echo $(date), "Keycloak is not ready (max. attemps reached)"
        exit 1
    fi
fi

echo "----------------------------------"
echo "Get the bearer token from Keycloak"
sleep 10
access_token=$(curl -s --location --request POST "${KEYCLOAK_ENDPOINT}/realms/master/protocol/openid-connect/token" \
    --header "Content-Type: application/x-www-form-urlencoded" \
    --data-urlencode "grant_type=$GRANT_TYPE" \
    --data-urlencode "client_id=$CLIENT_ID" \
    --data-urlencode "username=${KEYCLOAK_ADMIN}" \
    --data-urlencode "password=${KEYCLOAK_ADMIN_PASSWORD}" \
    | sed -n 's|.*"access_token":"\([^"]*\)".*|\1|p')
if [ "$access_token" = "" ]; then
    echo "There is a problem reaching $KEYCLOAK_ENDPOINT to get the access token"
    exit 1
else
    echo "Bearer token obtained succesfully"
fi

# Create the realm (including client) in Keycloak
echo "----------------------------------"
echo "Loading configuration from $CONFIG"
result=$(curl -s -d @.$CONFIG -H "Content-Type: application/json" \
    -H "Authorization: bearer $access_token" \
    "${KEYCLOAK_ENDPOINT}/admin/realms")
if [ $? -ne 0 ]; then
    echo "There is a problem reaching $KEYCLOAK_ENDPOINT to load configuration"
    exit 1
else
    if [ "$result" = "" ]; then
        curl -s "${KEYCLOAK_ENDPOINT}/realms/${KEYCLOAK_REALM}"
        echo ""
        echo "The realm is created."
        exit 0
    else
        echo "It seems there is a problem with the realm creation: $result"
        exit 1
    fi
fi