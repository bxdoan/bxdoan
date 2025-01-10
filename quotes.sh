#!/bin/bash

# Fetch quote and parse using Python
response=$(curl -s https://quotes-api-self.vercel.app/quote)
quote_data=$(python -c "
import json, sys
try:
    data = json.loads('''$response''')
    print(data['quote'])
    print(data['author'])
except:
    sys.exit(1)
")

# Split response into quote and author
quote=$(echo "$quote_data" | head -n 1)
author=$(echo "$quote_data" | tail -n 1)

# Create temporary file
temp_file=$(mktemp)

# Calculate padding for center alignment (assuming 80 characters width)
printf "<div align=\"center\">\n\n" > "$temp_file"
printf "> %s\n\n" "$quote" >> "$temp_file"
printf "> — %s\n\n" "$author" >> "$temp_file"
printf "</div>\n\n" >> "$temp_file"

# Append rest of README.md content (if any) after line 8
if [ -f README.md ]; then
    tail -n +9 README.md >> "$temp_file"
fi

# Replace original file with temp file
mv "$temp_file" README.md

# Update timestamp
date +"%Y-%m-%d %H:%M:%S" > TIMESTAMP.txt
