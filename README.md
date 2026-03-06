
# Sistema de Monitoramento da Frota Escolar - SEMEC (Conceição do Araguaia)

Este projeto consiste em uma aplicação móvel desenvolvida em **Flutter** para a gestão e monitoramento do transporte escolar municipal de Conceição do Araguaia - PA. O foco principal é garantir a segurança dos alunos e a auditoria de rotas através de tecnologias **Offline First** e **Edge Computing**.

## Sobre o Projeto

O sistema foi projetado para operar prioritariamente em modo offline, garantindo o registro de embarque via reconhecimento facial mesmo em zonas rurais sem sinal de internet. A sincronização de dados ocorre posteriormente via API com o sistema E-SEMEC.

## Funcionalidades Implementadas

* **Sincronização de Dados (Downstream/Upstream):** Download da lista de alunos, vetores faciais e rotas via Wi-Fi.


* **Reconhecimento Facial Offline:** Identificação dos alunos localmente no dispositivo (tempo de resposta < 3s) utilizando Google ML Kit ou TensorFlow Lite.


* **Registro de Embarque Manual:** Fallback para casos de falha na biometria.


* **Monitoramento de Trajeto:** Captura de coordenadas GPS com Geotagging em cada embarque para auditoria de conformidade com FNDE/INEP.


* **Detecção Automática de Chegada (Geofencing):** Reconhecimento do perímetro escolar para disparo automático de sincronização.



## Segurança e LGPD

Em conformidade com a LGPD, o sistema utiliza:

* **Criptografia Local:** Banco de dados SQLite criptografado (AES-256) para proteção de dados de menores.


* **Autenticação Segura:** Login via tokens JWT integrados ao servidor central da SEMEC.



## Tecnologias Utilizadas

* **Linguagem:** Dart (Framework Flutter).


* **Banco de Dados Local:** SQLite (sqflite).


* **Identidade Visual:** Padronizada com as cores do brasão de Conceição do Araguaia (Verde, Amarelo e Azul).



## Créditos

* **Cliente:** Secretaria Municipal de Educação (SEMEC).


* **Desenvolvedor:** Márcio Rodrigues de Oliveira.


* **Supervisor:** Alcides Platiny Alves Batista.
