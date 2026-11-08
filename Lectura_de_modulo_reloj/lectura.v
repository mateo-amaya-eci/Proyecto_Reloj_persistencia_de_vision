module rtc_fsm_karnaugh (
    input wire clk,           // Reloj maestro de la FPGA
    input wire rst,           // Señal de reset
    input wire C,             // Señal de fin de conteo de los 8 ciclos
    output reg [2:0] state    // Salida de estado [S2, S1, S0]
);

    reg [2:0] s, ns;

    // 1. Lógica Secuencial: Actualización del estado actual con el flanco de reloj
    always @(posedge clk or posedge rst) begin
        if (rst)
            s <= 3'b000; // Estado inicial S0 (Segundos)
        else
            s <= ns;
    end

    // 2. Lógica Combinacional: Transiciones ordenadas de la FSM
    always @(*) begin
        if (C) begin
            case (s)
                3'b000:  ns = 3'b001; // S0 (Segundos)    -> S1 (Minutos)
                3'b001:  ns = 3'b010; // S1 (Minutos)     -> S2 (Horas)
                3'b010:  ns = 3'b011; // S2 (Horas)       -> S3 (Día Semana)
                3'b011:  ns = 3'b100; // S3 (Día Semana)  -> S4 (Día Mes)
                3'b100:  ns = 3'b101; // S4 (Día Mes)     -> S5 (Mes)
                3'b101:  ns = 3'b110; // S5 (Mes)         -> ACABAR
                3'b110:  ns = 3'b110; // ACABAR           -> Se mantiene estable
                default: ns = 3'b000;
            endcase
        end else begin
            ns = s; // Si C no está activo, la FSM se mantiene en el estado actual
        end
    end

    // 3. Asignación de Salida (Método de Moore)
    always @(*) begin
        state = s;
    end

endmodule



module demux_combinacional (
    input wire [2:0] state,        // Estado actual de la FSM (S0 a S5)
    input wire moduloclock,                  // Señal de fin de conteo
    output wire load_segundos,
    output wire load_minutos,
    output wire load_horas,
    output wire load_dia_semana,
    output wire load_dia_mes,
    output wire load_mes
);

    assign load_segundos    = (state == 3'b000) && moduloclock;
    assign load_minutos     = (state == 3'b001) && moduloclock;
    assign load_horas       = (state == 3'b010) && moduloclock;
    assign load_dia_semana  = (state == 3'b011) && moduloclock;
    assign load_dia_mes     = (state == 3'b100) && moduloclock;
    assign load_mes         = (state == 3'b101) && moduloclock;

endmodule

module rtc_shift_register (
    input wire clk,                  // Reloj de la FPGA
    input wire rst,                  // Reset
    input wire enable_reading,       // Se activa mientras la FSM esté leyendo (no en ACABAR)
    input wire rtc_data_in,          // El bit único serie desde el reloj
    output reg [7:0] byte_out,       // El byte paralelo de 8 bits resultante
    output wire C                    // Señal de fin de conteo (pulso limpio de 1 ciclo al completar 8 bits)
);

    reg [2:0] bit_counter;           // Contador de 0 a 7 (8 bits exactos)
    reg [7:0] shift_reg;
    reg c_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg   <= 8'b00000000;
            bit_counter <= 3'd0;
            c_reg       <= 1'b0;
        end else if (enable_reading) begin
            // Desplaza el bit entrante
            shift_reg <= {shift_reg[6:0], rtc_data_in};

            if (bit_counter == 3'd7) begin
                bit_counter <= 3'd0;     // Reinicia a 0 limpiamente
                c_reg       <= 1'b1;     // Genera el pulso C exacto de 1 ciclo
            end else begin
                bit_counter <= bit_counter + 1'b1;
                c_reg       <= 1'b0;     // Mantiene C en 0
            end
        end else begin
            bit_counter <= 3'd0;
            c_reg       <= 1'b0;
        end
    end

    // Asignación de la señal de fin de conteo
    assign C = c_reg;
    
    // Salida del byte completo en paralelo
    always @(*) begin
        byte_out = shift_reg;
    end

endmodule

module bcd_to_bin (
    input wire [7:0] bcd_in,       
    output wire [5:0] binary_out   // Salida binaria de 6 bits (suficiente para el rango 0 a 59)
);

    wire [3:0] decenas = bcd_in[7:4];
    wire [3:0] unidades = bcd_in[3:0];

    
    assign binary_out = ((decenas << 3) + (decenas << 1)) + unidades;

endmodule


module lectura_datos_module (
    input wire clk,                    // Reloj maestro de la FPGA
    input wire rst,                    // Reset general
    input wire rtc_data_in,            // El bit serial del reloj que va cambiando con el tiempo
    output wire [5:0] segundos_bin,    // Salida final en binario de segundos
    output wire [5:0] minutos_bin,     // Salida final en binario de minutos
    output wire [5:0] horas_bin,       // Salida final en binario de horas
    output wire [5:0] dia_sem_bin,     // Salida final en binario de día de la semana
    output wire [5:0] dia_mes_bin,     // Salida final en binario de día del mes
    output wire [5:0] mes_bin          // Salida final en binario de mes
);

    // 1. CABLES INTERNOS (Para entrelazar los módulos)
    wire [2:0] fsm_state;              // Estado actual proveniente de la FSM
    wire c_signal;                     // Señal de fin de conteo (8 bits listos)
    wire [7:0] byte_serial_out;        // Byte BCD de 8 bits que sale del shift register
    
    // Señales de habilitación de escritura generadas por el demux combinacional
    wire load_seg, load_min, load_hor, load_dsem, load_dmes, load_mes;

    // Registros locales para almacenar los valores BCD de 8 bits de cada parámetro
    reg [7:0] reg_segundos_bcd;
    reg [7:0] reg_minutos_bcd;
    reg [7:0] reg_horas_bcd;
    reg [7:0] reg_dia_sem_bcd;
    reg [7:0] reg_dia_mes_bcd;
    reg [7:0] reg_mes_bcd;

    // Habilitación de lectura: solo cuenta si la FSM no ha llegado al estado ACABAR (3'b110)
    wire enable_reading = (fsm_state != 3'b110);


    // -------------------------------------------------------------
    // 2. INSTANCIA DE LA MÁQUINA DE ESTADOS (FSM de Karnaugh)
    // -------------------------------------------------------------
    rtc_fsm_karnaugh fsm_inst (
        .clk(clk),
        .rst(rst),
        .C(c_signal),
        .state(fsm_state)
    );


    // -------------------------------------------------------------
    // 3. INSTANCIA DEL REGISTRO DE DESPLAZAMIENTO (Captura el bit serial)
    // -------------------------------------------------------------
    rtc_shift_register shift_inst (
        .clk(clk),
        .rst(rst),
        .enable_reading(enable_reading),
        .rtc_data_in(rtc_data_in),       // Aquí entra el bit que cambia con el tiempo
        .byte_out(byte_serial_out),
        .C(c_signal)
    );


    // -------------------------------------------------------------
    // 4. INSTANCIA DEL DEMUX COMBINACIONAL
    // -------------------------------------------------------------
    demux_combinacional demux_inst (
        .state(fsm_state),
        .moduloclock(c_signal),
        .load_segundos(load_seg),
        .load_minutos(load_min),
        .load_horas(load_hor),
        .load_dia_semana(load_dsem),
        .load_dia_mes(load_dmes),
        .load_mes(load_mes)
    );


    // -------------------------------------------------------------
    // 5. REGISTROS LOCALES (Lógica Secuencial para guardar los BCD)
    // -------------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_segundos_bcd <= 8'b0;
            reg_minutos_bcd  <= 8'b0;
            reg_horas_bcd    <= 8'b0;
            reg_dia_sem_bcd  <= 8'b0;
            reg_dia_mes_bcd  <= 8'b0;
            reg_mes_bcd      <= 8'b0;
        end else begin
            // Si el demux activa la señal de carga respectiva, guarda el byte BCD correspondiente
            if (load_seg)  reg_segundos_bcd <= byte_serial_out;
            if (load_min)  reg_minutos_bcd  <= byte_serial_out;
            if (load_hor)  reg_horas_bcd    <= byte_serial_out;
            if (load_dsem) reg_dia_sem_bcd  <= byte_serial_out;
            if (load_dmes) reg_dia_mes_bcd  <= byte_serial_out;
            if (load_mes)  reg_mes_bcd      <= byte_serial_out;
        end
    end


    // -------------------------------------------------------------
    // 6. INSTANCIAS DE LOS CONVERSORES BCD A BINARIO PARA CADA DATO
    // -------------------------------------------------------------
    bcd_to_bin conv_seg (
        .bcd_in(reg_segundos_bcd),
        .binary_out(segundos_bin)
    );

    bcd_to_bin conv_min (
        .bcd_in(reg_minutos_bcd),
        .binary_out(minutos_bin)
    );

    bcd_to_bin conv_hor (
        .bcd_in(reg_horas_bcd),
        .binary_out(horas_bin)
    );

    bcd_to_bin conv_dsem (
        .bcd_in(reg_dia_sem_bcd),
        .binary_out(dia_sem_bin)
    );

    bcd_to_bin conv_dmes (
        .bcd_in(reg_dia_mes_bcd),
        .binary_out(dia_mes_bin)
    );

    bcd_to_bin conv_mes (
        .bcd_in(reg_mes_bcd),
        .binary_out(mes_bin)
    );

endmodule