`timescale 1ns / 1ps

module tb_rtc_reader;

    // =================================================
    // RELOJ Y RESET
    // =================================================

    reg clk;
    reg reset;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100 MHz
    end

    initial begin
        reset = 1;
        #100;
        reset = 0;
    end

    // =================================================
    // CONEXIONES CON EL RTC_READER
    // =================================================

    wire RTC_CE;
    wire RTC_SCLK;
    tri1 RTC_DAT;

    wire [7:0] seconds;
    wire [7:0] minutes;
    wire [7:0] hours;
    wire [7:0] day;
    wire [7:0] month;
    wire [7:0] weekday;
    wire [7:0] year;

    wire rtc_valid;

    // =================================================
    // INSTANCIA DEL DISEÑO COMPLETO
    // =================================================

    rtc_reader #(
        .CLK_FREQ_HZ(100_000_000),
        .START_DELAY_US(5)
    ) dut (
        .clk(clk),
        .reset(reset),

        .RTC_CE(RTC_CE),
        .RTC_SCLK(RTC_SCLK),
        .RTC_DAT(RTC_DAT),

        .seconds(seconds),
        .minutes(minutes),
        .hours(hours),
        .day(day),
        .month(month),
        .weekday(weekday),
        .year(year),

        .rtc_valid(rtc_valid)
    );

    // =================================================
    // MODELO SIMULADO DEL DS1302
    // =================================================

    reg rtc_drive_en;
    reg rtc_drive;

    assign RTC_DAT = rtc_drive_en ? rtc_drive : 1'bz;

    reg [7:0] command_shift;
    integer command_bits;

    reg read_mode;
    integer data_bit_index;

    // Datos que entregará el RTC:
    // segundos, minutos, horas, día, mes,
    // día de semana, año y byte de control.

    reg [63:0] burst_data;

    initial begin
        rtc_drive_en = 0;
        rtc_drive = 0;

        command_shift = 0;
        command_bits = 0;

        read_mode = 0;
        data_bit_index = 0;

        burst_data = {
            8'h00,  // Control
            8'h26,  // Año: 2026
            8'h03,  // Día de semana
            8'h11,  // Mes: noviembre
            8'h07,  // Día: 7
            8'h12,  // Horas: 12
            8'h34,  // Minutos: 34
            8'h56   // Segundos: 56
        };
    end

    // El DS1302 recibe el comando en flancos positivos.
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

    // El DS1302 entrega los datos en flancos negativos.
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

    // Cuando termina la transacción, libera el bus.
    always @(negedge RTC_CE) begin
        rtc_drive_en <= 0;
    end

    // =================================================
    // VERIFICACIÓN DE RESULTADOS
    // =================================================

    initial begin

        $dumpfile("simulation/rtc_reader.vcd");
        $dumpvars(0, tb_rtc_reader);

        $display("-------------------------------------");
        $display(" INICIO DE SIMULACION RTC_READER");
        $display("-------------------------------------");

        // Esperar a que el diseño termine la lectura.
        wait(rtc_valid == 1'b1);

        #20;

        $display("");
        $display("LECTURA TERMINADA");
        $display("-------------------------------------");

        $display("Segundos       = %h", seconds);
        $display("Minutos        = %h", minutes);
        $display("Horas          = %h", hours);
        $display("Dia            = %h", day);
        $display("Mes            = %h", month);
        $display("Dia semana     = %h", weekday);
        $display("Anio           = %h", year);

        $display("-------------------------------------");

        // Comprobar comando enviado.
        if (command_shift !== 8'hBF)
            $fatal(1, "ERROR: comando enviado incorrectamente");

        // Comprobar registros recibidos.
        if (
            seconds !== 8'h56 ||
            minutes !== 8'h34 ||
            hours   !== 8'h12 ||
            day     !== 8'h07 ||
            month   !== 8'h11 ||
            weekday !== 8'h03 ||
            year    !== 8'h26
        ) begin

            $display("ERROR: los datos recibidos no coinciden");
            $fatal(1);

        end
        else begin

            $display("EXITO: todos los registros son correctos");
            $display("EXITO: comando BF transmitido correctamente");

        end

        $display("-------------------------------------");

        #100;
        $finish;

    end

    // Protección ante una simulación que no termine.
    
    initial begin
        #5_000_000; // 5 ms
        $fatal(1, "TIMEOUT: el RTC no completo la lectura");
    end

endmodule


