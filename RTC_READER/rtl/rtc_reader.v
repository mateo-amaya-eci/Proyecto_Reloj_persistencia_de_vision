module rtc_reader #(
    parameter integer CLK_FREQ_HZ = 100_000_000,
    parameter integer START_DELAY_US = 5
)(
    input wire clk,
    input wire reset,

    output wire RTC_CE,
    output wire RTC_SCLK,
    inout wire RTC_DAT,

    output wire [7:0] seconds,
    output wire [7:0] minutes,
    output wire [7:0] hours,
    output wire [7:0] day,
    output wire [7:0] month,
    output wire [7:0] weekday,
    output wire [7:0] year,

    output reg rtc_valid,
    output reg [7:0] debug_first_byte
);

    // =================================================
    // 1. SEÑALES INTERNAS
    // =================================================

    wire enable_clk;
    wire tx_oe;
    wire load_command;
    wire rise_pulse;
    wire bit_count_enable;
    wire bit_enable;
    wire byte_enable;
    wire capture_enable;

    wire bit_reset;
    wire byte_reset;
    wire byte_load;

    wire fall_pulse;

    wire tx_data;
    wire tx_done;

    wire [7:0] rx_byte;
    wire byte_complete;

    wire [2:0] byte_count;
    wire rx_done;

    wire start_done;

    wire dat_in;

    // =================================================
    // 2. BUS BIDIRECCIONAL DEL DS1302
    // =================================================

    assign RTC_DAT = tx_oe ? tx_data : 1'bz;

    assign dat_in = RTC_DAT;

    // =================================================
    // 3. TEMPORIZADOR DE INICIO
    // =================================================

    localparam integer START_DELAY_CYCLES =
        (CLK_FREQ_HZ / 1_000_000) * START_DELAY_US;

    reg [31:0] start_count;
    reg start_armed;
    reg start_done_reg;

    assign start_done = start_done_reg;

    always @(posedge clk) begin
        if (reset) begin
            start_count <= 0;
            start_armed <= 0;
            start_done_reg <= 0;
        end
        else begin
            start_done_reg <= 0;

            if (!RTC_CE) begin
                start_count <= 0;
                start_armed <= 0;
            end
            else if (!enable_clk && !start_armed) begin
                if (start_count >= START_DELAY_CYCLES - 1) begin
                    start_count <= 0;
                    start_armed <= 1;
                    start_done_reg <= 1;
                end
                else begin
                    start_count <= start_count + 1'b1;
                end
            end
        end
    end

    // =================================================
    // 4. GENERADOR DE RELOJ SCLK
    // =================================================

    generador_clk #(
        .CLK_FREQ_HZ(CLK_FREQ_HZ)
    ) generador (
        .rise_pulse(rise_pulse),
        .clk(clk),
        .reset(reset),
        .enable_clk(enable_clk),
        .rtc_sclk(RTC_SCLK),
        .fall_pulse(fall_pulse)
    );

    // =================================================
    // 5. TRANSMISOR DEL COMANDO 8'hBF
    // =================================================

    transmisor_rtc transmisor (
        .clk(clk),
        .bit_count_enable(bit_count_enable),
        .reset(reset),
        .load_command(load_command),
        .bit_enable(bit_enable),
        .bit_reset(bit_reset),
        .tx_data(tx_data),
        .tx_done(tx_done)
    );

    // =================================================
    // 6. RECEPTOR DE DATOS
    // =================================================

    receptor_sipo receptor (
        .clk(clk),
        .reset(reset),
        .capture_enable(capture_enable),
        .dat_in(dat_in),
        .rx_byte(rx_byte),
        .byte_complete(byte_complete)
    );

    // =================================================
    // 7. CONTADOR DE BYTES
    // =================================================

    contador_bytes contador_bytes_inst (
        .clk(clk),
        .reset(reset),
        .reset_count(byte_reset),
        .byte_enable(byte_enable),
        .byte_count(byte_count),
        .rx_done(rx_done)
    );

    // =================================================
    // 8. BANCO DE REGISTROS
    // =================================================

    banco_registros_rtc registros (
        .clk(clk),
        .reset(reset),
        .byte_load(byte_load),
        .byte_count(byte_count),
        .rx_byte(rx_byte),

        .seconds(seconds),
        .minutes(minutes),
        .hours(hours),
        .day(day),
        .month(month),
        .weekday(weekday),
        .year(year)
    );

    // =================================================
    // 9. CONTROLADOR PRINCIPAL
    // =================================================

    controlador_rtc controlador (
        .clk(clk),
        .reset(reset),

        .start_done(start_done),
        .tx_done(tx_done),
        .rx_done(rx_done),

        .fall_pulse(fall_pulse),
        .byte_complete(byte_complete),
        .byte_count(byte_count),
        .rise_pulse(rise_pulse),
        .bit_count_enable(bit_count_enable),
        .CE(RTC_CE),
        .enable_clk(enable_clk),
        .tx_oe(tx_oe),
        .load_command(load_command),

        .bit_enable(bit_enable),
        .byte_enable(byte_enable),
        .capture_enable(capture_enable),

        .bit_reset(bit_reset),
        .byte_reset(byte_reset),
        .byte_load(byte_load)
    );

    // =================================================
    // 10. INDICADOR DE LECTURA COMPLETA
    // =================================================

    always @(posedge clk) begin
    if (reset) begin
        debug_first_byte <= 8'h00;
    end
    else if (byte_complete && byte_count == 3'd0) begin
        debug_first_byte <= rx_byte;
    end
end
always @(posedge clk) begin
    if (reset)
        rtc_valid <= 1'b0;
    else if (rx_done)
        rtc_valid <= 1'b1;
end

endmodule