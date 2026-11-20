valorComDesconto :: Float -> Float -> Float
valorComDesconto valor desconto =
    valor - (valor * desconto / 100)

areaRetangulo :: Float -> Float -> Float
areaRetangulo base altura = base * altura

perimetroRetangulo :: Float -> Float -> Float
perimetroRetangulo base altura = 2 * (base + altura)

valorFinal :: Float -> Float -> Float -> Float
valorFinal valor desconto taxa =
    valorComDesconto valor desconto * (1 + taxa / 100)

mediaPonderada :: Float -> Float -> Float -> Float -> Float
mediaPonderada n1 p1 n2 p2 =
    (n1 * p1 + n2 * p2) / (p1 + p2)

novoSalario :: Float -> Float -> Float
novoSalario salario percentualAumento =
    salario * (1 + percentualAumento / 100)

litrosUtilizados :: Float -> Float -> Float
litrosUtilizados velocidade tempo =
    velocidade * tempo
    
celsiusFahrenheit :: Float -> Float
celsiusFahrenheit celsius = (celsius * 1.8) + 32

fahrenheitCelsius :: Float -> Float
fahrenheitCelsius fahrenheit = (fahrenheit - 32) / 1.8

converteTemperatura :: Float -> (Float, Float)
converteTemperatura temperatura = (celsiusFahrenheit temperatura, fahrenheitCelsius temperatura)
