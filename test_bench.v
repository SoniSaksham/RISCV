`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module test_bench();
reg clk,rst,enable ;
reg [31:0]pc_add;
wire [4:0]count;

integer i;

seq_det m1(clk,pc_add,count,rst,enable);

initial 
begin
clk=1'b0;
forever #5 clk=~clk;
end

initial
begin
////////////// iteration-1 ////////////////
begin pc_add=32'd14; rst=1'b0; end
begin #50 pc_add=32'd9; rst =1'b1; enable=1'b0; end
begin #50 pc_add=32'd20; enable=1'b1; end

///////////// repeated iteration //////////
for(i=0;i<28;i=i+1)
begin
begin #50 pc_add=32'd17; enable=1'b0; end
begin #50 pc_add=32'd27; enable=1'b0; end
begin #50 pc_add=32'd20; enable=1'b1; end
begin #50 pc_add=32'd0; enable=1'b0; end
end

end 
endmodule
