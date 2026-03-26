#!/bin/bash
# ===============================
# Fetch latest Postman Collection & Environment and Run Newman Tests
# ===============================

# Set your Postman API key and IDs
POSTMAN_API_KEY="$POSTMAN_API_KEY"
COLLECTION_UID="53482408-53808324-5ce6-4c9f-9ee4-ae4cbd9c24c9"
ENV_UID="53482408-a03d84da-d417-4915-b5e8-31e2f02c720d"

# No subfolders created here to match GitHub root structure
mkdir -p results

# Fetch Collection - Saved as collection.json (matching GitHub)
curl -s -H "X-Api-Key: $POSTMAN_API_KEY" \
 https://api.getpostman.com/collections/$COLLECTION_UID \
 -o collection.json

# Fetch Environment - Saved as environment.json (matching GitHub)
curl -s -H "X-Api-Key: $POSTMAN_API_KEY" \
 https://api.getpostman.com/environments/$ENV_UID \
 -o environment.json

echo "Fetched latest Postman collection and environment!!!!!!!!!"
# Check if newman is installed
if ! command -v newman &> /dev/null
then
    echo "ewman not found! Installing............."
    npm install -g newman newman-reporter-htmlextra
fi

# Updated to use the new filenames and your local Test_data.JSON
newman run collection.json \
 -e environment.json \
 -d Test_Data.json \
 -r cli,htmlextra \
 --reporter-htmlextra-export report.html

# Check if the report was created
if [ -f "report.html" ]; then
    echo "Newman run complete! Report generated at report.html"
    xdg-open report.html
else
    echo "❌ Newman run failed. Check errors above."
fi
