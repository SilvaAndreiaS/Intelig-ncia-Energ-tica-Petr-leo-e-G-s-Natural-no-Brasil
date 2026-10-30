# Inteligência Energética e Modelagem Preditiva da Produção de Petróleo e Gás Natural no Brasil: Uma Abordagem Integrada de Engenharia de Reservatórios e Ciência de Dados

**NOTA DE STATUS — PROJETO E ARTIGO EM DESENVOLVIMENTO (WORK IN PROGRESS):**
Este repositório e o respectivo manuscrito técnico-científico encontram-se atualmente em fase ativa de desenvolvimento e expansão. Os modelos analíticos, rotinas de ingestão de dados da ANP e algoritmos de ajuste automático de curvas de declínio estão sendo continuamente refinados. Novas seções experimentais e validações estatísticas serão incorporadas nas próximas versões.

- **Repositório:** Inteligencia-Energetica-Petroleo-e-Gas-Natural-no-Brasil
- **Autora:** Andreia Souza Santana Da Silva
- **Versão do Documento:** 0.9-alpha (Manuscrito em Desenvolvimento)

## Resumo
A transição energética global e a crescente complexidade operacional dos campos ultraprofundos demandam ferramentas avançadas de inteligência analítica para otimizar a exploração e produção (E&P) de hidrocarbonetos. Este artigo — atualmente em desenvolvimento — propõe uma arquitetura computacional integrada de engenharia de reservatórios e ciência de dados para o monitoramento produtivo, modelagem de declínio e avaliação do aproveitamento de gás natural nas bacias sedimentares brasileiras. Utilizando séries temporais públicas da Agência Nacional do Petróleo, Gás Natural e Biocombustíveis (ANP) e da Empresa de Pesquisa Energética (EPE), o estudo aplica equações volumétricas de óleo original no local (**OOIP**), modelos empíricos de declínio de Arps (exponencial, hiperbólico e harmônico) e métricas de eficiência energética baseadas em barris de óleo equivalente (**boe**). Os resultados preliminares destacam a hegemonia dos reservatórios carbonáticos do Pré-Sal nas Bacias de Santos e Campos (responsáveis por cerca de 78% a 80% da produção nacional superior a 4,3 MMboe/d), com óleo de alta qualidade (28° a 31° API), ao mesmo tempo em que evidenciam desafios críticos de infraestrutura Midstream refletidos nas taxas de reinjeção e queima (flaring) de gás natural associado.

**Palavras-chave:** Inteligência Energética; Pré-Sal; Engenharia de Reservatórios; Curvas de Declínio de Arps; Gás Natural; Ciência de Dados.

## Abstract
The global energy transition and the increasing operational complexity of ultra-deepwater fields require advanced analytical intelligence tools to optimize hydrocarbon exploration and production (E&P). This paper — currently under active development — proposes an integrated computational framework combining reservoir engineering and data science for production monitoring, decline curve analysis, and natural gas utilization assessment across Brazilian sedimentary basins. Leveraging public time-series data from the National Agency of Petroleum, Natural Gas and Biofuels (ANP) and the Energy Research Office (EPE), the study implements Original Oil In Place (**OOIP**) volumetric equations, Arps empirical decline models (exponential, hyperbolic, and harmonic), and energy efficiency metrics in barrels of oil equivalent (**boe**). Preliminary results highlight the dominance of Pre-Salt carbonate reservoirs in the Santos and Campos Basins (accounting for approximately 78% to 80% of national production exceeding 4.3 MMboe/d), characterized by high-grade oil (28° to 31° API), while identifying critical Midstream infrastructure bottlenecks reflected in associated natural gas reinjection and flaring rates.

**Keywords:** Energy Intelligence; Pre-Salt; Reservoir Engineering; Arps Decline Curves; Natural Gas; Data Science.

## 1. Introdução
O Brasil consolidou-se nas últimas décadas como um dos principais polos globais de produção de petróleo e gás natural em águas profundas e ultraprofundas (offshore). A descoberta e o desenvolvimento acelerado da província do Pré-Sal — situada sob uma espessa camada evaporítica nas Bacias de Santos e Campos — transformaram o patamar produtivo nacional, superando a marca histórica de **4,3 milhões de barris de óleo equivalente por dia (MMboe/d)**.

Contudo, a gestão eficiente desses ativos petrolíferos impõe desafios multidisciplinares:
1. **Gerenciamento do Declínio Natural em Campos Maduros (Brownfields):** Necessidade de prever com exatidão o comportamento de perda de pressão e vazão nas bacias pós-sal e terrestres (Campos, Recôncavo, Potiguar, Solimões) para dimensionar projetos de recuperação avançada de petróleo (**EOR**).
2. **Aproveitamento do Gás Natural Associado:** Os reservatórios do Pré-Sal apresentam elevada Razão Gás-Óleo (**RGO**) e presença de contaminantes como o dióxido de carbono (CO₂). O equilíbrio entre reinjeção para manutenção de pressão (e abatimento de emissões via **CCUS**), escoamento comercial para a costa (Rotas 1, 2 e 3) e minimização da queima em flare exige modelagem contínua.
3. **Descarbonização do Upstream:** A pressão regulatória e ambiental demanda o acompanhamento rigoroso da intensidade de carbono por barril extraído (kgCO₂e/boe).

O objetivo deste estudo em desenvolvimento consiste em construir uma plataforma aberta de Inteligência Energética em linguagem Python, capaz de processar dados operacionais de poços e plataformas (FPSOs), estimar volumes recuperáveis, simular curvas de declínio produtivo e auditar os índices de aproveitamento energético do gás natural no Brasil.

## 2. Material e Métodos

### 2.1. Base de Dados e Escopo Espacial
A arquitetura de dados do projeto consome registros mensais do Boletim da Produção de Petróleo e Gás Natural da ANP e do Balanço Energético Nacional (BEN) da EPE. O escopo espacial abrange três domínios operacionais:
- **Polígono do Pré-Sal (Offshore Ultraprofundo):** Campos gigantes e supergigantes (Búzios, Tupi/Lula, Mero/Libra, Sépia e Atapu) na Bacia de Santos.
- **Pós-Sal (Offshore Profundo e Raso):** Campos maduros e revitalizados na Bacia de Campos (Roncador, Marlim, Albacora e Peregrino).
- **Bacias Terrestres (Onshore):** Polo Urucu na Bacia do Solimões (referência em gás natural e óleo leve) e bacias maduras do Nordeste e Sudeste.

### 2.2. Modelagem Volumétrica e Propriedades dos Fluidos
A caracterização da qualidade comercial do óleo bruto produzido em cada corrente é determinada pelo Grau API (°API), calculado a partir da densidade relativa (SG, *Specific Gravity*) medida a 60°F em relação à água:

> **°API = (141,5 / SG) - 131,5**

A estimativa determinística do volume de óleo originalmente contido no reservatório (*Original Oil In Place* — **OOIP**, expresso em barris padrão STB) fundamenta-se na equação volumétrica clássica:

> **OOIP = [ 7758 × A × h × φ × (1 - Swi) ] / Boi**

Onde:
- **A:** Área portadora de hidrocarbonetos (acres);
- **h:** Espessura líquida porosa (*Net Pay*, em pés);
- **φ:** Porosidade efetiva média da rocha reservatório (fração);
- **Swi:** Saturação de água conata inicial (fração);
- **Boi:** Fator volume-formação inicial do óleo (rb/STB).

### 2.3. Análise de Curvas de Declínio de Produção (Modelo de Arps)
Para projetar a vida econômica dos poços e o Volume Final Recuperável (*Estimated Ultimate Recovery* — **EUR**), utiliza-se a equação diferencial empírica proposta por Arps (1945), que relaciona a vazão de produção `q(t)` no instante `t` à vazão inicial `qi`, à taxa de declínio nominal inicial `Di` e ao expoente de declínio hiperbólico `b`:

> **q(t) = qi / (1 + b × Di × t)^(1/b)**

- **Declínio Exponencial (b = 0):** A queda percentual de produção por unidade de tempo é constante: `q(t) = qi × e^(-Di × t)`
- **Declínio Hiperbólico (0 < b < 1):** Comportamento típico de reservatórios atuando sob mecanismos combinados de empuxo hidráulico e gás em solução.
- **Declínio Harmônico (b = 1):** Caso limite em que a taxa de declínio é diretamente proporcional à vazão instantânea.

### 2.4. Padronização Energética e Aproveitamento de Gás Natural
Para consolidar a produção bifásica (óleo líquido em bbl/d e gás natural em m³/d) em uma unidade energética equivalente (boe/d), aplica-se o fator termodinâmico oficial adotado pela ANP (1.000 m³ de gás natural ≈ 6,2898 boe):

> **Produção Total (boe/d) = Q_óleo (bbl/d) + [ (Q_gás (m³/d) / 1000) × 6,2898 ]**

A Razão Gás-Óleo operacional (**RGO**) e o Índice de Aproveitamento de Gás (**IAG**, que penaliza o volume perdido por queima em *flaring*, `V_flare`) são definidos por:

> **RGO = Q_gás / Q_óleo**  [m³/bbl]
> 
> **IAG (%) = [ 1 - (V_flare / Q_gás) ] × 100**

## 3. Resultados Preliminares e Discussão

### 3.1. Diagnóstico Macroenergético Nacional
A consolidação dos dados operacionais confirma a expressiva concentração da produtividade brasileira nos reservatórios carbonáticos microbiais da seção rifte/sag do Pré-Sal. A Tabela 1 sintetiza os parâmetros de referência levantados até a presente etapa da pesquisa.

**Tabela 1: Indicadores estratégicos da matriz de exploração e produção (E&P) no Brasil.**

| Indicador Operacional Nacional | Métrica / Valor de Referência | Bacia / Polo Dominante |
| :--- | :--- | :--- |
| **Produção Total Consolidada** | > 4,3 MMboe/d | Bacia de Santos e Bacia de Campos |
| **Participação Relativa do Pré-Sal** | ~ 78% a 80% do total nacional | Polígono do Pré-Sal (Búzios, Tupi, Mero, Sépia) |
| **Produção Nacional de Óleo Bruto** | ~ 3,4 MMbbl/d | Campo de Búzios e Campo de Tupi |
| **Oferta Bruta de Gás Natural** | > 150 MMm³/d | Bacia de Santos, Campos e Solimões (Urucu) |
| **Fator de Recuperação Médio (FR)** | 28% a 35% (com tecnologia WAG) | Reservatórios Carbonáticos do Pré-Sal |

### 3.2. Simulação Computacional de Polos Produtores Estratégicos
A aplicação preliminar do algoritmo desenvolvido em cinco polos representativos (Búzios, Tupi e Mero no Pré-Sal; Roncador no Pós-Sal; e Polo Urucu em ambiente terrestre na Amazônia) evidencia perfis fluidodinâmicos distintos:
- **Campos do Pré-Sal (Búzios, Tupi e Mero):** Apresentam correntes de óleo médio-leve (28,5° a 29,6° API), altíssima vazão por poço produtor e RGO entre 42 e 48 m³/bbl, mantendo índices de aproveitamento de gás superiores a 98,5% graças aos sistemas de compressão e reinjeção.
- **Campo de Roncador (Pós-Sal - Bacia de Campos):** Caracteriza-se por óleo mais pesado (≈ 22,1° API) e estágio de maturação avançado, exigindo modelagem hiperbólica de Arps e técnicas de gerenciamento de água produzida.
- **Polo Urucu (Terrestre - Bacia do Solimões):** Destaca-se pelo óleo ultraleve/condensado (≈ 48,7° API) e altíssima fração de gás rico (> 950 m³/bbl), essencial para o suprimento termelétrico e industrial da Região Norte.

## 4. Implementação Computacional (src/inteligencia_energetica.py)
O módulo em Python abaixo constitui o núcleo do motor de cálculo do repositório, implementando as equações descritas na metodologia:

```python
# -*- coding: utf-8 -*-
"""
Artigo/Projeto: Inteligência Energética - Petróleo e Gás Natural no Brasil
Status: Em Desenvolvimento (Versão 0.9-alpha)
Autora: Andreia Souza Santana Da Silva
"""

import math
from dataclasses import dataclass
from typing import List, Dict


def calcular_grau_api(densidade_relativa_60f: float) -> float:
    """
    Calcula o Grau API do petróleo a partir da densidade relativa (SG a 60°F).
    Equação: °API = (141.5 / SG) - 131.5
    """
    if densidade_relativa_60f <= 0:
        raise ValueError("A densidade relativa (SG) deve ser estritamente positiva.")
    return round((141.5 / densidade_relativa_60f) - 131.5, 2)


def calcular_ooip(area_acres: float, espessura_pes: float, porosidade: float, sat_agua: float, boi: float) -> float:
    """
    Calcula o Volume Original de Óleo in Place (OOIP) em barris padrão (STB).
    Equação: OOIP = (7758 * A * h * phi * (1 - Swi)) / Boi
    """
    if boi <= 0:
        raise ValueError("O fator volume-formação inicial (Boi) deve ser positivo.")
    numerador = 7758.0 * area_acres * espessura_pes * porosidade * (1.0 - sat_agua)
    return round(numerador / boi, 2)


def converter_para_boe(oleo_bbl_dia: float, gas_m3_dia: float) -> float:
    """
    Converte a produção combinada de óleo (bbl/d) e gás natural (m³/d)
    para Barris de Óleo Equivalente por dia (boe/d) segundo o padrão ANP.
    """
    fator_conversao_gas = 6.2898  # 1.000 m³ de gás natural = 6,2898 boe
    gas_boe = (gas_m3_dia / 1000.0) * fator_conversao_gas
    return round(oleo_bbl_dia + gas_boe, 2)


def arps_declinio_producao(q_inicial: float, taxa_declinio: float, tempo_anos: float, b: float = 0.0) -> float:
    """
    Projeta a vazão q(t) utilizando o modelo empírico de Curva de Declínio de Arps.
    - b == 0.0: Declínio Exponencial
    - 0.0 < b < 1.0: Declínio Hiperbólico
    - b == 1.0: Declínio Harmônico
    """
    if b == 0.0:
        return round(q_inicial * math.exp(-taxa_declinio * tempo_anos), 2)
    return round(q_inicial / ((1.0 + b * taxa_declinio * tempo_anos) ** (1.0 / b)), 2)


@dataclass
class CampoProdutorBrasil:
    nome_campo: str
    bacia_sedimentar: str
    ambiente: str  # "Pré-Sal", "Pós-Sal" ou "Terrestre"
    oleo_bbl_d: float
    gas_m3_d: float
    densidade_sg: float
    volume_queima_flaring_m3_d: float

    def gerar_relatorio_executivo(self) -> Dict[str, float | str]:
        grau_api = calcular_grau_api(self.densidade_sg)
        producao_total_boe = converter_para_boe(self.oleo_bbl_d, self.gas_m3_d)
        rgo_m3_bbl = round(self.gas_m3_d / self.oleo_bbl_d, 2) if self.oleo_bbl_d > 0 else 0.0
        eficiencia_gas_pct = round((1.0 - (self.volume_queima_flaring_m3_d / self.gas_m3_d)) * 100, 2)

        return {
            "Campo": self.nome_campo,
            "Bacia": self.bacia_sedimentar,
            "Ambiente": self.ambiente,
            "Grau_API": grau_api,
            "Producao_Total_boed": producao_total_boe,
            "RGO_m3_por_bbl": rgo_m3_bbl,
            "Indice_Aproveitamento_Gas_Pct": eficiencia_gas_pct
        }


if __name__ == "__main__":
    campos_brasil: List[CampoProdutorBrasil] = [
        CampoProdutorBrasil("Búzios", "Santos", "Pré-Sal", 820000.0, 34500000.0, 0.884, 480000.0),
        CampoProdutorBrasil("Tupi (Lula)", "Santos", "Pré-Sal", 790000.0, 36200000.0, 0.878, 510000.0),
        CampoProdutorBrasil("Mero (Libra)", "Santos", "Pré-Sal", 410000.0, 19800000.0, 0.881, 290000.0),
        CampoProdutorBrasil("Roncador", "Campos", "Pós-Sal", 135000.0, 4200000.0, 0.921, 110000.0),
        CampoProdutorBrasil("Polo Urucu", "Solimões", "Terrestre", 14500.0, 13800000.0, 0.785, 95000.0),
    ]

    print("=" * 95)
    print("SIMULAÇÃO CIENTÍFICA PRELIMINAR: PETRÓLEO E GÁS NATURAL NO BRASIL (EM DESENVOLVIMENTO)")
    print("=" * 95)
    print(f"{'CAMPO':<15} | {'BACIA':<10} | {'AMBIENTE':<10} | {'°API':>6} | {'PRODUÇÃO (boe/d)':>18} | {'APROV. GÁS (%)':>14}")
    print("-" * 95)

    for campo in campos_brasil:
        dados = campo.gerar_relatorio_executivo()
        print(
            f"{dados['Campo']:<15} | "
            f"{dados['Bacia']:<10} | "
            f"{dados['Ambiente']:<10} | "
            f"{dados['Grau_API']:>6.2f} | "
            f"{dados['Producao_Total_boed']:>18,.2f} | "
            f"{dados['Indice_Aproveitamento_Gas_Pct']:>13.2f}%"
        )
```

## 5. Status do Desenvolvimento e Próximas Etapas (Roadmap)
Como este projeto científico encontra-se em desenvolvimento, o cronograma de engenharia de software e pesquisa acadêmica segue as etapas abaixo:
- [x] **Fase 1 — Fundamentação Teórica e Equacionamento:** Definição dos modelos matemáticos (OOIP, Grau API, conversão boe e declínio de Arps).
- [x] **Fase 2 — Protótipo Computacional em Python:** Criação das estruturas de dados (`dataclasses`) e simulação dos 5 polos estratégicos.
- [ ] **Fase 3 — Ingestão Automatizada de Dados Brutos da ANP (Em andamento):** Desenvolvimento de *web scrapers* e conectores via API para atualização mensal automática das tabelas de produção por poço e FPSO.
- [ ] **Fase 4 — Ajuste Não-Linear de Curvas de Declínio (`scipy.optimize`):** Implementação de regressão automatizada para estimar os parâmetros `Di` e `b` de Arps diretamente a partir do histórico real de campos maduros da Bacia de Campos.
- [ ] **Fase 5 — Modelagem de Emissões e Descarbonização (CCUS):** Quantificação da intensidade de emissões (kgCO₂e/boe) e balanço de reinjeção de CO₂ no Pré-Sal.
- [ ] **Fase 6 — Dashboard Interativo e Publicação Final:** Construção de painel analítico em Streamlit / Power BI e consolidação da versão final do artigo para submissão.


## 7. Referências Bibliográficas (Padrão ABNT NBR 6023)
- ANP – AGÊNCIA NACIONAL DO PETRÓLEO, GÁS NATURAL E BIOCOMBUSTÍVEIS. **Boletim da Produção de Petróleo e Gás Natural**. Rio de Janeiro: ANP, 2024.
- ARPS, J. J. Analysis of Decline Curves. **Transactions of the AIME**, v. 160, n. 01, p. 228–247, 1945.
- EPE – EMPRESA DE PESQUISA ENERGÉTICA. **Balanço Energético Nacional (BEN) e Plano Decenal de Expansão de Energia (PDE)**. Brasília: MME/EPE, 2024.
- ROSA, A. J.; CARVALHO, R. S.; XAVIER, J. A. D. **Engenharia de Reservatórios de Petróleo**. Rio de Janeiro: Editora Interciência, 2006.
- SZKLO, A.; MACHADO, G.; SCHAEFFER, R. **Futuro da Indústria de Petróleo e Gás no Brasil**. Rio de Janeiro: Synergia Editora, 2020.
