# Função principal do menu
menu() {
    clear
    echo "===================================="
    echo "     GERENCIAMENTO FTP - MENU       "
    echo "===================================="
    echo "1) Startar ProFTPD"
    echo "2) Parar ProFTPD"
    echo "3) Testar ProFTPD"
    echo "4) Instalar ProFTPD"
    echo "5) Remover ProFTPD"
    echo "6) Configurar arquivo produto"
    echo "7) Instalar FileZilla"
    echo "8) Remover FileZilla"
    echo "9) Sair"
    echo "10) Reiniciar ProFTPD"
    echo "===================================="
    echo -n "Escolha uma opção: "
    read opcao

    case $opcao in
        1) start_proftpd ;;
        2) stop_proftpd ;;
        3) test_proftpd ;;
        4) install_proftpd ;;
        5) remove_proftpd ;;
        6) config_proftpd ;;
        7) install_filezilla ;;
        8) remove_filezilla ;;
        9) echo "Saindo..."; exit 0 ;;
        10) Restart_proftpd ;;
        *) echo "Opção inválida!"; sleep 1; menu ;;
    esac
}

# Funções ProFTPD
start_proftpd() {
    echo "Iniciando ProFTPD..."
    sudo systemctl start proftpd
    systemctl status proftpd --no-pager
    read -p "Pressione Enter para voltar ao menu..."
    menu
}

stop_proftpd() {
    echo "Parando ProFTPD..."
    sudo systemctl stop proftpd
    systemctl status proftpd --no-pager
    read -p "Pressione Enter para voltar ao menu..."
    menu
}

test_proftpd() {
    echo "Verificando status do ProFTPD..."
    if systemctl is-active --quiet proftpd; then
        echo " O ProFTPD está rodando!"
    else
        echo " O ProFTPD não está rodando!"
    fi
    read -p "Pressione Enter para voltar ao menu..."
    menu
   
}

install_proftpd() {
    echo "Instalando ProFTPD..."
    sudo apt update -y
    sudo apt install proftpd -y
    echo "Copiando configuração padrão..."
    if [ -f /etc/proftpd/proftpd.conf ]; then
        sudo cp /etc/proftpd/proftpd.conf /etc/proftpd/produto.conf
        echo "Arquivo /etc/proftpd/produto.conf criado."
    fi
    read -p "Pressione Enter para voltar ao menu..."
    menu
}

remove_proftpd() {
    echo "Removendo ProFTPD..."
    sudo apt remove --purge proftpd* -y
    sudo rm -f /etc/proftpd/produto.conf
    echo "ProFTPD e arquivos associados removidos."
    read -p "Pressione Enter para voltar ao menu..."
    menu
}

config_proftpd() {
    echo "Restaurando arquivo de configuração padrão..."
    if [ -f /etc/proftpd/proftpd.conf ]; then
        sudo cp /etc/proftpd/proftpd.conf /etc/proftpd/produto.conf
        echo "Arquivo padrão copiado novamente para /etc/proftpd/produto.conf"
    else
        echo "O arquivo padrão /etc/proftpd/proftpd.conf não foi encontrado!"
    fi
    read -p "Pressione Enter para voltar ao menu..."
    menu
}

# Funções FileZilla
install_filezilla() {
    echo "Instalando FileZilla..."
    sudo apt update -y
    sudo apt install filezilla -y
    echo "FileZilla instalado com sucesso!"
    read -p "Pressione Enter para voltar ao menu..."
    menu
}

remove_filezilla() {
    echo "Removendo FileZilla..."
    sudo apt remove --purge filezilla -y
    echo "FileZilla removido com sucesso!"
    read -p "Pressione Enter para voltar ao menu..."
    menu
}

Restart_proftpd() {
    echo "Reiniciando ProFTPD..."
    sudo systemctl restart proftpd
    echo "FileZilla Reiniciado com Sucesso!"
    read -p "Pressione Enter para voltar ao menu..."
    menu
}


# Inicia o menu
menu
