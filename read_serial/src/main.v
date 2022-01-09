module read_number (clk, rx, led1, led2, debug1);
    input clk;
    input rx;
    output led1;
    output led2;
    output debug1;

    reg valid = 1;

    parameter c_CLKS_PER_BIT = 1250;

    wire w_Rx_DV;
    wire [7:0] w_Rx_Byte;
    uart_rx #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_RX_INST(
        .i_Clock(clk),
        .i_Rx_Serial(rx),
        .o_Rx_DV(w_Rx_DV),
        .o_Rx_Byte(w_Rx_Byte)
    );

    reg [7:0] byte_index = 0;
    reg [31:0] received_int;
    always @(posedge w_Rx_DV) begin
        case (byte_index)
            0: begin
                valid <= 0;
                received_int[7:0] <= w_Rx_Byte;
                byte_index <= 1;
            end
            1: begin
                received_int[15:8] <= w_Rx_Byte;
                byte_index <= 2;
            end
            2: begin
                received_int[23:16] <= w_Rx_Byte;
                byte_index <= 3;
            end
            3: begin
                received_int[31:24] <= w_Rx_Byte;
                byte_index <= 0;
                valid <= 1;
            end
        endcase
    end

    assign led1 = !received_int[0];
    assign led2 = !received_int[1];
    assign debug1 = valid;

endmodule //read_number
