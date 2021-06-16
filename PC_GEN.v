module PC_GEN(pc_out,clock,i_pc,imm_j,imm_b,pc_src,jlr,jt,bt);
input [31:0]jlr,imm_j,imm_b;
input jt,bt,clock,pc_src,i_pc;
output reg[31:0]pc_out;

wire [31:0]i1,i2,i3,pc,out;

assign i1=bt?imm_b:32'd1;
assign i2=pc_src?imm_j:i1;
assign pc=i_pc?32'b0:pc_out;
//assign pc=pc_out;
addition m1(pc,i2,i3);
assign out=jt?jlr:i3;

always @(posedge clock)
begin
pc_out<=out;
end
endmodule

module addition(a,b,res);

input [31:0]a,b;
output [31:0]res;

wire c1,c2,c3;
wire [31:16]out1,out2;
wire [32:0]out;

adder A1(1'b0,a[15:0],b[15:0],out[15:0],c1);

adder A2(1'b0,a[31:16],b[31:16],out1[31:16],c2);

adder A3(1'b1,a[31:16],b[31:16],out2[31:16],c3);

assign out[32:16]=c1?{c3,out2[31:16]}:{c2,out1[31:16]};
assign res = out;

endmodule
