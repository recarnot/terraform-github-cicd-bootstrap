#!/bin/bash

ESCAPED_VALUE=$(echo $2 | sed -e 's/[]\/$*.^[]/\\&/g');

sed -e "s/T_KEY/$1/" -e "s/my-hcl/false/" -e "s/T_VALUE/$ESCAPED_VALUE/" -e "s/T_SECURED/$3/" -e "s/T_WSID/$TF_WORKSPACE_ID/" < ./scripts/variable.payload.template  > variable.json
curl --header "Authorization: Bearer $TF_TOKEN" --header "Content-Type: application/vnd.api+json" --data @variable.json "https://app.terraform.io/api/v2/vars"

rm -f variable.json
