# Agenda Viagem

Agenda Viagem é um aplicativo Flutter que permite aos usuários registrar e gerenciar suas experiências de viagem. Os usuários podem adicionar entradas de viagem com informações como título, descrição, localização, data e uma nota de 0 a 10 as viagens.

## Funcionalidades

- Adicionar, editar e excluir entradas de viagem
- Selecionar uma data para a entrada de viagem

## Tecnologias Utilizadas

- Flutter
- Dart
- intl (para formatação de datas)
- sqflite (para armazenamento local com SQLite)

## Pré-requisitos

Antes de começar, você precisará ter o Flutter instalado em sua máquina. Você pode seguir as instruções de instalação no [site oficial do Flutter](https://flutter.dev/docs/get-started/install).

## Como Executar o Projeto

1. Clone o repositório:

   ```bash
   git clone https://github.com/seuusuario/agenda_viagem.git
   ```

2. Navegue até o diretório do projeto:

   ```bash
   cd agenda_viagem
   ```

3. Instale as dependências:

   ```bash
   flutter pub get
   ```

4. Execute o aplicativo:

   ```bash
   flutter run
   ```

## Estrutura do Projeto

- `lib/`: Contém o código-fonte do aplicativo.
- `helper/`: Contém classes auxiliares, como `traveldiary_helper.dart`.
  
## Banco de Dados

O aplicativo utiliza o `sqflite` para armazenar as entradas de viagem localmente. As principais operações de banco de dados incluem:

- Criação de tabelas
- Inserção de entradas
- Atualização de entradas
- Exclusão de entradas
- Consulta de entradas
