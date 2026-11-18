
`timescale 1ns / 1ps

module tb_top_reloj_RTC_integrado;

    reg clk = 0;
    reg reset = 1;
    reg sensor_eh = 0;

    wire RTC_CE;
    wire RTC_SCLK;
    tri1 RTC_DAT;

    wire rtc_valid;
    wire [7:0] seconds;
    wire [7:0] minutes;
    wire [7:0] hours;

    wire [7:0] angulo;
    wire [7:0] angulo_hor;
    wire [7:0] angulo_min;
    wire [7:0] angulo_seg;

    wire match_hor;
    wire match_min;
    wire match_seg;

    integer errores = 0;

    reg prueba_rtc = 0;
    reg prueba_hora = 0;
    reg prueba_64 = 0;
    reg prueba_128 = 0;

    // =========================================
    // RELOJ DE 27 MHz
    // =========================================

    always #18.5 clk = ~clk;

    // =========================================
    // TOP INTEGRADO
    // =========================================

    top_reloj_RTC_integrado #(
        .CLK_FREQ(27_000_000),
        .START_DELAY_US(5)
    ) dut (
        .clk(clk),
        .reset(reset),
        .sensor_eh(sensor_eh),

        .RTC_CE(RTC_CE),
        .RTC_SCLK(RTC_SCLK),
        .RTC_DAT(RTC_DAT),

        .rtc_valid_out(rtc_valid),
        .rtc_seconds_out(seconds),
        .rtc_minutes_out(minutes),
        .rtc_hours_out(hours),

        .angulo(angulo),
        .angulo_hor(angulo_hor),
        .angulo_min(angulo_min),
        .angulo_seg(angulo_seg),

        .match_hor(match_hor),
        .match_min(match_min),
        .match_seg(match_seg)
    );

    // =========================================
    // MODELO SIMULADO DEL DS1302
    // =========================================

    reg rtc_drive_en = 0;
    reg rtc_drive = 0;

    assign RTC_DAT = rtc_drive_en ? rtc_drive : 1'bz;

    reg [7:0] command_shift = 0;
    integer command_bits = 0;

    reg read_mode = 0;
    integer data_bit_index = 0;

    reg [63:0] burst_data;

    initial begin
        burst_data = {
            8'h00,  // Control
            8'h26,  // Año
            8'h03,  // Dia semana
            8'h11,  // Mes
            8'h07,  // Dia
            8'h03,  // Horas
            8'h15,  // Minutos
            8'h30   // Segundos
        };
    end

    // Recepcion del comando
    always @(posedge RTC_SCLK) begin
        if (RTC_CE && !read_mode) begin

            command_shift <= {
                RTC_DAT,
                command_shift[7:1]
            };

            command_bits <= command_bits + 1;

            if (command_bits == 7) begin
                read_mode <= 1;
                data_bit_index <= 0;
            end
        end
    end

    // Transmision de datos
    always @(negedge RTC_SCLK) begin
        if (RTC_CE && read_mode) begin

            if (data_bit_index < 64) begin
                rtc_drive_en <= 1;
                rtc_drive <= burst_data[data_bit_index];

                data_bit_index <= data_bit_index + 1;
            end
            else begin
                rtc_drive_en <= 0;
            end
        end
    end

    always @(negedge RTC_CE) begin
        rtc_drive_en <= 0;
    end

    // =========================================
    // GENERADOR DE PULSO HALL
    // =========================================

    task pulso_hall;
    begin
        sensor_eh = 1;
        repeat (4) @(negedge clk);
        sensor_eh = 0;
    end
    endtask

    // =========================================
    // VERIFICACION DEL RTC
    // =========================================

    initial begin
        wait(rtc_valid == 1'b1);
        #100;

        $display("");
        $display("========== DATOS RTC ==========");

        $display("Segundos: %h", seconds);
        $display("Minutos : %h", minutes);
        $display("Horas   : %h", hours);

        if (
            seconds === 8'h30 &&
            minutes === 8'h15 &&
            hours   === 8'h03 &&
            command_shift === 8'hBF
        ) begin
            prueba_rtc = 1;
            $display("RTC: OK");
        end
        else begin
            errores = errores + 1;
            $display("RTC: ERROR");
        end
    end

    // =========================================
    // VERIFICACION DE ANGULOS Y COMPARADORES
    // =========================================

    always @(negedge clk) begin
        if (!reset && rtc_valid) begin

            // Angulo 64: horas y minutos
            if (angulo == 8'd64) begin
                if (match_hor && match_min && !match_seg) begin
                    prueba_64 = 1;
                end
            end

            // Angulo 128: segundos
            if (angulo == 8'd128) begin
                if (match_seg && !match_hor && !match_min) begin
                    prueba_128 = 1;
                end
            end

        end
    end

    // =========================================
    // SECUENCIA PRINCIPAL
    // =========================================

    initial begin

        $dumpfile("top_reloj_RTC_integrado.vcd");
        $dumpvars(0, tb_top_reloj_RTC_integrado);

        $display("======================================");
        $display(" INICIO SIMULACION RELOJ POV CON RTC");
        $display("======================================");

        repeat (5) @(negedge clk);
        reset = 0;

        // Esperar lectura real del modelo RTC
        wait(rtc_valid == 1'b1);
        repeat (5) @(negedge clk);

        // Verificar carga inicial del reloj
        if (
            dut.sistema_reloj.bloque_reloj.reloj.segundos == 6'd30 &&
            dut.sistema_reloj.bloque_reloj.reloj.minutos == 6'd15 &&
            dut.sistema_reloj.bloque_reloj.reloj.horas_visualizacion == 5'd3
        ) begin
            prueba_hora = 1;
            $display("Carga inicial del reloj: OK");
        end
        else begin
            errores = errores + 1;
            $display("Carga inicial del reloj: ERROR");
        end

        // Primera vuelta: establece referencia Hall
        pulso_hall();

        // Periodo de vuelta: 5120 ciclos
        repeat (5116) @(negedge clk);

        // Segunda vuelta: mide periodo y reinicia angulo
        pulso_hall();

        // Esperar hasta recorrer al menos 128 posiciones
        repeat (2700) @(negedge clk);

        // =====================================
        // RESULTADOS
        // =====================================

        $display("");
        $display("========== RESULTADOS ==========");

        $display("RTC valido       : %b", prueba_rtc);
        $display("Carga inicial    : %b", prueba_hora);

        $display("Angulo horas     : %0d", angulo_hor);
        $display("Angulo minutos   : %0d", angulo_min);
        $display("Angulo segundos  : %0d", angulo_seg);

        $display("Coincidencia 64  : %b", prueba_64);
        $display("Coincidencia 128 : %b", prueba_128);

        $display("Angulo actual    : %0d", angulo);

        // Comprobar direcciones esperadas
        if (
            angulo_hor !== 8'd64 ||
            angulo_min !== 8'd64 ||
            angulo_seg !== 8'd128
        ) begin
            errores = errores + 1;
            $display("ERROR: posiciones angulares incorrectas");
        end

        if (!prueba_64) begin
            errores = errores + 1;
            $display("ERROR: no se detecto coincidencia en 64");
        end

        if (!prueba_128) begin
            errores = errores + 1;
            $display("ERROR: no se detecto coincidencia en 128");
        end

        if (!prueba_rtc || !prueba_hora) begin
            errores = errores + 1;
        end

        $display("--------------------------------------");

        if (errores == 0) begin
            $display("EXITO: INTEGRACION COMPLETA CORRECTA");
        end
        else begin
            $display("FALLO: %0d ERRORES DETECTADOS", errores);
            $fatal(1, "SIMULACION FALLIDA");
        end

        $display("======================================");

        $finish;
    end

    // Timeout
    initial begin
        #20_000_000;
        $fatal(1, "TIMEOUT: simulacion no finalizada");
    end

endmodule
