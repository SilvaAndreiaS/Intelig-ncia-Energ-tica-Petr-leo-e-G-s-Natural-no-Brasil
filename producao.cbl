IDENTIFICATION DIVISION.
       PROGRAM-ID. PRODUCAO-PARAMS.
       AUTHOR. ENGENHARIA-DE-DADOS.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-LINHA-COMANDO        PIC X(120) VALUE SPACES.
       01  WS-STR-POCO             PIC X(15) VALUE SPACES.
       01  WS-STR-OLEO             PIC X(10) VALUE SPACES.
       01  WS-STR-GAS              PIC X(10) VALUE SPACES.
       01  WS-STR-BRENT            PIC X(08) VALUE SPACES.
       01  WS-STR-PRECO-GAS        PIC X(06) VALUE SPACES.

       01  WS-VOL-OLEO-BBL         PIC 9(07)V99 VALUE ZERO.
       01  WS-VOL-GAS-M3           PIC 9(08)V99 VALUE ZERO.
       01  WS-PRECO-BRENT          PIC 9(04)V99 VALUE ZERO.
       01  WS-PRECO-GAS            PIC 9(03)V99 VALUE ZERO.

       01  WS-FATOR-CONV-GAS       PIC 9(01)V9999 VALUE 6,2898.
       01  WS-TAXA-ROYALTY         PIC 9(02)V99   VALUE 0,10.

       01  WS-GAS-BOE              PIC 9(07)V99 VALUE ZERO.
       01  WS-TOTAL-BOE            PIC 9(08)V99 VALUE ZERO.
       01  WS-REC-OLEO             PIC 9(10)V99 VALUE ZERO.
       01  WS-REC-GAS              PIC 9(10)V99 VALUE ZERO.
       01  WS-RECEITA-BRUTA        PIC 9(11)V99 VALUE ZERO.
       01  WS-VALOR-ROYALTIES      PIC 9(10)V99 VALUE ZERO.
       01  WS-RECEITA-LIQUIDA      PIC 9(11)V99 VALUE ZERO.

       01  WS-F-OLEO               PIC Z.ZZZ.ZZ9,99.
       01  WS-F-GAS                PIC ZZZ.ZZZ.ZZ9,99.
       01  WS-F-GAS-BOE            PIC Z.ZZZ.ZZ9,99.
       01  WS-F-TOTAL-BOE          PIC ZZ.ZZZ.ZZ9,99.
       01  WS-F-REC-BRUTA          PIC $ZZZ.ZZZ.ZZ9,99.
       01  WS-F-ROYALTIES          PIC $ZZZ.ZZZ.ZZ9,99.
       01  WS-F-REC-LIQUIDA        PIC $ZZZ.ZZZ.ZZ9,99.

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           ACCEPT WS-LINHA-COMANDO FROM COMMAND-LINE.

           IF WS-LINHA-COMANDO = SPACES
               PERFORM 900-EXIBIR-AJUDA
               STOP RUN
           END-IF.

           UNSTRING WS-LINHA-COMANDO DELIMITED BY ALL SPACES
               INTO WS-STR-POCO
                    WS-STR-OLEO
                    WS-STR-GAS
                    WS-STR-BRENT
                    WS-STR-PRECO-GAS.

           FUNCTION NUMVAL(WS-STR-OLEO)      INTO WS-VOL-OLEO-BBL.
           FUNCTION NUMVAL(WS-STR-GAS)       INTO WS-VOL-GAS-M3.
           FUNCTION NUMVAL(WS-STR-BRENT)     INTO WS-PRECO-BRENT.
           FUNCTION NUMVAL(WS-STR-PRECO-GAS) INTO WS-PRECO-GAS.

           PERFORM 200-CALCULOS.
           PERFORM 300-EXIBIR-RELATORIO.
           STOP RUN.

       200-CALCULOS.
           COMPUTE WS-GAS-BOE ROUNDED = 
               (WS-VOL-GAS-M3 / 1000) * WS-FATOR-CONV-GAS.

           COMPUTE WS-TOTAL-BOE = 
               WS-VOL-OLEO-BBL + WS-GAS-BOE.

           COMPUTE WS-REC-OLEO ROUNDED = 
               WS-VOL-OLEO-BBL * WS-PRECO-BRENT.

           COMPUTE WS-REC-GAS ROUNDED = 
               WS-VOL-GAS-M3 * WS-PRECO-GAS.

           COMPUTE WS-RECEITA-BRUTA = 
               WS-REC-OLEO + WS-REC-GAS.

           COMPUTE WS-VALOR-ROYALTIES ROUNDED = 
               WS-RECEITA-BRUTA * WS-TAXA-ROYALTY.

           COMPUTE WS-RECEITA-LIQUIDA = 
               WS-RECEITA-BRUTA - WS-VALOR-ROYALTIES.

       300-EXIBIR-RELATORIO.
           MOVE WS-VOL-OLEO-BBL    TO WS-F-OLEO.
           MOVE WS-VOL-GAS-M3      TO WS-F-GAS.
           MOVE WS-GAS-BOE         TO WS-F-GAS-BOE.
           MOVE WS-TOTAL-BOE       TO WS-F-TOTAL-BOE.
           MOVE WS-RECEITA-BRUTA   TO WS-F-REC-BRUTA.
           MOVE WS-VALOR-ROYALTIES TO WS-F-ROYALTIES.
           MOVE WS-RECEITA-LIQUIDA TO WS-F-REC-LIQUIDA.

           DISPLAY "==================================================".
           DISPLAY "      RELATORIO DE PRODUCAO - PARAMETRIZADO       ".
           DISPLAY "==================================================".
           DISPLAY "POCO/PLATAFORMA     : " WS-STR-POCO.
           DISPLAY "--------------------------------------------------".
           DISPLAY "PRODUCAO OLEO (BBL) : " WS-F-OLEO.
           DISPLAY "PRODUCAO GAS (M3)   : " WS-F-GAS.
           DISPLAY "GAS EQUIVALENTE BOE : " WS-F-GAS-BOE.
           DISPLAY "TOTAL PRODUZIDO BOE : " WS-F-TOTAL-BOE.
           DISPLAY "--------------------------------------------------".
           DISPLAY "RECEITA BRUTA (USD) : " WS-F-REC-BRUTA.
           DISPLAY "ROYALTIES DEV. (10%): " WS-F-ROYALTIES.
           DISPLAY "RECEITA LIQUIDA     : " WS-F-REC-LIQUIDA.
           DISPLAY "==================================================".

       900-EXIBIR-AJUDA.
           DISPLAY "ERRO: Parametros nao informados!".
           DISPLAY "Uso: ./producao_params <POCO> <OLEO> <GAS> <PRECO_BRENT> <PRECO_GAS>".
