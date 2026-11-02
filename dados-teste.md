# Dados de teste

O arquivo `producao_teste_12345.csv` contém exatamente 12.345 registros de dados sintéticos,
além da linha de cabeçalho. Os números foram gerados artificialmente para testar leitura de CSV,
processamento em lote e cálculos do programa COBOL.

**Não são dados históricos ou oficiais da ANP.** Não use estes valores para conclusões técnicas,
financeiras, operacionais ou regulatórias. Para análises reais, substitua o arquivo por dados
oficiais e documente a fonte, data de extração, unidades e metodologia.

Campos:
- `mes`: identificador de período de teste.
- `petroleo_bbl_dia`: taxa ilustrativa de petróleo em barris/dia.
- `gas_milhoes_m3_dia`: taxa ilustrativa de gás em milhões de m³/dia.
- `pre_sal_percentual`: percentual ilustrativo do pré-sal.
- `queima_milhoes_m3_dia`: taxa ilustrativa de queima de gás em milhões de m³/dia.

Para executar:
```bash
./producao data/producao_teste_12345.csv
```
