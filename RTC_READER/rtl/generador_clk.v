
module generador_clk #(
    parameter integer CLK_FREQ_HZ = 100_000_000
)(
    input wire clk,
    input wire reset,
    input wire enable_clk,

    output wire rtc_sclk,
    output wire rise_pulse,
    output wire fall_pulse
);

    wire tick_20us;

    contador_divisor #(
        .CLK_FREQ_HZ(CLK_FREQ_HZ)
    ) divisor (
        .clk(clk),
        .reset(reset),
        .tick_20us(tick_20us)
    );

    control_fase fase (
        .clk(clk),
        .reset(reset),
        .enable(enable_clk),
        .tick_20us(tick_20us),
        .phase(rtc_sclk),
        .rise_pulse(rise_pulse),
        .fall_pulse(fall_pulse)
    );

endmodule
