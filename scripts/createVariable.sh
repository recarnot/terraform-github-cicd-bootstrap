#!/bin/bash

ESCAPED_VALUE=$(echo $3 | sed -e 's/[]\/$*.^[]/\\&/g');

sed -e "s/my-key/$2/" -e "s/my-hcl/false/" -e "s/my-value/$ESCAPED_VALUE/" -e "s/my-sensitive/$4/" -e "s/my-workspace-id/$TFE_WORKSPACE_ID/" < ./scripts/variable.payload.template  > variable.json
curl --header "Authorization: Bearer $1" --header "Content-Type: application/vnd.api+json" --data @variable.json "https://app.terraform.io/api/v2/vars"

rm -f variable.json
