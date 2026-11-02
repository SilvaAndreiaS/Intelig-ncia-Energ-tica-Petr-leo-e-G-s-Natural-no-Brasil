# Casos de teste manuais

Como o projeto é COBOL puro e não inclui framework de testes externo, use estes testes de aceitação após compilar.

1. **CSV de exemplo:** execute `./producao data/producao_exemplo.csv`; deve processar três registros.
2. **Caminho inexistente:** execute `./producao data/nao_existe.csv`; deve exibir mensagem de erro e terminar com código diferente de zero.
3. **CSV somente com cabeçalho:** deve processar zero registros e mostrar resumo com contagem zero.
4. **Valores de gás:** para 1,0 milhão m³/d, a conversão ilustrativa deve resultar em aproximadamente 6.289.800 boe/d.
5. **Dados reais:** confira unidades, separador decimal e fator de conversão antes de substituir o arquivo de exemplo.

Observação: os casos documentam comportamento esperado; não significam que testes automatizados foram executados neste ambiente.
