# Desafio Técnico

## Objetivo
Este repositório contém minhas soluções para o desafio técnico, que tem como objetivo avaliar habilidades em manipulação e análise de dados, integração com APIs, consultas SQL no BigQuery e criação de visualizações.

## Estrutura do Repositório
```
/
|-- respostas-desafio/          # Pasta contendo os arquivos com as respostas do desafio
|   |-- analise_sql.sql         # Respostas e Queries das consultas SQL no BigQuery
|   |-- analise_python.ipynb    # Respostas em Python utilizando pandas
|   |-- analise_api.ipynb       # Respostas em Python para as perguntas relacionadas a APIs
|   |-- dados_rio.pbix          # Arquivo Power BI com as visualizações de dados
|-- README.md                   # Documento com instruções para reproduzir as análises
```

## Tecnologias Utilizadas
- **Google BigQuery**: Para consultas SQL nos dados públicos do projeto `datario`
- **Python (pandas, basedosdados)**: Para manipulação de dados e acesso ao BigQuery
- **APIs Públicas**: Para extração de dados adicionais
- **Power BI**: Para visualização interativa dos dados

## Como Reproduzir as Análises

### 1. Consultas SQL no BigQuery
1. Acesse o [Google Cloud Platform](https://cloud.google.com/) e crie uma conta.
2. No BigQuery, habilite o acesso ao projeto `datario`.
3. Abra o arquivo `analise_sql.sql` e execute as consultas na interface do BigQuery.

### 2. Executando as Análises em Python
1. Instale as dependências necessárias:
   ```bash
   pip install pandas basedosdados google-cloud-bigquery requests
   ```
2. Configure o acesso ao BigQuery seguindo o tutorial oficial
3. Abra os arquivos Jupyter em um ambiente apropriado. Os arquivos já estão em formato de relatório.

### 3. Visualização no Power BI
1. Abra o arquivo `dados_rio.pbix` no Power BI Desktop.
2. Explore o dashboard.

---

Caso tenha dúvidas ou precise de suporte para reproduzir os resultados, entre em contato.

**Lucas Miguel**