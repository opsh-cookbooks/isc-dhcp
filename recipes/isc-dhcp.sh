apt-get update && apt-get install isc-dhcp-server

[ ! -d "/opt/dhcp" ] && mkdir /opt/dhcp

template_cp "bind-ip.txt" /opt/dhcp
template_cp "show-lease-dhcp.sh" /opt/dhcp
template_cp "update-dhcp.sh" /opt/dhcp


/opt/dhcp/update-dhcp.sh -f /opt/dhcp/bind-ip.txt

