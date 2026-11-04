module controlador_rtc (

    input wire clk,
    input wire reset,

    input wire start_done,
    input wire tx_done,
    input wire rx_done,

    input wire rise_pulse,
    input wire fall_pulse,
    input wire byte_complete,
    input wire [2:0] byte_count,

    output reg CE,
    output reg enable_clk,
    output reg tx_oe,
    output reg load_command,

    output wire bit_enable,
    output wire bit_count_enable,
    output wire byte_enable,
    output wire capture_enable,
    output wire bit_reset,
    output wire byte_reset,
    output wire byte_load
);

localparam IDLE     = 3'b000,
           START    = 3'b001,
           TRANSMIT = 3'b010,
           RECEIVE  = 3'b011,
           FINISH   = 3'b100,
           DONE     = 3'b101;

reg [2:0] state;
reg [2:0] next_state;


// REGISTRO DE ESTADO

always @(posedge clk) begin
    if (reset)
        state <= IDLE;
    else
        state <= next_state;
end


// TRANSICIONES

always @(*) begin

    next_state = state;

    case (state)

        IDLE:
            next_state = START;

        START:
            if (start_done)
                next_state = TRANSMIT;

        TRANSMIT:
            if (tx_done)
                next_state = RECEIVE;

        RECEIVE:
            if (rx_done)
                next_state = FINISH;

        FINISH:
            next_state = DONE;

        DONE:
            next_state = DONE;

        default:
            next_state = IDLE;

    endcase
end


// SALIDAS DE LA FSM

always @(*) begin

    CE           = 1'b0;
    enable_clk   = 1'b0;
    tx_oe        = 1'b0;
    load_command = 1'b0;

    case (state)

        IDLE: begin
            CE           = 1'b0;
            enable_clk   = 1'b0;
            tx_oe        = 1'b0;
            load_command = 1'b0;
        end

        START: begin
            CE           = 1'b1;
            enable_clk   = 1'b0;
            tx_oe        = 1'b1;
            load_command = 1'b1;
        end

        TRANSMIT: begin
            CE           = 1'b1;
            enable_clk   = 1'b1;
            tx_oe        = 1'b1;
            load_command = 1'b0;
        end

        RECEIVE: begin
            CE           = 1'b1;
            enable_clk   = 1'b1;
            tx_oe        = 1'b0;
            load_command = 1'b0;
        end

        FINISH, DONE: begin
            CE           = 1'b0;
            enable_clk   = 1'b0;
            tx_oe        = 1'b0;
            load_command = 1'b0;
        end

        default: begin
            CE           = 1'b0;
            enable_clk   = 1'b0;
            tx_oe        = 1'b0;
            load_command = 1'b0;
        end

    endcase
end


// CONTROL DE TRANSMISION Y RECEPCION

assign bit_enable =
       fall_pulse && (state == TRANSMIT);

assign bit_count_enable =
       rise_pulse && (state == TRANSMIT);

assign byte_enable =
       byte_complete && (state == RECEIVE);

assign capture_enable =
       fall_pulse && (state == RECEIVE);

assign bit_reset =
       (state != TRANSMIT);

assign byte_reset =
       (state != RECEIVE);

assign byte_load =
       byte_complete &&
       (state == RECEIVE) &&
       (byte_count != 3'd7);

endmodule