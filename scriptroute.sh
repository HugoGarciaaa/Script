#!/bin/bash
# Script para configurar rede manualmente de forma interativa (usando iproute2)

echo "==== Configuração de Rede (iproute2) ===="
sleep 1

# Listar interfaces
echo "[INFO] Listando interfaces de rede..."
ip link show | awk -F: '{print $2}' | sed 's/ //g' | grep -v "^$"
sleep 1

# Perguntar interface
read -p "Digite o nome da interface (ex: enp0s3): " INTERFACE

# Perguntar IP
read -p "Digite o endereço IP com máscara (ex: 192.168.22.106/25): " IPADDR

# Perguntar Gateway
read -p "Digite o gateway (ex: 192.168.22.126): " GATEWAY

# Perguntar DNS
read -p "Digite o DNS primário (ex: 8.8.8.8): " DNS1
read -p "Digite o DNS secundário (ex: 8.8.4.4): " DNS2

echo "[INFO] Configurando interface $INTERFACE..."
sleep 2

# Desativa a interface
ip link set $INTERFACE down

# Limpa endereços antigos
ip addr flush dev $INTERFACE

# Atribui novo endereço IP
ip addr add $IPADDR dev $INTERFACE

# Ativa a interface
ip link set $INTERFACE up

# Mostra configuração da interface
ip a show dev $INTERFACE

# Remove rota padrão antiga (se existir)
ip route del default 2>/dev/null

# Adiciona nova rota padrão
ip route add default via $GATEWAY dev $INTERFACE

# Configura DNS
echo -e "nameserver $DNS1\nnameserver $DNS2" > /etc/resolv.conf

echo "[INFO] Configuração aplicada!"
sleep 2
echo "[INFO] Testando conectividade com DNS ($DNS1)..."
sleep 3
ping -c 4 $DNS1


