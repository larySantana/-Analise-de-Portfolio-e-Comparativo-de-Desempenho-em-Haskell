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
├── portifolio.hs   # Código-fonte completo (implementação, validação B3 e benchmark)
└── README.md       # Documentação do projeto
