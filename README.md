# TF-TARSD

O atual projeto é uma prova de conceito de monitoramento para a disciplina de Tópicos Avançados em Redes e Sistemas Distribuídos.

Pré Requisitos:
1. [Vagrant 2.2.4](https://www.vagrantup.com/) ou recente

## Execução


```
vagrant up
```

Para enviar arquivos ao serviço de transferência de arquivos:

```
curl -X POST -F 'file=@<filename>' 192.168.50.2:5001/upload
```

Para receber arquivos do serviço de transferência de arquivos:

```
curl -X POST -F 'name=<filename>' 192.168.50.2:5001/download > <filename>
```

[//]: # (Completar!!!)

## Diagrama do ambiente

![Diagrama](https://github.com/gabrielrodriguesrocha/TF-TARSD/raw/master/diagrama.png)

## Desenvolvimento

Inicialmente foi decidido utilizar uma arquitetura com apenas duas máquinas virtuais, chamadas `master` e `slave`.

A imagem do serviço de transferência de arquivos, contida em `services/file_transfer`. O serviço consiste em uma aplicação bem simples escrita em Python (estendida da própria imagem `python`) com o framework Bottle.

Para exportar métricas de *containers* e máquinas virtuais, foram utilizados os *exporters* cAdvisor e Node-Exporter, respectivamente, executando em *containers* em ambas as máquinas. Essas métricas foram coletadas pelo Prometheus executando de forma *containerizada* na máquina virtual `master`. Através do recurso de regras do Prometheus, foram geradas novas métricas que são requisitos da atividade.

O InfluxDB foi adotado como banco de dados para persistir as métricas dos *containers* e das máquinas virtuais, geradas a partir das regras supracitadas. O Prometheus foi configurado para escrever remotamente as métricas em dois *containers* do InfluxDB executando em serviços, um para persistir as métricas de *containers* e outro para máquinas virtuais.

O `Vagrantfile` foi reaproveitado do [trabalho prático anterior](https://github.com/gabrielrodriguesrocha/T1-TARSD) e consiste na configuração de duas máquinas virtuais, `master` e `slave`. Cada máquina virtual executa um arquivo de provisão específico e um geral.

- ```provision.sh```: 
  - instala o Docker;
  - clona este repositório dentro das máquinas;
- `master_setup.sh`:
  - inicializa o *swarm* no servidor, colocando o comando para *join* no repositório compartilhado do Vagrant;
  - cria as imagens dos serviços de transferência de arquivos (APP 1), persistência de métricas de *containers* (APP 2) e persistência de métricas de máquinas virtuais (APP 3), com volumes criados para cada serviço;
  - executa os *containers* Prometheus, cAdvisor e Node-Exporter;
  - executa os serviços, sendo o APP 1 com replicação 3.
- `slave_setup.sh`:
  - executa o comando para se juntar ao *swarm* do servidor;
  - executa os *containers* cAdvisor e Node-Exporter.
  
## Dificuldades encontradas

A dificuldade encontrada mais notável foi encontrar uma forma de gerar métricas a partir de métricas já existentes no Prometheus e enviá-las a um banco de dados, no caso o InfluxDB. No entanto, após uma breve leitura da documentação, foi possível superar essa dificuldade sem problemas. Não houve outros empecilhos que merecem destaque.
