identification division.
program-id. producao-energetica.

environment division.
input-output section.
file-control.
    select arquivo-csv assign to nome-arquivo
        organization is line sequential
        file status is status-arquivo.

data division.
file section.
fd arquivo-csv.
01 linha-csv pic x(256).

working-storage section.
01 nome-arquivo pic x(256).
01 status-arquivo pic xx.
01 fim-arquivo pic x value "N".
01 primeira-linha pic x value "S".
01 linha-trabalho pic x(256).
01 campo-mes pic x(10).
01 campo-petroleo pic x(20).
01 campo-gas pic x(20).
01 campo-pre-sal pic x(20).
01 campo-queima pic x(20).
01 ponteiro binary-long.
01 indice binary-long.
01 tamanho-linha binary-long.
01 valor-numerico pic 9(12)v9(3) value zero.
01 petroleo pic 9(12)v9(3) value zero.
01 gas-milhoes pic 9(8)v9(3) value zero.
01 pre-sal pic 99v9 value zero.
01 queima-milhoes pic 9(8)v9(3) value zero.
01 gas-boe pic 9(12)v9(3) value zero.
01 total-boe pic 9(12)v9(3) value zero.
01 total-petroleo pic 9(15)v9(3) value zero.
01 total-gas-boe pic 9(15)v9(3) value zero.
01 total-boe-geral pic 9(15)v9(3) value zero.
01 total-queima pic 9(12)v9(3) value zero.
01 quantidade-registros binary-long value zero.
01 saida-petroleo pic ZZZ,ZZZ,ZZZ,ZZ9.999.
01 saida-gas pic ZZZ,ZZZ,ZZ9.999.
01 saida-total pic ZZZ,ZZZ,ZZZ,ZZ9.999.
01 saida-queima pic ZZZ,ZZZ,ZZ9.999.

procedure division.
principal.
    move "data/producao_exemplo.csv" to nome-arquivo
    accept nome-arquivo from command-line
    if nome-arquivo = spaces
        move "data/producao_exemplo.csv" to nome-arquivo
    end-if

    open input arquivo-csv
    if status-arquivo not = "00"
        display "ERRO: nao foi possivel abrir o arquivo: "
            function trim(nome-arquivo)
        display "Informe o caminho do CSV como argumento."
        move 1 to return-code
        stop run
    end-if

    display "======================================================"
    display " INTELIGENCIA ENERGETICA - PETROLEO E GAS (COBOL)"
    display "======================================================"
    display "Arquivo: " function trim(nome-arquivo)
    display "Conversao ilustrativa: 1 milhao m3 gas = 6,2898 milhoes boe"
    display " "

    perform until fim-arquivo = "S"
        read arquivo-csv
            at end
                move "S" to fim-arquivo
            not at end
                if primeira-linha = "S"
                    move "N" to primeira-linha
                else
                    perform processar-linha
                end-if
        end-read
    end-perform
    close arquivo-csv

    move total-petroleo to saida-petroleo
    move total-gas-boe to saida-gas
    move total-boe-geral to saida-total
    move total-queima to saida-queima

    display " "
    display "---------------- RESUMO ----------------"
    display "Registros processados: " quantidade-registros
    display "Petroleo acumulado (soma das taxas diarias): "
        function trim(saida-petroleo)
    display "Gas convertido em boe/d (soma das taxas): "
        function trim(saida-gas)
    display "Total equivalente estimado (boe/d somado): "
        function trim(saida-total)
    display "Queima de gas acumulada (soma das taxas): "
        function trim(saida-queima)
    display " "
    display "Nota: somar taxas de meses diferentes nao representa"
    display "uma producao anual. Use os valores por periodo para"
    display "comparacoes temporais e valide a fonte dos dados."
    move 0 to return-code
    stop run.

processar-linha.
    move spaces to campo-mes campo-petroleo campo-gas
                   campo-pre-sal campo-queima
    move 1 to ponteiro
    move 1 to indice
    move 0 to tamanho-linha
    move linha-csv to linha-trabalho
    compute tamanho-linha =
        function length(function trim(linha-trabalho trailing))

    perform until indice > tamanho-linha or ponteiro > 5
        if linha-trabalho(indice:1) = ","
            add 1 to ponteiro
        else
            evaluate ponteiro
                when 1
                    move linha-trabalho(indice:1)
                      to campo-mes(function length(function trim(campo-mes trailing)) + 1:1)
                when 2
                    move linha-trabalho(indice:1)
                      to campo-petroleo(function length(function trim(campo-petroleo trailing)) + 1:1)
                when 3
                    move linha-trabalho(indice:1)
                      to campo-gas(function length(function trim(campo-gas trailing)) + 1:1)
                when 4
                    move linha-trabalho(indice:1)
                      to campo-pre-sal(function length(function trim(campo-pre-sal trailing)) + 1:1)
                when 5
                    move linha-trabalho(indice:1)
                      to campo-queima(function length(function trim(campo-queima trailing)) + 1:1)
            end-evaluate
        end-if
        add 1 to indice
    end-perform

    if campo-mes = spaces
        exit paragraph
    end-if

    if function test-numval(function trim(campo-petroleo)) = 0
        compute petroleo = function numval(campo-petroleo)
    else
        move 0 to petroleo
    end-if
    if function test-numval(function trim(campo-gas)) = 0
        compute gas-milhoes = function numval(campo-gas)
    else
        move 0 to gas-milhoes
    end-if
    if function test-numval(function trim(campo-pre-sal)) = 0
        compute pre-sal = function numval(campo-pre-sal)
    else
        move 0 to pre-sal
    end-if
    if function test-numval(function trim(campo-queima)) = 0
        compute queima-milhoes = function numval(campo-queima)
    else
        move 0 to queima-milhoes
    end-if

    compute gas-boe = gas-milhoes * 1000000 * 6.2898
    compute total-boe = petroleo + gas-boe
    add petroleo to total-petroleo
    add gas-boe to total-gas-boe
    add total-boe to total-boe-geral
    add queima-milhoes to total-queima
    add 1 to quantidade-registros

    move petroleo to saida-petroleo
    display "Periodo: " campo-mes
        " | Petroleo bbl/d: " function trim(saida-petroleo)
    display "  Gas (milhoes m3/d): " gas-milhoes
        " | Pre-sal (%): " pre-sal
        " | Queima (milhoes m3/d): " queima-milhoes
    .
