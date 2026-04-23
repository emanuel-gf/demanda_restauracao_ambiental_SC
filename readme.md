# Demanda de Restauracao Ambiental nas Areas de Preservao Permanentes do Estado de Santa Catarina

Esse é o codigo referente a analise de dados do CAR utilizada na construçao do artigo.
blablabla
completar aos poucos

# Dados do CAR

Os dados do CAR foram acessados pelo link: [CAR](poe_o_link_aqui)

Os dados do CAR sao dividios em:
 Imovel-Area
 APP
 RESERVA LEGAL

(Talvez explicar o que é cada um)
Devido ao tamanho os dados de ... falar sobre o processo de como eh baixar o dados.
blablabla

# Tratamento e Analise de dados do CAR

```text
1 - Tratamento_de_Dados_Iniciais.R
2 - 
```

As categorias presentes de APP a restaurar provenientes dos arquivos de APP foram devidamente filtradas de acordo com a seguinte categorias?

Categoria / INDEX    
Area de Preservacao Permanente a recompor de rio ate 10 metros - 3 
Area de Preservacao Permanente a recompor de rio ate 50 metros - 4 

Tratamento de Dados

Os dados foram retirados pelo site do CAR em tres subsequentes .shp files. 
O processamento dos dados envolve a análise de 3 principais dados.

1 - Dados de  e artigo
2 - Vou continuar daqui explicando sobre as decisoes no processo de filtragem e problemas com acentuacao e ASCII characters 


# Organizacao dos arquivos

```bash
project/
├── data/
│   ├── APP/
│   │   ├── APPS_1.shp
│   │   ├── APPS_2.shp
│   │   ├── APPS_3.shp
│   │   └── Centroid_Area_Imovel/
│   │       └── centroid.shp
│   └── AREA_IMOVEL/
│       └── AREA_IMOVEL_1.shp
│
├── outputs/
│   ├── rds/
│   └── shp/
│
├── scripts/
│   └── processing.R
│
└── project.Rproj   # important for here()
```