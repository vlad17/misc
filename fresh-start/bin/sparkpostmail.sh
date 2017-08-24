#!/bin/bash
# sparkpostmail.sh recipient subject body

if ! [ -f $HOME/.sparkpostapi ]; then
    echo 'expecting ~/.sparkpostapi to exist with api key'
    exit 1
fi

json='{
    "options": {
      "sandbox": true
    },
    "content": {
      "from": "sandbox@sparkpostbox.com",
      "subject": "'"$2"'",
      "text": "'"$3"'"
    },
    "recipients": [{ "address": "'"$1"'" }]
}'

curl -X POST \
  https://api.sparkpost.com/api/v1/transmissions \
  -H "Authorization: $(cat $HOME/.sparkpostapi)" \
  -H "Content-Type: application/json" \
  -d "$json"
