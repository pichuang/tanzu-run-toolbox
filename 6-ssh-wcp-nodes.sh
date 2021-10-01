#!/bin/bash
source source-environment

kubectl get nodes -o=custom-columns=WCP_VM_NAME:.metadata.name,WCP_VM_IP:.status.addresses[].address

echo
echo "Steps"
echo "1. SSH into VCSA"
echo "2. Type Password"
echo "3. Use shell and switch to bash mode"
echo "4. Execute /usr/lib/vmware-wcp/decryptK8Pwd.py > wcp_info"
echo "5. cat wcp_info"
echo "6. logout"
echo

ssh root@$VCENTER_IP

