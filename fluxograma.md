# Fluxograma do processamento

```text
[Início]
   |
   v
[Receber caminho do CSV]
   |
   v
[Abrir arquivo]
   | falha
   +------> [Exibir erro e encerrar]
   |
   v
[Ler cabeçalho]
   |
   v
[Ler próxima linha]
   |
   v
{Fim do arquivo?} -- sim --> [Exibir resumo] --> [Encerrar]
   |
  não
   v
[Separar os cinco campos]
   |
   v
[Validar e converter números]
   |
   v
[Converter gás para boe/d]
   |
   v
[Calcular total equivalente e acumular]
   |
   v
[Exibir período]
   |
   +-----------> [Ler próxima linha]
```
