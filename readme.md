# Demanda de Restauracao Ambiental nas Areas de Preservao Permanentes do Estado de Santa Catarina

Esse é o codigo referente a analise de dados do CAR para embasamento analitico no que tange a demanda de restauracao ambiental nas areas de preservacao permanents de Santa Catarina. 

Este repositorio busca elencar todos os passos e criterios tecnicos escolhidos referente ao tratamento dos dados do cadastro ambiental rural (CAR) e metodologia utilizada para o calculo dos resultados. 



# Dados do CAR

Os dados do CAR sao disponiveis a consulta publica e podem ser acessados pelo link: 
- [CAR - CONSULTA](https://consulta.car.gov.br/)
- [CAR - DOWNLOADS](https://consulta.car.gov.br/geoservices)

Diante dos dados publicos disponiveis, os seguintes dados foram considerados para embasamento da analise:
 1. Perimetro dos Imoveis - Shapefile (.shp)
 2. Area de Preservacao Permanente - Shapefile (.shp)
 3. Reserva Legal - Shapefile (.shp)

Esses tres dados foram baixados e portanto consolidam a base de dados decorrente ao projeto. 

# Tratamento e Analise de dados do CAR

A partir da base de dados, um tratamento inicial foi feito em ARCGIS para reduzir o volume dos dados a serem processados e adequar ao tamanho dda maquina disponivel (I5, 16GM RAM). Dessa forma, todos os poligonos pertencentes ao perimetro dos imoveis no estado de Santa Catarina foram convertidos a seu respectivo centroide. Portanto, cada unidade de imovel continua possuindo  um identificador unico e exclusivo com informacoes e metadata associados, porem, sua estrutura geoespacial de um poligono ao um ponto, a fim de facilitar a reprodução do trabalho com menor custo computacional de memória RAM. 

A partir da extração do centroide de cada imovel, os seguintes scripts em R foram utilizados para processamento dos dados. 

```bash
1 - Tratamento_de_Dados_Iniciais.R - Data Cleaning, FIltering and Aggregation of APP by imovel and cod_tema
```

# Detalhes Tecnicos

O arquivo `APP.shp` disponibilizado através do serviço do CAR possui diversas categorias, dessa forma, foram filtradas as categorias que se adequam as áreas de preservação permanentes. As categorias filtradas foram:

```markdown 
Categoria | INDEX    
Area de Preservacao Permanente a recompor de rio ate 10 metros | 3 
Area de Preservacao Permanente a recompor de rio ate 50 metros | 4 
```



# Organizacao dos arquivos

colocar tree
