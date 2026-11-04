module transmisor_rtc (
    input wire clk,
    input wire reset,

    input wire load_command,
    input wire bit_enable,
    input wire bit_count_enable,
    input wire bit_reset,

    output wire tx_data,
    output wire tx_done
);

    reg [7:0] shift_reg;
    reg load_command_d;

    wire load_pulse;

    assign load_pulse = load_command && !load_command_d;

    assign tx_data = shift_reg[0];


    // REGISTRO DE DESPLAZAMIENTO

    always @(posedge clk) begin

        if (reset) begin
            shift_reg <= 8'h00;
            load_command_d <= 1'b0;
        end

        else begin

            load_command_d <= load_command;

            if (load_pulse) begin
                shift_reg <= 8'hBF;
            end

            else if (bit_enable) begin
                shift_reg <= {1'b0, shift_reg[7:1]};
            end

        end
    end


    // CONTADOR DE BITS

    contador_bits contador (
        .clk(clk),
        .reset(reset),
        .reset_count(bit_reset),
        .bit_enable(bit_count_enable),
        .tx_done(tx_done)
    );

endmodule