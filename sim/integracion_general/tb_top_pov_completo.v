`timescale 1ns / 1ps

module tb_top_pov_completo;

    reg clk = 1'b0;
    reg reset = 1'b1;
    reg sensor_eh = 1'b0;

    wire RTC_CE;
    wire RTC_SCLK;
    tri1 RTC_DAT;

    wire [9:0] led_r;
    wire [9:0] led_g;
    wire [9:0] led_b;
    wire [3:0] led_caratula;

    // Senales internas observadas exclusivamente por el testbench.
    // No forman parte de los puertos fisicos del top.
    wire rtc_valid_out;
    wire [7:0] angulo;
    wire [7:0] angulo_hor;
    wire [7:0] angulo_min;
    wire [7:0] angulo_seg;
    wire match_hor;
    wire match_min;
    wire match_seg;
    wire [4:0] led_calendario;

    assign rtc_valid_out = dut.rtc_valid;
    assign angulo = dut.angulo;
    assign angulo_hor = dut.angulo_hor;
    assign angulo_min = dut.angulo_min;
    assign angulo_seg = dut.angulo_seg;
    assign match_hor = dut.match_hor;
    assign match_min = dut.match_min;
    assign match_seg = dut.match_seg;
    assign led_calendario = dut.led_calendario;

    integer errores = 0;

    reg prueba_rtc = 1'b0;
    reg prueba_hor_min = 1'b0;
    reg prueba_seg = 1'b0;
    reg prueba_cal_semana = 1'b0;
    reg prueba_cal_dia = 1'b0;
    reg prueba_cal_mes = 1'b0;
    reg prueba_cal_ano = 1'b0;
    reg prueba_sin_calendario = 1'b0;

    // Reloj de simulacion equivalente a 27 MHz.
    // Periodo aproximado: 37.037 ns.
    always #18.5185 clk = ~clk;

    // =========================================================
    // DUT
    // =========================================================

    top_pov_completo #(
        .CLK_FREQ_HZ(27_000_000),
        .START_DELAY_US(5)
    ) dut (
        .clk(clk),
        .reset(reset),
        .sensor_eh(sensor_eh),

        .RTC_CE(RTC_CE),
        .RTC_SCLK(RTC_SCLK),
        .RTC_DAT(RTC_DAT),

        .led_r(led_r),
        .led_g(led_g),
        .led_b(led_b),
        .led_caratula(led_caratula)
    );

    // =========================================================
    // MODELO SERIAL DEL DS1302
    // Se conserva el comportamiento del testbench RTC existente.
    // =========================================================

    reg rtc_drive_en = 1'b0;
    reg rtc_drive = 1'b0;

    assign RTC_DAT = rtc_drive_en ? rtc_drive : 1'bz;

    reg [7:0] command_shift = 8'h00;
    integer command_bits = 0;

    reg read_mode = 1'b0;
    integer data_bit_index = 0;

    reg [63:0] burst_data;

    initial begin
        // Orden de bytes recibido por el lector:
        // segundos, minutos, horas, dia, mes, dia_semana, año, control.
        burst_data = {
            8'h00,  // Control
            8'h26,  // Año: 2026
            8'h03,  // Dia de semana
            8'h11,  // Mes: noviembre
            8'h07,  // Dia
            8'h03,  // Horas: 03
            8'h15,  // Minutos: 15
            8'h30   // Segundos: 30
        };
    end

    // Recepcion del comando enviado por el FPGA.
    always @(posedge RTC_SCLK) begin
        if (RTC_CE && !read_mode) begin
            command_shift <= {RTC_DAT, command_shift[7:1]};
            command_bits <= command_bits + 1;

            if (command_bits == 7) begin
                read_mode <= 1'b1;
                data_bit_index <= 0;
            end
        end
    end

    // Transmision serial de los 8 bytes del DS1302.
    always @(negedge RTC_SCLK) begin
        if (RTC_CE && read_mode) begin
            if (data_bit_index < 64) begin
                rtc_drive_en <= 1'b1;
                rtc_drive <= burst_data[data_bit_index];
                data_bit_index <= data_bit_index + 1;
            end
            else begin
                rtc_drive_en <= 1'b0;
            end
        end
    end

    always @(negedge RTC_CE) begin
        rtc_drive_en <= 1'b0;
    end

    // =========================================================
    // MODELO DEL SENSOR HALL
    // =========================================================

    task pulso_hall;
    begin
        sensor_eh = 1'b1;
        repeat (4) @(negedge clk);
        sensor_eh = 1'b0;
    end
    endtask

    // =========================================================
    // COMPROBACIONES CONTINUAS DE LA UNION RGB + CALENDARIO
    // =========================================================

    always @(negedge clk) begin
        if (!reset) begin
            if (led_r[4:0] !== (dut.manecilla_r[4:0] | led_calendario)) begin
                $display("ERROR: OR incorrecto en canal rojo, angulo=%0d", angulo);
                errores = errores + 1;
            end

            if (led_g[4:0] !== (dut.manecilla_g[4:0] | led_calendario)) begin
                $display("ERROR: OR incorrecto en canal verde, angulo=%0d", angulo);
                errores = errores + 1;
            end

            if (led_b[4:0] !== (dut.manecilla_b[4:0] | led_calendario)) begin
                $display("ERROR: OR incorrecto en canal azul, angulo=%0d", angulo);
                errores = errores + 1;
            end

            if (led_r[9:5] !== dut.manecilla_r[9:5] ||
                led_g[9:5] !== dut.manecilla_g[9:5] ||
                led_b[9:5] !== dut.manecilla_b[9:5]) begin
                $display("ERROR: los 5 bits superiores RGB fueron alterados");
                errores = errores + 1;
            end

            // Posicion de las manecillas: 03:15:30
            if (angulo == 8'd64) begin
                if (match_hor && match_min && !match_seg) begin
                    prueba_hor_min = 1'b1;
                end
            end

            if (angulo == 8'd128) begin
                if (match_seg && !match_hor && !match_min) begin
                    prueba_seg = 1'b1;
                end
            end

            // El calendario ocupa las regiones angulares 85 a 170.
            if (angulo == 8'd85 && led_calendario != 5'b00000)
                prueba_cal_semana = 1'b1;

            if (angulo == 8'd107 && led_calendario != 5'b00000)
                prueba_cal_dia = 1'b1;

            if (angulo == 8'd128 && led_calendario != 5'b00000)
                prueba_cal_mes = 1'b1;

            if (angulo == 8'd149 && led_calendario != 5'b00000)
                prueba_cal_ano = 1'b1;

            // Fuera de la region del calendario, su salida debe ser cero.
            if (angulo == 8'd200) begin
                if (led_calendario == 5'b00000 &&
                    led_r == 10'b0000000000 &&
                    led_g == 10'b0000000000 &&
                    led_b == 10'b0000000000 &&
                    led_caratula == 4'b1000) begin
                    prueba_sin_calendario = 1'b1;
                end
            end
        end
    end

    // =========================================================
    // SECUENCIA PRINCIPAL
    // =========================================================

    initial begin
        $dumpfile("top_pov_completo.vcd");
        $dumpvars(0, tb_top_pov_completo);

        $display("==============================================");
        $display(" INICIO: SIMULACION TOP POV COMPLETO - 27 MHz");
        $display("==============================================");

        // Liberar reset.
        repeat (5) @(negedge clk);
        reset = 1'b0;

        // Esperar la lectura serial completa del DS1302.
        wait (rtc_valid_out === 1'b1);
        repeat (5) @(negedge clk);

        $display("\n========== VERIFICACION DEL RTC ==========");
        $display("Segundos BCD: %h", dut.rtc_seconds);
        $display("Minutos BCD : %h", dut.rtc_minutes);
        $display("Horas BCD   : %h", dut.rtc_hours);
        $display("Dia BCD     : %h", dut.rtc_day);
        $display("Mes BCD     : %h", dut.rtc_month);
        $display("Semana BCD  : %h", dut.rtc_weekday);
        $display("Año BCD     : %h", dut.rtc_year);
        $display("Comando     : %h", command_shift);

        if (dut.rtc_seconds === 8'h30 &&
            dut.rtc_minutes === 8'h15 &&
            dut.rtc_hours   === 8'h03 &&
            dut.rtc_day     === 8'h07 &&
            dut.rtc_month   === 8'h11 &&
            dut.rtc_weekday === 8'h03 &&
            dut.rtc_year    === 8'h26 &&
            command_shift   === 8'hBF) begin
            prueba_rtc = 1'b1;
            $display("RTC DS1302: CORRECTO");
        end
        else begin
            errores = errores + 1;
            $display("ERROR: datos recibidos del DS1302 incorrectos");
        end

        // Comprobar que el reloj cargo los datos iniciales.
        if (dut.segundos === 6'd30 &&
            dut.minutos === 6'd15 &&
            dut.horas_visualizacion === 5'd3 &&
            dut.dia === 5'd7 &&
            dut.mes === 4'd11 &&
            dut.anio === 7'd26) begin
            $display("Carga inicial del reloj y calendario: CORRECTA");
        end
        else begin
            errores = errores + 1;
            $display("ERROR: carga inicial del reloj/calendario");
        end

        // Primera vuelta: establece la referencia del sensor Hall.
        pulso_hall();

        // Periodo aproximado de una vuelta: 5120 ciclos.
        repeat (5116) @(negedge clk);

        // Segunda vuelta: permite medir el periodo y habilitar el angulo.
        pulso_hall();

        // Recorrer las posiciones hasta superar la region del calendario.
        repeat (4500) @(negedge clk);

        $display("\n========== RESULTADOS ==========");
        $display("RTC recibido                 : %b", prueba_rtc);
        $display("Coincidencia hora/minuto 64  : %b", prueba_hor_min);
        $display("Coincidencia segundos 128   : %b", prueba_seg);
        $display("Calendario semana (85)      : %b", prueba_cal_semana);
        $display("Calendario dia (107)        : %b", prueba_cal_dia);
        $display("Calendario mes (128)        : %b", prueba_cal_mes);
        $display("Calendario año (149)        : %b", prueba_cal_ano);
        $display("RGB sin calendario (200)    : %b", prueba_sin_calendario);
        $display("Angulos de manecillas H/M/S : %0d / %0d / %0d",
                 angulo_hor, angulo_min, angulo_seg);
        $display("Angulo actual               : %0d", angulo);
        $display("Errores de conexion OR      : %0d", errores);

        if (prueba_rtc &&
            prueba_hor_min &&
            prueba_seg &&
            prueba_cal_semana &&
            prueba_cal_dia &&
            prueba_cal_mes &&
            prueba_cal_ano &&
            prueba_sin_calendario &&
            errores == 0) begin
            $display("\nEXITO: TOP POV COMPLETO INTEGRADO CORRECTAMENTE");
        end
        else begin
            $display("\nFALLO: LA INTEGRACION NO SUPERO TODAS LAS PRUEBAS");
            $fatal(1, "SIMULACION FALLIDA");
        end

        $display("==============================================");
        $finish;
    end

    // Timeout de seguridad.
    initial begin
        #20_000_000;
        $fatal(1, "TIMEOUT: no finalizo la simulacion");
    end

endmodule
