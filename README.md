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

## 
