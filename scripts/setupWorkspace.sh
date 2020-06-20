#!/bin/bash

sed "s/T_WS/$TFE_WORKSPACE_NAME/" < ./scripts/workspace.payload.template > workspace.json
curl --header "Authorization: Bearer $TFE_TOKEN" --header "Content-Type: application/vnd.api+json" --request POST --data @workspace.json "https://app.terraform.io/api/v2/organizations/$TFE_ORGANIZATION/workspaces" > workspace_result
wid=$(cat workspace_result | jq -r .data.id)

wid=$(curl -s --header "Authorization: Bearer $TFE_TOKEN" --header "Content-Type: application/vnd.api+json" "https://app.terraform.io/api/v2/organizations/$TFE_ORGANIZATION/workspaces/$TFE_WORKSPACE_NAME" | jq -r .data.id)
echo "TFE_WORKSPACE_NAME is $TFE_WORKSPACE_NAME"
echo "TFE_WORKSPACE_ID is $wid"
echo ::set-env name=TFE_WORKSPACE_ID::$wid

sed -e "s/T_ORGA/$TFE_ORGANIZATION/" -e "s/T_WS/$TFE_WORKSPACE_NAME/" < ./scripts/backend.template > backend.tf

curl --header "Authorization: Bearer $TFE_TOKEN" --header "Content-Type: application/vnd.api+json" "https://app.terraform.io/api/v2/vars?filter%5Borganization%5D%5Bname%5D=$TFE_ORGANIZATION&filter%5Bworkspace%5D%5Bname%5D=$TFE_WORKSPACE_NAME" > vars.json
x=$(cat vars.json | jq -r ".data[].id" | wc -l | awk '{print $1}')
for (( i=0; i<$x; i++ ))
do
  curl --header "Authorization: Bearer $TFE_TOKEN" --header "Content-Type: application/vnd.api+json" --request DELETE https://app.terraform.io/api/v2/vars/$(cat vars.json | jq -r ".data[$i].id")
done