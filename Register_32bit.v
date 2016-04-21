`timescale 1ns / 1ps

module Register_32bit(out,in,enable,reset,clk);

parameter   DATA_WIDTH = 32; // default

input   [DATA_WIDTH-1:0] in;
input    enable, reset, clk;

output reg [DATA_WIDTH-1:0] out;

always @(posedge clk) begin

    if (reset) begin
        out = 0;
    end else begin
        if (enable) begin
            out = in;
        end
    end
end

endmodule
