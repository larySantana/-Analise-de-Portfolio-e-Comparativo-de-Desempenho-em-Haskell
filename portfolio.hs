-- Trabalho: Analise de Portfolio e Desempenho em Haskell
-- Larissa Santana Silva

module Main where

import Data.Array
import System.CPUTime
import Text.Printf (printf)
import Control.Exception (evaluate)

-- Dados de exemplo para validacao (B3)

-- Exemplos em formato Array (Vetor)

petr4Vetor :: Array Int Double
petr4Vetor = array (1,5) [(1,38.20), (2,38.80), (3,37.90), (4,39.10), (5,39.60)]

retornosMediosVetor :: Array Int Double
retornosMediosVetor = array (1,3) [(1,0.0092), (2,0.0068), (3,0.0086)]

pesosVetor :: Array Int Double
pesosVetor = array (1,3) [(1,0.40), (2,0.35), (3,0.25)]

-- Exemplos em formato Lista

petr4Lista :: [Double]
petr4Lista = [38.20, 38.80, 37.90, 39.10, 39.60]

retornosMediosLista :: [Double]
retornosMediosLista = [0.0092, 0.0068, 0.0086]

pesosLista :: [Double]
pesosLista = [0.40, 0.35, 0.25]


-- Parte 1: Implementacao com vetores (Array Int Double)

-- 1.Retorno diario 

retornosDiarioVetor :: Array Int Double -> Array Int Double
retornosDiarioVetor precos
    | n < 2     = array (1, 0) []
    | otherwise = array (1, n - 1)
        [ (i, (precos ! (inf + i) - precos ! (inf + i - 1)) / precos ! (inf + i - 1))
        | i <- [1 .. n - 1]
        ]
  where
    (inf, sup) = bounds precos
    n = sup - inf + 1

-- 2.Média de Retorno

mediaRetornoVetor :: Array Int Double -> Double
mediaRetornoVetor ret
    | n == 0    = 0.0
    | otherwise = sum (elems ret) / fromIntegral n
  where
    (inf, sup) = bounds ret
    n = sup - inf + 1

-- 3.Produto Escalar / Retorno do Portfólio

produtoEscalarVetor :: Array Int Double -> Array Int Double -> Double
produtoEscalarVetor pesos retornos
    | bounds pesos /= bounds retornos = error "Vetores de pesos e retornos devem ter os mesmos limites."
    | otherwise = sum [ (pesos ! i) * (retornos ! i) | i <- range (bounds pesos) ]


-- Parte 2: Implementacao com listas ([Double])

-- 1.Retorno Diário

retornosDiarioLista :: [Double] -> [Double]
retornosDiarioLista []  = []
retornosDiarioLista [_] = []
retornosDiarioLista precos =
    zipWith (\pAtual pAnt -> (pAtual - pAnt) / pAnt) (drop 1 precos) precos

-- 2.Média de Retorno

mediaRetornoLista :: [Double] -> Double
mediaRetornoLista [] = 0.0
mediaRetornoLista xs = sum xs / fromIntegral (length xs)

-- 3.Produto Escalar / Retorno do Portfólio

produtoEscalarLista :: [Double] -> [Double] -> Double
produtoEscalarLista pesos retornos = sum (zipWith (*) pesos retornos)


-- Gerador LCG para simular series maiores

type Semente = Int

lcg :: Semente -> (Double, Semente)
lcg s =
    let s' = (1664525 * s + 1013904223) `mod` (2^32)
        v  = fromIntegral s' / fromIntegral (2^32 :: Int)
    in (v, s')

randomList :: Semente -> Double -> Double -> Int -> [Double]
randomList _ _  _  0 = []
randomList s lo hi n =
    let (v, s') = lcg s
        x = lo + v * (hi - lo)
    in x : randomList s' lo hi (n - 1)

listaParaVetor :: [Double] -> Array Int Double
listaParaVetor xs = listArray (1, length xs) xs


-- Parte 3: Comparativo de desempenho

compararDesempenho :: IO ()
compararDesempenho = do
    let n = 1000000 :: Int
    putStrLn "\nBenchmark: Data.Array vs Lista (N = 1.000.000)"
    putStrLn "Gerando dados em memoria..."

    -- Gera as estruturas antes de ligar o cronometro para medir apenas os calculos
    let precosL = randomList 42 30.0 50.0 n
        precosV = listaParaVetor precosL

        pesosL  = randomList 10 0.01 1.0 n
        ativosL = randomList 99 (-0.05) 0.05 n
        pesosV  = listaParaVetor pesosL
        ativosV = listaParaVetor ativosL

    -- Garante que o Haskell avalie as estruturas antes da medicao (evita distorcao pelo lazy)
    _ <- evaluate (last precosL)
    _ <- evaluate (precosV ! n)
    _ <- evaluate (last pesosL)
    _ <- evaluate (last ativosL)
    _ <- evaluate (pesosV ! n)
    _ <- evaluate (ativosV ! n)

    putStrLn "\nCenario 1: Serie temporal (retorno diario + media)"

    t1Ini <- getCPUTime
    let resC1Vetor = mediaRetornoVetor (retornosDiarioVetor precosV)
    _ <- evaluate resC1Vetor
    t1Fim <- getCPUTime
    let tempoC1Vetor = fromIntegral (t1Fim - t1Ini) / 1e12 :: Double
    printf "Vetor -> Media: %.8f | Tempo: %.6f segundos\n" resC1Vetor tempoC1Vetor

    t2Ini <- getCPUTime
    let resC1Lista = mediaRetornoLista (retornosDiarioLista precosL)
    _ <- evaluate resC1Lista
    t2Fim <- getCPUTime
    let tempoC1Lista = fromIntegral (t2Fim - t2Ini) / 1e12 :: Double
    printf "Lista -> Media: %.8f | Tempo: %.6f segundos\n" resC1Lista tempoC1Lista

    putStrLn "\nCenario 2: Carteira (produto escalar)"

    t3Ini <- getCPUTime
    let resC2Vetor = produtoEscalarVetor pesosV ativosV
    _ <- evaluate resC2Vetor
    t3Fim <- getCPUTime
    let tempoC2Vetor = fromIntegral (t3Fim - t3Ini) / 1e12 :: Double
    printf "Vetor -> Retorno Carteira: %.8f | Tempo: %.6f segundos\n" resC2Vetor tempoC2Vetor

    t4Ini <- getCPUTime
    let resC2Lista = produtoEscalarLista pesosL ativosL
    _ <- evaluate resC2Lista
    t4Fim <- getCPUTime
    let tempoC2Lista = fromIntegral (t4Fim - t4Ini) / 1e12 :: Double
    printf "Lista -> Retorno Carteira: %.8f | Tempo: %.6f segundos\n" resC2Lista tempoC2Lista

{-
Analise de desempenho entre Data.Array e listas:

No acesso por indice, o `Array Int Double` guarda os valores em um bloco
contiguo de memoria, permitindo ler qualquer posicao em tempo constante O(1)
com o operador `(!)`. Ja a lista padrao (`[Double]`) usa encadeamento
sequencial, onde cada celula guarda um valor e o ponteiro para o proximo no.

Na pratica, porem, o vetor nem sempre vence em operacoes de passada unica.
Em `retornosDiarioVetor`, precisamos alocar um novo array intermediario na
memoria antes de calcular a media. Com listas, a lazy evaluation do Haskell
junto com a fusao de fluxos do GHC permite que `zipWith` e `sum` consumam os
valores sob demanda, sem montar uma lista intermediaria de um milhao de
posicoes na RAM de uma vez. Por isso, compilando com `-O2`, as listas costumam
empatar ou superar o `Array` imutavel nos testes sequenciais, enquanto o
vetor leva vantagem quando ha acesso aleatorio ou reuso frequente dos dados.
-}


main :: IO ()
main = do
    putStrLn "Validacao com dados da B3 (PETR4, VALE3, ITUB4)"

    putStrLn "\nParte 1 - Vetores"
    let retV = retornosDiarioVetor petr4Vetor
    putStrLn $ "Retornos diarios PETR4: " ++ show retV
    printf "Media retorno PETR4:    %.6f (%.2f%%)\n" (mediaRetornoVetor retV) (mediaRetornoVetor retV * 100)
    let rpV = produtoEscalarVetor pesosVetor retornosMediosVetor
    printf "Retorno Portfolio:      %.6f (%.2f%%)\n" rpV (rpV * 100)

    putStrLn "\nParte 2 - Listas"
    let retL = retornosDiarioLista petr4Lista
    putStrLn $ "Retornos diarios PETR4: " ++ show retL
    printf "Media retorno PETR4:    %.6f (%.2f%%)\n" (mediaRetornoLista retL) (mediaRetornoLista retL * 100)
    let rpL = produtoEscalarLista pesosLista retornosMediosLista
    printf "Retorno Portfolio:      %.6f (%.2f%%)\n" rpL (rpL * 100)

    compararDesempenho