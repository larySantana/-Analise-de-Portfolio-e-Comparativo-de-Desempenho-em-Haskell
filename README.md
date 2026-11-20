# 📊 Análise de Portfólio e Comparativo de Desempenho em Haskell

![Haskell](https://img.shields.io/badge/Haskell-5e5086?style=for-the-badge&logo=haskell&logoColor=white)
![Status](https://img.shields.io/badge/Status-Concluído-brightgreen?style=for-the-badge)

Trabalho de **Programação Funcional** focado na implementação de métricas quantitativas de risco e retorno financeiro em **Haskell**, comparando duas estruturas de dados fundamentais da linguagem: **Vetores indexados (`Data.Array`)** e **Listas encadeadas (`[Double]`)** em cenários de larga escala.

---

## 🎯 Objetivos do Projeto

1. **Implementar operações financeiras essenciais** em duas abordagens distintas (vetores vs. listas):
   * **Retorno Diário:** $R_t = \frac{P_t - P_{t-1}}{P_{t-1}}$
   * **Média de Retorno:** $\bar{R} = \frac{1}{n} \sum_{i=1}^{n} R_i$
   * **Produto Escalar (Retorno Esperado do Portfólio):** $R_p = \sum_{i=1}^{n} w_i \cdot r_i$
2. **Validar os algoritmos** com ativos reais da **B3** (`PETR4`, `VALE3` e `ITUB4`).
3. **Avaliar o desempenho computacional** (`System.CPUTime`) com séries simuladas de **1.000.000 de elementos**, analisando os impactos de acesso indexado $O(1)$, *lazy evaluation* e alocação de memória.

---

## 🗂️ Estrutura do Repositório

```text
├── portifolio.hs                     # Código-fonte completo (implementação, validação B3 e benchmark)
├── relatorio_portfolio_haskell.pdf   # Relatório técnico completo com fundamentação e resultados
└── README.md                         # Documentação do projeto

```

---

## 🚀 Como Executar

### 1. Compilando com otimizações (Recomendado para o Benchmark)

Para obter medições reais de tempo de CPU no teste com 1.000.000 de elementos, compile com a flag `-O2`:

```bash
ghc -O2 portifolio.hs -o portifolio
./portifolio

```

*(No Windows, execute `.\portifolio.exe`)*

### 2. Executando via interpretador interativo (GHCi)

Para testar funções isoladamente:

```bash
ghci portifolio.hs

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

| Métrica | Resultado Esperado | Status |
| --- | --- | --- |
| **Retornos Diários (PETR4)** | `[0.015707, -0.023196, 0.031662, 0.012788]` | ✔️ Validado |
| **Retorno Médio Diário (PETR4)** | `0.009240` (`0,92%`) | ✔️ Validado |
| **Retorno Esperado do Portfólio ($R_p$)** | `0.008210` (`0,82%`) | ✔️ Validado |

---

## ⚡ Análise Técnica de Desempenho (`Data.Array` vs. `[Double]`)

* **Acesso Indexado $O(1)$ vs. Encadeamento Sequencial:** O tipo `Array Int Double` armazena os dados em blocos contíguos de memória, permitindo acesso posicional direto em tempo constante $O(1)$ via operador `(!)`. Já as listas (`[Double]`) utilizam encadeamento simples (*cons cells*), exigindo travessia sequencial $O(n)$ para acesso arbitrário.
* ***Lazy Evaluation* e Fusão de Fluxos:** Em pipelines sequenciais de passagem única (como `sum (zipWith (*) pesos retornos)`), o compilador GHC aplica otimizações de *stream/list fusion* aliadas à avaliação preguiçosa (*lazy evaluation*), consumindo os elementos sob demanda sem alocar estruturas intermediárias gigantes na RAM. Por outro lado, o `Array` destaca-se em cenários que exigem acesso aleatório ou reuso frequente dos índices.

---

## 📄 Relatório Técnico

A documentação detalhada contendo a fundamentação teórica, código comentado, validação passo a passo e análise crítica dos tempos de execução está disponível no arquivo [`relatorio_portfolio_haskell.pdf`](https://www.google.com/search?q=./relatorio_portfolio_haskell.pdf).

---

## 👩‍💻 Autoria

Desenvolvido por **Larissa Santana Silva** — Universidade Federal de Uberlândia (UFU).

---
