
`timescale 1ns / 1ps

module tb_reloj_top;

    // --------------------------------
    // 1. SEÑALES DEL TESTBENCH
    // --------------------------------

    reg clk;
    reg reset;

    // Entradas del RTC (BCD)
    reg [7:0] rtc_seconds;
    reg [7:0] rtc_minutes;
    reg [7:0] rtc_hours;
    reg [7:0] rtc_day;
    reg [7:0] rtc_month;
    reg [7:0] rtc_weekday;
    reg [7:0] rtc_year;

    reg rtc_valid;

    // Salidas del reloj
    wire [5:0] segundos;
    wire [5:0] minutos;
    wire [4:0] horas;
    wire [4:0] dia;
    wire [2:0] semana;
    wire [3:0] mes;
    wire [6:0] anio;


    // --------------------------------
    // 2. INSTANCIA DEL RELOJ
    // --------------------------------

    reloj_top #(
        .CLK_FREQ(4)
    ) uut (
        .clk(clk),
        .reset(reset),

        // Entradas RTC
        .rtc_seconds(rtc_seconds),
        .rtc_minutes(rtc_minutes),
        .rtc_hours(rtc_hours),
        .rtc_day(rtc_day),
        .rtc_month(rtc_month),
        .rtc_weekday(rtc_weekday),
        .rtc_year(rtc_year),
        .rtc_valid(rtc_valid),

        // Salidas
        .segundos(segundos),
        .minutos(minutos),
        .horas(horas),
        .dia(dia),
        .semana(semana),
        .mes(mes),
        .anio(anio)
    );


    // --------------------------------
    // 3. GENERADOR DE RELOJ
    // --------------------------------

    always #5 clk = ~clk;


    // --------------------------------
    // 4. MONITOREO DE SEÑALES
    // --------------------------------

    initial begin
        $monitor(
            "Tiempo=%0t | tick=%b | Hora=%0d:%0d:%0d | Fecha=%0d/%0d/%0d | Semana=%0d",
            $time,
            uut.tick_1s,
            horas,
            minutos,
            segundos,
            dia,
            mes,
            anio,
            semana
        );
    end


    // --------------------------------
    // 5. ESPERAR UN TICK DE SEGUNDO
    // --------------------------------

    task esperar_segundo;
        begin
            @(posedge uut.tick_1s);
            @(negedge uut.tick_1s);
            #1;
        end
    endtask


    // --------------------------------
    // 6. PRUEBA GENERAL
    // --------------------------------

    initial begin

        // Inicialización
        clk = 0;
        reset = 1;

        // Datos iniciales del RTC
        rtc_seconds = 8'h58;
        rtc_minutes = 8'h59;
        rtc_hours = 8'h23;

        rtc_day = 8'h31;
        rtc_month = 8'h12;
        rtc_weekday = 8'h07;
        rtc_year = 8'h24;

        rtc_valid = 0;

        // Archivo de ondas
        $dumpfile("reloj_top.vcd");
        $dumpvars(0, tb_reloj_top);


        // --------------------------------
        // LIBERAR RESET
        // --------------------------------

        #20;
        reset = 0;

        // Datos del RTC disponibles
        #10;
        rtc_valid = 1;

        // Esperar carga inicial
        #10;
        rtc_valid = 0;


        // --------------------------------
        // VERIFICAR CARGA INICIAL
        // --------------------------------

        $display("");
        $display("--------------------------------");
        $display(" VERIFICACION DE CARGA INICIAL");
        $display("--------------------------------");

        $display("Hora: %0d:%0d:%0d",
            horas, minutos, segundos);

        $display("Fecha: %0d/%0d/%0d",
            dia, mes, anio);

        $display("Semana: %0d", semana);


        // --------------------------------
        // AVANCE DE SEGUNDOS
        // --------------------------------

        $display("");
        $display("--------------------------------");
        $display(" AVANCE DEL RELOJ");
        $display("--------------------------------");

        esperar_segundo;

        $display("Segundo 1: %0d:%0d:%0d",
            horas, minutos, segundos);

        esperar_segundo;

        $display("Segundo 2: %0d:%0d:%0d",
            horas, minutos, segundos);

        esperar_segundo;

        $display("Segundo 3: %0d:%0d:%0d",
            horas, minutos, segundos);


        // --------------------------------
        // COMPROBACION DE RESULTADOS
        // --------------------------------

        $display("");
        $display("--------------------------------");
        $display(" RESULTADO FINAL");
        $display("--------------------------------");

        if (segundos == 1 &&
            minutos == 0 &&
            horas == 0 &&
            dia == 1 &&
            mes == 1 &&
            anio == 25 &&
            semana == 1) begin

            $display("PRUEBA SUPERADA");
            $display("Cambio de ano y calendario correcto.");

        end else begin

            $display("ERROR EN LA SIMULACION");

            $display("Hora: %0d:%0d:%0d",
                horas, minutos, segundos);

            $display("Fecha: %0d/%0d/%0d",
                dia, mes, anio);

            $display("Semana: %0d", semana);

        end

        #20;
        $finish;

    end

endmodule
