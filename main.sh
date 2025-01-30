#!/bin/bash

# Ensure script stops on errors
set -e

# Authenticate and retrieve access token
ACCESS_TOKEN=$(curl -s --request POST \
  --url https://login.cloud.camunda.io/oauth/token \
  --header 'content-type: application/json' \
  --data "{\"client_id\":\"$CLIENT_ID\",\"client_secret\":\"$CLIENT_SECRET\",\"audience\":\"zeebe.camunda.io\",\"grant_type\":\"client_credentials\"}" \
  | sed 's/.*access_token":"\([^"]*\)".*/\1/')

# Check if ACCESS_TOKEN was retrieved successfully
if [ -z "$ACCESS_TOKEN" ]; then
  echo "Error: Failed to retrieve access token"
  exit 1
fi

echo "Successfully retrieved access token."

# Convert comma-separated list of files into an array
IFS=',' read -r -a FILE_ARRAY <<< "$FILES"

# Prepare the curl command with all files
CURL_CMD="curl -s -X POST https://$REGION.zeebe.camunda.io/$CLUSTER_ID/v2/deployments -H \"Authorization: Bearer $ACCESS_TOKEN\" -H 'Content-Type: multipart/form-data'"

for FILE in "${FILE_ARRAY[@]}"; do
  CURL_CMD+=" -F \"resources=@$FILE\""
done

# Execute the curl command
DEPLOY_RESPONSE=$(eval $CURL_CMD)

# Check if deployment was successful
if echo "$DEPLOY_RESPONSE" | grep -q '"deploymentKey":' || echo "$DEPLOY_RESPONSE" | grep -q '"formId":'; then
  echo "Deployment successful!"
else
  echo "Error: Deployment failed."
  echo "Response: $DEPLOY_RESPONSE"
  exit 1
fi