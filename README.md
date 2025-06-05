# Consulta CEP

Aplicação Delphi para consulta de CEPs e endereços utilizando a API ViaCEP.

## Arquitetura

O projeto foi desenvolvido seguindo os princípios de Clean Architecture e Design Patterns, utilizando:

### Padrões de Projeto
- **DAO (Data Access Object)**: Para abstração do acesso aos dados
- **Controller**: Para orquestração das operações
- **Service**: Para comunicação com serviços externos
- **Model**: Para representação dos dados

### Estrutura de Pastas
```
Source/
├── Controllers/     # Controladores da aplicação
├── DAO/            # Objetos de acesso a dados
├── Models/         # Modelos de dados
└── Services/       # Serviços externos
└── View/       # Camada de Apresentação
```

## Funcionalidades

### Consulta por CEP
- Busca endereço a partir de um CEP
- Validação do formato do CEP
- Verificação de existência no banco local
- Opção de atualização de dados existentes
- Suporte a formatos JSON e XML

### Consulta por Endereço
- Busca CEPs a partir de UF, cidade e logradouro
- Validação dos campos de entrada
- Verificação de existência no banco local
- Opção de atualização de dados existentes
- Suporte a formatos JSON e XML

### Persistência
- Banco de dados local SQLite
- Tabela `ceps` com os campos:
  - CEP
  - Logradouro
  - Complemento
  - Bairro
  - Cidade
  - UF

## Tecnologias Utilizadas

### Delphi
- Delphi 10.1
- FireDAC para acesso a dados

### APIs
- **ViaCEP**: API pública para consulta de CEPs
  - Endpoint: https://viacep.com.br/ws/
  - Formatos: JSON e XML
  - Métodos: GET

## Fluxo de Operações

### Consulta por CEP
1. Validação do CEP informado
2. Verificação no banco local
3. Se existir:
   - Pergunta se deseja atualizar
   - Se sim, consulta ViaCEP
   - Se não, exibe dados locais
4. Se não existir:
   - Consulta ViaCEP
   - Salva no banco local
5. Exibe resultado no grid

### Consulta por Endereços
1. Validação dos campos informados
2. Verificação no banco local
3. Se existir:
   - Pergunta se deseja atualizar
   - Se sim, consulta ViaCEP
   - Se não, exibe dados locais
4. Se não existir:
   - Consulta ViaCEP
   - Salva no banco local
5. Exibe resultados no grid

## Uso

1. Para consultar por CEP:
   - Digite o CEP no campo correspondente
   - Clique em "Consultar"

2. Para consultar por endereço:
   - Preencha UF, cidade e logradouro
   - Clique em "Consultar"

3. Para alterar o formato da resposta:
   - Selecione JSON ou XML no grupo de opções

## Configuração

### Banco de Dados
- Banco SQLite para fácilitar a configuração
- Crida em tempo de execução caso ainda não exista


