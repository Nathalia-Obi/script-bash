#!/bin/bash

function main {
	echo  "$(tput setaf 3)[Bot assistant]:$(tput setaf 7) Olá Usuário, serei seu assistente para te ajudar em tudo que for 
	necessario nessa instalação!;"
	sleep 2
	echo "$(tput setaf 4)[Bot assistant]:$(tput setaf 7) Informe o seu nome:"
	read nome;
	sleep 2
	clear
	echo "$(tput setaf 3)[Bot assistant]:$(tput setaf 7) Bem-vindo ao mundo do shell script, $nome!"
	sleep 2
	echo "$(tput setaf 3)[Bot assistant]:$(tput setaf 7) $nome, é muito importante que você configure o IPV4 da sua instancia toda vez que iniciar ela no Azure!"
	sleep 5
	clear
	validacao_java
}

function validacao_java {
	$java -version

	if [ $? = 0 ];
		then
			echo "$(tput setaf 14)[Bot assistant]:$(tput setaf 7) O Java já esta instalado!"
			validacao_docker
		else
			echo "$(tput setaf 14)[Bot assistant]:$(tput setaf 7) O Java não está instalado!"
			echo "$(tput setaf 4)[Bot assistant]:$(tput setaf 7) Confirme para mim se realmente deseja instalar o JAVA versão 17 (S/N)?"
			read get
			if [ \"$get\" == \"S\" ];	
				then
					echo "$(tput setaf 14)[Bot assistant]:$(tput setaf 7) Ok! Você escolheu instalar o Java ;D"
					sleep 2
					sudo apt install openjdk-17-jre -y
					clear
					echo "$(tput setaf 14)[Bot assistant]:$(tput setaf 7) Atualizando! Quase lá."
					sleep 2
					clear                
					echo "$(tput setaf 14)[Bot assistant]:$(tput setaf 7) Java instalado com sucesso!"
					validacao_docker
				else
					echo "$(tput setaf 9)[Bot assistant]:$(tput setaf 7) Você optou por não instalar o Java por enquanto, até a próxima então!"
					validacao_docker
			fi
	fi
}

function validacao_docker {
    clear
    echo "$(tput setaf 14)[Bot assistant]:$(tput setaf 7) Agora, para finalizar as verificações, vou verificar se você tem instalado o programa docker."
    docker=$(sudo dpkg -l | grep docker)
    sleep 3
    
    if [[ -z $docker ]]
    then
        clear
        echo "$(tput setaf 14)[Bot assistant]:$(tput setaf 7) Opa! Não identifiquei o Docker instalado, mas sem problemas, irei resolver isso agora!"
        sleep 2
        echo "$(tput setaf 4)[Bot assistant]:$(tput setaf 7) Confirme para mim se realmente deseja instalar o Docker (S/N)?"
        read opcao
        
        if [ \"$opcao\" == \"S\" ]
            then
                echo "$(tput setaf 14)[Bot assistant]:$(tput setaf 7) Preparando para instalar o Docker."
                echo y | sudo apt update
                clear
                echo "$(tput setaf 14)[Bot assistant]:$(tput setaf 7) Aguarde mais um pouco, estou instalando o Docker."
                echo y | sudo apt install docker.io
                clear
                echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7) Docker instalado com sucesso!"
                docker --version
                echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7) Agora vamos utilizar o gerenciador de processos do Linux, o systemctl para iniciar o docker."
                echo y | sudo systemctl start docker
                clear
                echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7) Aguarde mais um pouco, ja estou acabando de parametrizar o sistema."
                echo y | sudo systemctl enable docker
                clear
                echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7) Parametrização feita com sucesso e a instalação foi finalizada."
                get_project
            else
            clear
            echo "$(tput setaf 14)[Bot assistant]:$(tput setaf 7)  Você optou por não instalar o Docker por enquanto, até a próxima então!"
            sleep 3
            final
        fi
        
    else
        echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7) Que bom, você já tem o Docker instalado!!!"
        docker --version
        sleep 2
        clear
        get_project
    fi
}

function get_project {
	echo "Deseja pegar o arquivo do GitHub [S/N]"
	read resp

	if [ \"$resp\" == \"S\" ];
		then
			echo "$(tput setaf 14)[Bot assistant]:$(tput setaf 7) Preparando para instalar o Projeto"
			sudo docker --version
			clear
			sudo docker network create employee-mysql
			sudo docker network ls
			clear
			echo "$(tput setaf 14)[Bot assistant]:$(tput setaf 7) Baixando imagem de Maquina - MySQL 8.0."
			sudo docker pull mysql:8.0 
			clear
			echo "$(tput setaf 14)[Bot assistant]:$(tput setaf 7) Criando container com a imagem MySQL 8.0"
			sudo docker container run --name mysqldb --network employee-mysql -e MYSQL_ROOT_PASSWORD=root -d mysql:8.0
			sleep 9
			clear
			echo "$(tput setaf 14)[Bot assistant]:$(tput setaf 7) Baixando imagem de Maquina - API Java"
			sudo docker pull nathaliaobi/api-java-oshi:latest
			clear
			echo "$(tput setaf 14)[Bot assistant]:$(tput setaf 7) Criando container com a imagem API Crawler Python"
			sudo docker run --network employee-mysql --name employee-java-container nathaliaobi/api-java-oshi:latest
			clear
			echo "$(tput setaf 14)[Bot assistant]:$(tput setaf 7) Detalhamento dos Containers:"
			sudo docker images
			sleep 2
			sudo docker ps -a
			sleep 3
			clear

		else
			final
	fi
}

function final {

echo "$(tput setaf 8)[Bot assistant]:$(tput setaf 7) Programa finalizado!"

}

main