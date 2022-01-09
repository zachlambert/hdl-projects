module read_number (clk, rx, servo_0_pwm, servo_1_pwm, servo_2_pwm);
    input clk, rx;
    output servo_0_pwm, servo_1_pwm, servo_2_pwm;
    wire servo_0_actual, servo_1_actual, servo_2_actual;
    assign servo_0_pwm = !servo_0_actual;
    assign servo_1_pwm = !servo_1_actual;
    assign servo_2_pwm = !servo_2_actual;

    parameter c_CLKS_PER_BIT = 1250;
    wire w_Rx_DV;
    wire [7:0] w_Rx_Byte;
    uart_rx #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_RX_INST(
        .i_Clock(clk),
        .i_Rx_Serial(rx),
        .o_Rx_DV(w_Rx_DV),
        .o_Rx_Byte(w_Rx_Byte)
    );

    localparam [1:0]
        s_SELECT = 0,
        s_SERVO_0 = 1,
        s_SERVO_1 = 2,
        s_SERVO_2 = 3;
    reg [1:0] state = s_SELECT;

    reg [7:0] servo_0_value = 127;
    reg [7:0] servo_1_value = 127;
    reg [7:0] servo_2_value = 127;

    always @(posedge w_Rx_DV) begin
        case (state)
            s_SELECT: begin
                case (w_Rx_Byte)
                    0: state <= s_SERVO_0;
                    1: state <= s_SERVO_1;
                    2: state <= s_SERVO_2;
                    default: state <= s_SELECT; // Invalid value
                endcase
            end
            s_SERVO_0: begin
                servo_0_value <= w_Rx_Byte;
                state <= s_SELECT;
            end
            s_SERVO_1: begin
                servo_1_value <= w_Rx_Byte;
                state <= s_SELECT;
            end
            s_SERVO_2: begin
                servo_2_value <= w_Rx_Byte;
                state <= s_SELECT;
            end
        endcase
    end

    servo SERVO_0 (
        .clk(clk),
        .value(servo_0_value),
        .pwm(servo_0_actual)
    );
    servo SERVO_1 (
        .clk(clk),
        .value(servo_1_value),
        .pwm(servo_1_actual)
    );
    servo SERVO_2 (
        .clk(clk),
        .value(servo_2_value),
        .pwm(servo_2_actual)
    );
endmodule //read_number
