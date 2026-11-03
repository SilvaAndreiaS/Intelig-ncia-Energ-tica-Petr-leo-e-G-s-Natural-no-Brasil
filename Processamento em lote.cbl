IDENTIFICATION DIVISION.
       PROGRAM-ID. PRODUCAO.
       AUTHOR. PROJETO-INTELIGENCIA-ENERGETICA.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION ALL INTRINSIC.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ARQ-CSV ASSIGN TO WS-CAMINHO-ARQUIVO
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  ARQ-CSV.
       01  LINHA-CSV                    PIC X(256).

       WORKING-STORAGE SECTION.
       01  WS-CAMINHO-ARQUIVO           PIC X(256) 
                                        VALUE "data/producao_exemplo.csv".
       01  WS-ARG-LINHA                 PIC X(256) VALUE SPACES.
       01  WS-FILE-STATUS               PIC X(02)  VALUE "00".
       
       01  WS-FLAGS.
           05 SW-EOF                    PIC X(01)  VALUE 'N'.
              88 FIM-DE-ARQUIVO                    VALUE 'S'.
           05 SW-CABECALHO              PIC X(01)  VALUE 'S'.
              88 PRIMEIRA-LINHA                    VALUE 'S'.
              88 DADOS-VALIDOS                     VALUE 'N'.

      *> Fator de conversao: 1 milhao m3/d de gas = 6.289,8 boe/d
       01  WS-CONSTANTES.
           05 C-FATOR-GAS-MM3-BOE       PIC 9(05)V9999 VALUE 6289.8000.
           05 C-LIMITE-EXIBICAO         PIC 9(05)      VALUE 20.

       COPY "registro-producao.cpy".

       01  WS-ACUMULADORES.
           05 TOT-REGISTROS             PIC 9(07)      VALUE 0.
           05 SOMA-PETROLEO             PIC 9(14)V99   COMP-3 VALUE 0.
           05 SOMA-GAS                  PIC 9(12)V99   COMP-3 VALUE 0.
           05 SOMA-PRE-SAL-PCT          PIC 9(12)V99   COMP-3 VALUE 0.
           05 SOMA-QUEIMA               PIC 9(12)V99   COMP-3 VALUE 0.
           05 SOMA-BOE                  PIC 9(15)V99   COMP-3 VALUE 0.
           05 SOMA-BOE-PRE-SAL          PIC 9(15)V99   COMP-3 VALUE 0.

       01  WS-MEDIAS.
           05 MED-PETROLEO              PIC ZZZ,ZZZ,ZZ9.99.
           05 MED-GAS                   PIC ZZZ,ZZ9.99.
           05 MED-PRE-SAL-PCT           PIC ZZ9.99.
           05 MED-QUEIMA                PIC ZZZ,ZZ9.99.
           05 MED-BOE                   PIC ZZZ,ZZZ,ZZ9.99.
           05 MED-BOE-PRE-SAL           PIC ZZZ,ZZZ,ZZ9.99.
           05 PCT-QUEIMA-GAS            PIC ZZ9.99.
           05 CALC-AUX                  PIC 9(14)V99   COMP-3 VALUE 0.
           05 TOT-REG-FORMAT            PIC Z,ZZZ,ZZ9.

       01  WS-LINHA-DETALHE.
           05 DET-MES                   PIC X(07).
           05 FILLER                    PIC X(03) VALUE " | ".
           05 DET-PETROLEO              PIC ZZZ,ZZZ,ZZ9.99.
           05 FILLER                    PIC X(03) VALUE " | ".
           05 DET-GAS                   PIC ZZ,ZZ9.99.
           05 FILLER                    PIC X(03) VALUE " | ".
           05 DET-PRE-SAL               PIC ZZ9.99.
           05 FILLER                    PIC X(04) VALUE "% | ".
           05 DET-QUEIMA                PIC ZZ9.99.
           05 FILLER                    PIC X(03) VALUE " | ".
           05 DET-BOE                   PIC ZZZ,ZZZ,ZZ9.99.

       PROCEDURE DIVISION.
       0000-PRINCIPAL.
           PERFORM 1000-INICIALIZAR
           PERFORM 2000-PROCESSAR-ARQUIVO UNTIL FIM-DE-ARQUIVO
           PERFORM 3000-EXIBIR-RESUMO
           PERFORM 9000-FINALIZAR
           STOP RUN.

       1000-INICIALIZAR.
           ACCEPT WS-ARG-LINHA FROM COMMAND-LINE
           IF TRIM(WS-ARG-LINHA) NOT EQUAL SPACES
               MOVE TRIM(WS-ARG-LINHA) TO WS-CAMINHO-ARQUIVO
           END-IF

           OPEN INPUT ARQ-CSV
           IF WS-FILE-STATUS NOT EQUAL "00"
               DISPLAY "ERRO AO ABRIR ARQUIVO: " TRIM(WS-CAMINHO-ARQUIVO)
               DISPLAY "FILE STATUS: " WS-FILE-STATUS
               STOP RUN
           END-IF

           DISPLAY "================================================================================"
           DISPLAY "           INTELIGENCIA ENERGETICA - RELATORIO DE PRODUCAO (O&G)                "
           DISPLAY "================================================================================"
           DISPLAY "Arquivo origem : " TRIM(WS-CAMINHO-ARQUIVO)
           DISPLAY "Aviso          : Verifique se a base corresponde a dados de teste ou oficiais."
           DISPLAY "--------------------------------------------------------------------------------"
           DISPLAY "MES     | PETROLEO (bbl/d) | GAS (Mm3/d) | PRE-SAL | QUEIMA   | TOTAL (boe/d)"
           DISPLAY "--------------------------------------------------------------------------------".

       2000-PROCESSAR-ARQUIVO.
           READ ARQ-CSV
               AT END
                   SET FIM-DE-ARQUIVO TO TRUE
               NOT AT END
                   IF PRIMEIRA-LINHA
                       SET DADOS-VALIDOS TO TRUE
                   ELSE
                       IF TRIM(LINHA-CSV) NOT EQUAL SPACES
                           PERFORM 2100-PARSEAR-E-CALCULAR
                       END-IF
                   END-IF
           END-READ.

       2100-PARSEAR-E-CALCULAR.
           INITIALIZE REG-PRODUCAO-STR
           INITIALIZE REG-PRODUCAO-NUM

           UNSTRING LINHA-CSV DELIMITED BY ","
               INTO STR-MES
                    STR-PETROLEO
                    STR-GAS
                    STR-PRE-SAL
                    STR-QUEIMA
                    STR-BOE
           END-UNSTRING

           MOVE STR-MES(1:7)            TO NUM-MES
           MOVE NUMVAL(STR-PETROLEO)    TO NUM-PETROLEO-BBL
           MOVE NUMVAL(STR-GAS)         TO NUM-GAS-MM3
           MOVE NUMVAL(STR-PRE-SAL)     TO NUM-PRE-SAL-PCT
           MOVE NUMVAL(STR-QUEIMA)      TO NUM-QUEIMA-MM3

           IF TRIM(STR-BOE) NOT EQUAL SPACES AND NUMVAL(STR-BOE) > 0
               MOVE NUMVAL(STR-BOE)     TO NUM-BOE-TOTAL
           ELSE
               COMPUTE NUM-BOE-TOTAL ROUNDED =
                   NUM-PETROLEO-BBL + (NUM-GAS-MM3 * C-FATOR-GAS-MM3-BOE)
           END-IF

           COMPUTE NUM-BOE-PRE-SAL ROUNDED =
               NUM-BOE-TOTAL * (NUM-PRE-SAL-PCT / 100)

           ADD 1                        TO TOT-REGISTROS
           ADD NUM-PETROLEO-BBL         TO SOMA-PETROLEO
           ADD NUM-GAS-MM3              TO SOMA-GAS
           ADD NUM-PRE-SAL-PCT          TO SOMA-PRE-SAL-PCT
           ADD NUM-QUEIMA-MM3           TO SOMA-QUEIMA
           ADD NUM-BOE-TOTAL            TO SOMA-BOE
           ADD NUM-BOE-PRE-SAL          TO SOMA-BOE-PRE-SAL

           IF TOT-REGISTROS <= C-LIMITE-EXIBICAO
               MOVE NUM-MES             TO DET-MES
               MOVE NUM-PETROLEO-BBL    TO DET-PETROLEO
               MOVE NUM-GAS-MM3         TO DET-GAS
               MOVE NUM-PRE-SAL-PCT     TO DET-PRE-SAL
               MOVE NUM-QUEIMA-MM3      TO DET-QUEIMA
               MOVE NUM-BOE-TOTAL       TO DET-BOE
               DISPLAY WS-LINHA-DETALHE
           ELSE
               IF TOT-REGISTROS = (C-LIMITE-EXIBICAO + 1)
                   DISPLAY "... [Exibicao detalhada limitada aos primeiros 20 registros para lote] ..."
               END-IF
           END-IF.

       3000-EXIBIR-RESUMO.
           DISPLAY "--------------------------------------------------------------------------------"
           IF TOT-REGISTROS > 0
               MOVE TOT-REGISTROS TO TOT-REG-FORMAT

               COMPUTE CALC-AUX ROUNDED = SOMA-PETROLEO / TOT-REGISTROS
               MOVE CALC-AUX TO MED-PETROLEO

               COMPUTE CALC-AUX ROUNDED = SOMA-GAS / TOT-REGISTROS
               MOVE CALC-AUX TO MED-GAS

               COMPUTE CALC-AUX ROUNDED = SOMA-PRE-SAL-PCT / TOT-REGISTROS
               MOVE CALC-AUX TO MED-PRE-SAL-PCT

               COMPUTE CALC-AUX ROUNDED = SOMA-QUEIMA / TOT-REGISTROS
               MOVE CALC-AUX TO MED-QUEIMA

               COMPUTE CALC-AUX ROUNDED = SOMA-BOE / TOT-REGISTROS
               MOVE CALC-AUX TO MED-BOE

               COMPUTE CALC-AUX ROUNDED = SOMA-BOE-PRE-SAL / TOT-REGISTROS
               MOVE CALC-AUX TO MED-BOE-PRE-SAL

               IF SOMA-GAS > 0
                   COMPUTE CALC-AUX ROUNDED = (SOMA-QUEIMA / SOMA-GAS) * 100
                   MOVE CALC-AUX TO PCT-QUEIMA-GAS
               ELSE
                   MOVE 0 TO PCT-QUEIMA-GAS
               END-IF

               DISPLAY "RESUMO DOS INDICADORES CONSOLIDADOS"
               DISPLAY "Registros processados         : " TRIM(TOT-REG-FORMAT)
               DISPLAY "Media Petroleo (bbl/d)        : " TRIM(MED-PETROLEO)
               DISPLAY "Media Gas Natural (MMm3/d)    : " TRIM(MED-GAS)
               DISPLAY "Media Total Equivalente(boe/d): " TRIM(MED-BOE)
               DISPLAY "Media Participacao Pre-Sal    : " TRIM(MED-PRE-SAL-PCT) " %"
               DISPLAY "Volume Estimado Pre-Sal(boe/d): " TRIM(MED-BOE-PRE-SAL)
               DISPLAY "Media Queima de Gas (MMm3/d)  : " TRIM(MED-QUEIMA)
               DISPLAY "Indice de Queima / Producao   : " TRIM(PCT-QUEIMA-GAS) " %"
           ELSE
               DISPLAY "Nenhum registro valido encontrado para processamento."
           END-IF
           DISPLAY "================================================================================".

       9000-FINALIZAR.
           CLOSE ARQ-CSV.
