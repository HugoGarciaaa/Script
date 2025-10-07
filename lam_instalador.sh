#!/bin/bash

install_linux_tools() {
    echo "[+] Instalando utilitários Linux..."
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y curl wget git unzip software-properties-common
    echo "[+] Testando comandos..."
    which curl && which git && which unzip && echo " Ferramentas básicas OK" || echo " Erro nos utilitários"
}

install_apache() {
    echo "[+] Instalando Apache..."
    sudo apt install -y apache2
    sudo systemctl enable apache2
    sudo systemctl start apache2

    echo "[+] Testando Apache..."
    if curl -s http://localhost | grep -q "Apache"; then
        echo "Apache está funcionando!"
    else
        echo "Apache pode não estar funcionando corretamente."
    fi
}

install_mariadb() {
    echo "[+] Instalando MariaDB..."
    sudo apt install -y mariadb-server
    sudo systemctl enable mariadb
    sudo systemctl start mariadb
    sudo mysql_secure_installation

    echo "[+] Testando MariaDB..."
    if sudo mysql -u root -e "SHOW DATABASES;" > /dev/null 2>&1; then
        echo " Conectado ao MariaDB com sucesso!"
    else
        echo " Falha ao conectar ao MariaDB."
    fi
}

install_mysql() {
    echo "[+] Instalando MySQL..."
    sudo apt install -y mysql-server
    sudo systemctl enable mysql
    sudo systemctl start mysql
    sudo mysql_secure_installation

    echo "[+] Testando MySQL..."
    if sudo mysql -u root -e "SHOW DATABASES;" > /dev/null 2>&1; then
        echo " Conectado ao MySQL com sucesso!"
    else
        echo " Falha ao conectar ao MySQL."
    fi
}

install_php() {
    echo "[+] Instalando PHP..."
    sudo apt install -y php libapache2-mod-php php-mysql php-cli php-curl php-gd php-mbstring php-xml php-zip
    sudo systemctl restart apache2

    echo "[+] Criando página de teste PHP..."
    echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php > /dev/null
    echo "<?php echo ' Hello, World from PHP!'; ?>" | sudo tee /var/www/html/hello.php > /dev/null

    echo "[+] Testando PHP info..."
    if curl -s http://localhost/info.php | grep -q "phpinfo"; then
        echo " PHP está funcionando via Apache (info.php)"
    else
        echo " PHP pode não estar funcionando corretamente."
    fi
}

install_python() {
    echo "[+] Instalando Python e pip..."
    sudo apt install -y python3 python3-pip

    echo "[+] Criando script Hello World em Python..."
    echo "print(' Hello, World from Python!')" > hello.py

    echo "[+] Executando script Python..."
    if python3 hello.py | grep -q "Hello, World"; then
        echo " Hello World em Python executado com sucesso!"
    else
        echo " Erro ao executar o script Python."
    fi

    echo "[+] Versões:"
    python3 --version && pip3 --version
}

install_openjdk() {
    echo "[+] Instalando OpenJDK 17..."
    sudo apt install -y openjdk-17-jdk

    echo "[+] Criando programa Hello World em Java..."
    cat <<EOF > HelloWorld.java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println(" Corinthians melhor time!");
    }
}
EOF

    javac HelloWorld.java
    java HelloWorld
    java -version && javac -version
}


uninstall_apache() {
    echo "[–] Desinstalando Apache..."
    sudo systemctl stop apache2
    sudo apt remove --purge -y apache2 apache2-utils apache2-bin apache2.2-common
    sudo apt autoremove -y
    sudo rm -rf /var/www/html/info.php /var/www/html/hello.php
    echo " Apache removido com sucesso!"
}

uninstall_mariadb() {
    echo "[–] Desinstalando MariaDB..."
    sudo systemctl stop mariadb
    sudo apt remove --purge -y mariadb-server mariadb-client
    sudo apt autoremove -y
    sudo rm -rf /var/lib/mysql /etc/mysql
    echo " MariaDB removido com sucesso!"
}

uninstall_mysql() {
    echo "[–] Desinstalando MySQL..."
    sudo systemctl stop mysql
    sudo apt remove --purge -y mysql-server mysql-client mysql-common
    sudo apt autoremove -y
    sudo rm -rf /var/lib/mysql /etc/mysql
    echo " MySQL removido com sucesso!"
}

uninstall_php() {
    echo "[–] Desinstalando PHP..."
    sudo apt remove --purge -y php libapache2-mod-php php-mysql php-cli php-curl php-gd php-mbstring php-xml php-zip
    sudo apt autoremove -y
    sudo rm -rf /var/www/html/info.php /var/www/html/hello.php
    echo " PHP removido com sucesso!"
}

uninstall_python() {
    echo "[–] Desinstalando Python e pip..."
    sudo apt remove --purge -y python3 python3-pip
    sudo apt autoremove -y
    rm -f hello.py
    echo " Python removido com sucesso!"
}

uninstall_openjdk() {
    echo "[–] Desinstalando OpenJDK..."
    sudo apt remove --purge -y openjdk-17-jdk openjdk-17-jre
    sudo apt autoremove -y
    rm -f HelloWorld.java HelloWorld.class
    echo " OpenJDK removido com sucesso!"
}

lamp_menu() {
    while true; do
        clear
        echo "============================"
        echo "   GERENCIADOR LAMP STACK"
        echo "============================"
        echo "1) Instalar Linux (atualizar e utilitários)"
        echo "2) Instalar Apache"
        echo "3) Instalar MariaDB"
        echo "4) Instalar MySQL"
        echo "5) Instalar PHP"
        echo "6) Instalar Python"
        echo "7) Instalar OpenJDK 17"
        echo "8) Instalar TODOS os componentes"
        echo "----------------------------"
        echo "9) DESINSTALAR componentes"
        echo "0) Sair"
        echo "============================"
        read -p "Escolha uma opção: " opcao

        case $opcao in
            1) install_linux_tools ;;
            2) install_apache ;;
            3) install_mariadb ;;
            4) install_mysql ;;
            5) install_php ;;
            6) install_python ;;
            7) install_openjdk ;;
            8)
                install_linux_tools
                install_apache
                install_mariadb
                install_mysql
                install_php
                install_python
                install_openjdk
                ;;
            9)
                uninstall_menu
                ;;
            0)
                echo "Saindo..."
                exit 0
                ;;
            *)
                echo "Opção inválida."
                ;;
        esac
        read -p "Pressione Enter para continuar..."
    done
}


uninstall_menu() {
    while true; do
        clear
        echo "============================"
        echo "   MENU DE DESINSTALAÇÃO"
        echo "============================"
        echo "1) Desinstalar Apache"
        echo "2) Desinstalar MariaDB"
        echo "3) Desinstalar MySQL"
        echo "4) Desinstalar PHP"
        echo "5) Desinstalar Python"
        echo "6) Desinstalar OpenJDK 17"
        echo "7) Desinstalar TODOS os componentes"
        echo "0) Voltar"
        echo "============================"
        read -p "Escolha uma opção: " uninstall_option

        case $uninstall_option in
            1) uninstall_apache ;;
            2) uninstall_mariadb ;;
            3) uninstall_mysql ;;
            4) uninstall_php ;;
            5) uninstall_python ;;
            6) uninstall_openjdk ;;
            7)
                uninstall_apache
                uninstall_mariadb
                uninstall_mysql
                uninstall_php
                uninstall_python
                uninstall_openjdk
                ;;
            0) break ;;
            *) echo "Opção inválida." ;;
        esac
        read -p "Pressione Enter para continuar..."
    done
}

# Executa o menu principal
lamp_menu
