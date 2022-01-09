module pulse
    #(parameter PERIOD = 12000000,
      parameter PULSE_WIDTH = 6000000)
    (
        input clk,
        output reg out = 0
    );

    reg [31:0] count = PERIOD;

    always @(posedge clk) begin
        if (count >= PERIOD) begin
            out <= 1;
            count <= 0;
        end
        else begin
            count <= count + 1;
        end

        if (count >= PULSE_WIDTH && out) begin
            out <= 0;
        end
    end
endmodule //pulse
