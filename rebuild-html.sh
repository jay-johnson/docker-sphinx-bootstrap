#!/bin/bash

echo "Rebuilding HTML with command: /root/containerfiles/deploy-new-content.sh" 
docker exec -it sphinx-bootstrap /root/containerfiles/deploy-new-content.sh
echo "Done rebuilding html"

exit 0
