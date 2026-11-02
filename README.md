# Inteligência Energética — COBOL para Petróleo e Gás Natural

Projeto didático em COBOL para ler dados mensais de produção de petróleo e gás natural, calcular indicadores e gerar um relatório textual.

## Objetivos
- Ler um arquivo CSV de produção mensal.
- Calcular a produção total equivalente em barris de óleo equivalente por dia (boe/d), quando o valor não vier preenchido.
- Exibir indicadores de petróleo, gás natural, pré-sal e queima de gás.
- Separar claramente dados de exemplo de dados oficiais validados.

> **Importante:** o arquivo em `data/producao_exemplo.csv` contém dados ilustrativos para demonstrar o programa. Não deve ser tratado como série oficial da ANP. Substitua-o por dados oficiais conferidos antes de usar em análises reais.

## Estrutura
```text
inteligencia_energetica_cobol/
├── README.md
├── requirements.txt
├── .gitignore
├── src/
│   └── producao.cbl
├── copybooks/
│   └── registro-producao.cpy
├── data/
│   └── producao_exemplo.csv
├── docs/
│   ├── metodologia.md
│   └── fluxograma.md
└── tests/
    └── casos-de-teste.md
```

## Requisitos
- Compilador COBOL, recomendado GnuCOBOL 3.x.
- Não há dependências Python ou bibliotecas externas.

## Compilar e executar
Na raiz do projeto:

```bash
cobc -x -free -I copybooks -o producao src/producao.cbl
./producao data/producao_exemplo.csv
```

No Windows, execute o binário gerado pelo GnuCOBOL conforme a instalação local (por exemplo, `producao.exe data/producao_exemplo.csv`).

Se nenhum caminho for informado, o programa tenta abrir `data/producao_exemplo.csv`.

## Formato CSV
O cabeçalho é ignorado. Cada linha deve conter:
`mes,petroleo_bbl_dia,gas_milhoes_m3_dia,pre_sal_percentual,queima_milhoes_m3_dia`

Exemplo:
`2026-08,4615000,220,79.0,4.2`

- `petroleo_bbl_dia`: barris de petróleo por dia.
- `gas_milhoes_m3_dia`: milhões de m³ de gás por dia.
- `pre_sal_percentual`: percentual estimado da produção atribuída ao pré-sal.
- `queima_milhoes_m3_dia`: milhões de m³ de gás queimados por dia.

O exemplo de conversão usado no programa é `1 m³ de gás = 6,2898 barris` para uma estimativa simplificada de boe/d. A conversão real pode depender dos critérios técnicos adotados na fonte. Para relatórios oficiais, documente a metodologia e use fatores compatíveis com a fonte.

## Limitações
- Leitura CSV simplificada: campos não devem conter vírgulas internas ou aspas escapadas.
- A rotina espera dados numéricos válidos.
- O cálculo de boe/d é aproximado e serve para demonstração.
- Não há conexão automática com a ANP; a atualização de dados é manual.


## Base de teste com 12.345 registros

O arquivo `data/producao_teste_12345.csv` contém **12.345 linhas de dados sintéticos**, além do cabeçalho, para testar processamento em lote. Consulte `data/LEIA-ME-dados-teste.md`. Estes registros são simulados e não representam dados oficiais da ANP.

Execute com:
```bash
./producao data/producao_teste_12345.csv
```
