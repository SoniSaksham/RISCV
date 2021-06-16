`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module testbench_RICS_V();
reg clk,restart;

top_module m1(clk,restart);

initial 
begin
clk=1'b1;
forever #50 clk=~clk;
end

initial
begin
restart=1'b1; 
forever #5000 restart=~restart;
end

endmodule
