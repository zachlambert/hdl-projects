module blink(clk, out, current_pos);
    input clk;
    reg out_actual;
    output out;
    output current_pos;

    // 12MHz clock connected to clk
    // PWM signal:
    // - 20ms period = 240,000 pulses
    // - Pulse 0.5ms (0 deg) -> 2.4ms (180 deg)
    //   = 6000 -> 28800 pulses

    reg [31:0] count = 240000;

    reg [31:0] pulse_width_0 = 6000;
    reg [31:0] pulse_width_1 = 29400; // Bit closer to 180deg
    wire [31:0] pulse_width;
    reg pulse_width_sel = 0;
    reg [31:0] pos_change_count = 0;

    always @(posedge clk) begin
        if (count >= 240000) begin
            out_actual <= 1;
            count <= 0;
            if (pos_change_count >= 50) begin
                pulse_width_sel <= !pulse_width_sel;
                // if (pulse_width_sel == 1'b1) begin
                //     pulse_width <= 24000;
                // end
                // else begin
                //     pulse_width <= 12000;
                // end
                pos_change_count <= 0;
            end
            else begin
                pos_change_count <= pos_change_count + 1;
            end
        end
        else begin
            count <= count + 1;
            if (out_actual == 1 && count >= pulse_width) begin
                out_actual <= 0;
            end
        end
    end

    assign current_pos = pulse_width_sel;
    assign pulse_width = pulse_width_sel ? pulse_width_1 : pulse_width_0;
    assign out = !out_actual;

endmodule //blink
