#!/bin/bash
# ===============================
# Fetch latest Postman Collection & Environment and Run Newman Tests
# ===============================

# Set your Postman API key and IDs
POSTMAN_API_KEY="$POSTMAN_API_KEY"
COLLECTION_UID="53482408-53808324-5ce6-4c9f-9ee4-ae4cbd9c24c9"
ENV_UID="53482408-a03d84da-d417-4915-b5e8-31e2f02c720d"

# Create folders if they don't exist
mkdir -p collections environments results

# Fetch Collection
curl -s -H "X-Api-Key: $POSTMAN_API_KEY" \
 https://api.getpostman.com/collections/$COLLECTION_UID \
 -o collections/users.postman_collection.json

# Fetch Environment
curl -s -H "X-Api-Key: $POSTMAN_API_KEY" \
 https://api.getpostman.com/environments/$ENV_UID \
 -o environments/dev_environment.json

echo "✅ Fetched latest Postman collection and environment!"

# ===============================
# Run Newman and generate HTML report
# ===============================

# Check if newman is installed
if ! command -v newman &> /dev/null
then
    echo "⚠️ Newman not found! Installing..."
    npm install -g newman newman-reporter-htmlextra
fi

# ✅ ONLY THIS PART CHANGED
newman run collections/users.postman_collection.json \
 -e environments/dev_environment.json \
 -r cli,htmlextra \
 --reporter-htmlextra-export results/report.html \
 --bail

# Check if the report was created
if [ -f "results/report.html" ]; then
    echo "✅ Newman run complete! Report generated at results/report.html"
    xdg-open results/report.html
else
    echo "❌ Newman run failed. Check errors above."
fi
