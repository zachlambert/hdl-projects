module servo(clk, value, pwm);
    input clk;
    input [7:0] value;
    output reg pwm;

    // 12MHz clock connected to clk
    // PWM signal:
    // - 20ms period = 240,000 pulses
    // - Pulse 0.5ms (0 deg) -> 2.4ms (180 deg)
    //   = 6000 -> 28800 pulses

    // Value is provided from 0 -> 255
    // Corresponds to about 89 pulses per increment

    parameter PERIOD = 240000;

    reg [31:0] count = PERIOD;
    reg [7:0] value_reg = 127;

    wire [31:0] pulse_width;
    assign pulse_width = 6000 + 89 * value_reg;

    always @(posedge clk) begin
        if (count >= PERIOD) begin
            pwm <= 1;
            count <= 0;
            value_reg <= value;
        end
        else begin
            count <= count + 1;
            if (pwm == 1 && count >= pulse_width) begin
                pwm <= 0;
            end
        end
    end

endmodule //servo
