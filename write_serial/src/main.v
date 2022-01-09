module hello_world (clk, tx, led1, led2, debug1);
    input clk;
    output reg tx;
    output led1;
    output reg led2 = 1;
    output debug1;

    wire send_message;
    pulse #(.PERIOD(12000000), .PULSE_WIDTH(600000))
        MESSAGE_PULSE(
        .clk(clk),
        .out(send_message)
    );
    assign led1 = send_message;

    // 12Mhz, 9600 baud rate, 12000000/9600 = 1250
    parameter c_CLKS_PER_BIT = 1250;

    reg [7:0] message [0:14];
    initial $readmemh("message.mem", message, 0);

    reg [7:0] message_index = 0;
    reg [7:0] message_length = 15;

    localparam [2:0]
        s_IDLE = 0,
        s_READY = 1,
        s_WAITING_1 = 2,
        s_WAITING_2 = 3,
        s_WRITING = 4,
        s_STOPPING = 5;
    reg [2:0] write_state = s_IDLE;

    reg r_Tx_DV = 0;
    wire w_Tx_Done;
    reg [7:0] r_Tx_Byte = 0;

    wire tx_out;
    uart_tx #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_TX_INST(
        .i_Clock(clk),
        .i_Tx_DV(r_Tx_DV),
        .i_Tx_Byte(r_Tx_Byte),
        .o_Tx_Active(),
        .o_Tx_Serial(tx_out),
        .o_Tx_Done(w_Tx_Done)
    );
    always @(posedge clk) begin
        tx <= tx_out;
    end

    always @(posedge clk) begin
        case (write_state)
            s_IDLE: begin
                if (send_message) begin
                    write_state <= s_READY;
                end
            end
            s_READY: begin
                if (!send_message) begin
                    write_state <= s_WAITING_1;
                    led2 <= 0;
                    message_index <= 0;
                end
            end
            s_WAITING_1: begin
                write_state <= s_WAITING_2;
            end
            s_WAITING_2: begin
                r_Tx_DV <= 1'b1;
                r_Tx_Byte <= message[message_index];
                write_state <= s_WRITING;
            end
            s_WRITING: begin
                r_Tx_DV <= 1'b0;
                write_state <= s_STOPPING;
            end
            s_STOPPING: begin
                if (w_Tx_Done) begin
                    led2 <= 1;
                    message_index <= message_index + 1;
                    if (message_index < message_length) begin
                        write_state <= s_WAITING_1;
                    end
                    else begin
                        write_state <= s_IDLE;
                    end
                end
            end
        endcase
    end

    assign debug1 = write_state[0];

endmodule //hello_world
