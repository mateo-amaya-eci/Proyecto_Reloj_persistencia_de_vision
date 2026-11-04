module control_fase (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire tick_5us,

    output reg phase,
    output reg rise_pulse,
    output reg fall_pulse
);

always @(posedge clk) begin

    if (reset) begin
        phase      <= 1'b0;
        rise_pulse <= 1'b0;
        fall_pulse <= 1'b0;
    end
    else begin

        rise_pulse <= 1'b0;
        fall_pulse <= 1'b0;

        if (!enable) begin
            phase <= 1'b0;
        end

        else if (tick_5us) begin

            if (phase == 1'b0) begin
                phase      <= 1'b1;
                rise_pulse <= 1'b1;
            end

            else begin
                phase      <= 1'b0;
                fall_pulse <= 1'b1;
            end

        end
    end
end

endmodule