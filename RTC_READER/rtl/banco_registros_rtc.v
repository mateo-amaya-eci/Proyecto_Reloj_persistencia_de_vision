
// ============================================================
// 5. BANCO DE REGISTROS PIPO
// Almacena los 7 bytes útiles del RTC.
// ============================================================

module banco_registros_rtc (
    input wire clk,
    input wire reset,
    input wire byte_load,

    input wire [2:0] byte_count,
    input wire [7:0] rx_byte,

    output reg [7:0] seconds,
    output reg [7:0] minutes,
    output reg [7:0] hours,
    output reg [7:0] day,
    output reg [7:0] month,
    output reg [7:0] weekday,
    output reg [7:0] year
);

always @(posedge clk) begin

    if (reset) begin
        seconds <= 8'd0;
        minutes <= 8'd0;
        hours   <= 8'd0;
        day     <= 8'd0;
        month   <= 8'd0;
        weekday <= 8'd0;
        year    <= 8'd0;
    end

    else if (byte_load) begin

        case (byte_count)

            3'd0: seconds <= rx_byte;
            3'd1: minutes <= rx_byte;
            3'd2: hours   <= rx_byte;
            3'd3: day     <= rx_byte;
            3'd4: month   <= rx_byte;
            3'd5: weekday <= rx_byte;
            3'd6: year    <= rx_byte;

            // Byte 7: registro de control, se descarta.

            default: begin
            end

        endcase
    end
end

endmodule
