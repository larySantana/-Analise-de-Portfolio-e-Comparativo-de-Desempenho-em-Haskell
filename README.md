# 📊 Análise de Portfólio e Comparativo de Desempenho em Haskell

![Haskell](https://img.shields.io/badge/Haskell-5e5086?style=for-the-badge&logo=haskell&logoColor=white)
![Status](https://img.shields.io/badge/Status-Concluído-brightgreen?style=for-the-badge)

Trabalho de **Programação Funcional** focado na implementação de métricas quantitativas de risco e retorno financeiro em **Haskell**, comparando duas estruturas de dados fundamentais da linguagem: **Vetores indexados (`Data.Array`)** e **Listas encadeadas (`[Double]`)** em cenários de larga escala.

---

## 🎯 Objetivos do Projeto

1. **Implementar operações financeiras essenciais** em duas abordagens distintas (vetores vs. listas):
   - **Retorno Diário:** $R_t = \frac{P_t - P_{t-1}}{P_{t-1}}$
   - **Média de Retorno:** $\bar{R} = \frac{1}{n} \sum_{i=1}^{n} R_i$
   - **Produto Escalar (Retorno Esperado do Portfólio):** $R_p = \sum_{i=1}^{n} w_i \cdot r_i$
2. **Validar os algoritmos** com ativos reais da **B3** (`PETR4`, `VALE3` e `ITUB4`).
3. **Avaliar o desempenho computacional** (`System.CPUTime`) com séries simuladas de **1.000.000 de elementos**, analisando os impactos de acesso indexado $O(1)$, *lazy evaluation* e alocação de memória.

---

## 🗂️ Estrutura do Repositório

```text
├── portfolio.hs            # Código-fonte completo (implementação, validação B3 e benchmark)
├── Relatório Técnico.pdf   # Relatório técnico completo com fundamentação e resultados
└── README.md               # Documentação do projeto

```

---

## 🚀 Como Executar

### 1. Compilando com otimizações (Recomendado para o Benchmark)

Para obter medições reais de tempo de CPU no teste com 1.000.000 de elementos, compile com a flag `-O2`:

```bash
ghc -O2 portfolio.hs -o portfolio
./portfolio

```

### 2. Executando via interpretador interativo (GHCi)

Para testar funções isoladamente (com otimização de código nativo):

```bash
ghci -O2 -fobject-code portfolio.hs

```

Dentro do GHCi, você pode rodar a execução completa ou chamar funções específicas:

```haskell
main                                               -- Executa validação B3 + Benchmark
retornosDiarioVetor petr4Vetor                     -- Retornos diários via Array
mediaRetornoLista (retornosDiarioLista petr4Lista) -- Média dos retornos via Lista
produtoEscalarVetor pesosVetor retornosMediosVetor -- Retorno esperado da carteira

```

---

## ✅ Validação com Dados da B3

Utilizando uma semana de pregão para **PETR4** (`[38.20, 38.80, 37.90, 39.10, 39.60]`) e uma carteira com alocação de **40% PETR4**, **35% VALE3** e **25% ITUB4**:

| Métrica | Resultado Obtido | Status |
| --- | --- | --- |
| **Retornos Diários (PETR4)** | `[0.015707, -0.023196, 0.031662, 0.012788]`

 | ✔️ Validado |
| **Retorno Médio Diário (PETR4)** | `0.009240` (`0,92%`)

 | ✔️ Validado |
| **Retorno Esperado do Portfólio ($R_p$)** | `0.008210` (`0,82%`)

 | ✔️ Validado |

---

## ⚡ Resultados do Benchmark ($N = 1.000.000$) e Análise Técnica

Tempos de CPU aferidos via `System.CPUTime` no GHC 9.10.3:

| Cenário de Teste | Estrutura | Modo Interpretado | Otimizado (`-O2`) |
| --- | --- | --- | --- |
| **Cenário 1:** Série Temporal (Retorno + Média) | Vetor (`Data.Array`) | `4,890625 s`

 | `0,093750 s`

 |
| **Cenário 1:** Série Temporal (Retorno + Média) | Lista (`[Double]`) | `0,609375 s`

 | `0,078125 s`

 |
| **Cenário 2:** Carteira Massiva (Produto Escalar) | Vetor (`Data.Array`) | `7,312500 s`

 | `0,187500 s`

 |
| **Cenário 2:** Carteira Massiva (Produto Escalar) | Lista (`[Double]`) | `0,218750 s`

 | `0,078125 s`

 |

* **Acesso Indexado $O(1)$ vs. Encadeamento Sequencial:** O tipo `Array Int Double` armazena os dados em blocos contíguos de memória, permitindo acesso posicional direto em tempo constante $O(1)$ via operador `(!)`. Contudo, por ser imutável e *boxed*, exige alocação integral de arrays intermediários e verificações de limites (`bounds checking`) a cada leitura.


* ***Lazy Evaluation* e Fusão de Fluxos:** Em pipelines sequenciais de passagem única (como `sum (zipWith (*) pesos retornos)`), o compilador GHC aplica otimizações de *stream/list fusion* aliadas à avaliação preguiçosa (*lazy evaluation*), consumindo os elementos sob demanda sem alocar estruturas intermediárias gigantes na RAM — o que explica o desempenho superior das listas em ambos os cenários.



---

## 📄 Relatório Técnico

A documentação detalhada contendo a fundamentação teórica, validação passo a passo e análise crítica dos tempos de execução está disponível no arquivo [`Relatório Técnico.pdf`](https://www.google.com/search?q=./Relat%25C3%25B3rio%2520T%25C3%25A9cnico.pdf).

---

## 👩‍💻 Autoria

Desenvolvido por **Larissa Santana Silva** — Universidade Federal de Uberlândia (UFU).

---
