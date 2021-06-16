`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


module ALU_ctrl(ALUop,clk,ctrl,flag,ctr,sel,x);
input [3:0]ALUop;
input clk;
output reg[2:0]ctrl;
output reg[1:0]ctr,sel,x;
output reg flag;

always @(posedge clk)
begin

     if(ALUop==4'd1)  begin ctrl=3'b000; flag=1'b0; sel=2'dz;x=2'dz;ctr=2'dz;end      //add_lw_sw_auipc
else if(ALUop==4'd2)  begin ctrl=3'b000; flag=1'b1; sel=2'dz;x=2'dz;ctr=2'dz;end      //sub
else if(ALUop==4'd3)  begin ctrl=3'b001; sel=2'd1; flag=1'bz;x=2'dz;ctr=2'dz;end      //or_ori    
else if(ALUop==4'd4)  begin ctrl=3'b001; sel=2'd0; flag=1'bz;x=2'dz;ctr=2'dz;end      //and_andi   
else if(ALUop==4'd5)  begin ctrl=3'b001; sel=2'd2; flag=1'bz;x=2'dz;ctr=2'dz;end      //xor_xori
else if(ALUop==4'd6)  begin ctrl=3'b010; x=2'd0; flag=1'bz;sel=2'dz;ctr=2'dz;end      //sll_slli
else if(ALUop==4'd7)  begin ctrl=3'b010; x=2'd1; flag=1'bz;sel=2'dz;ctr=2'dz;end      //srl_srli
else if(ALUop==4'd8)  begin ctrl=3'b010; x=2'd2; flag=1'bz;sel=2'dz;ctr=2'dz;end      //sra_srai
else if(ALUop==4'd9)  begin ctrl=3'b011; flag=1'bz;sel=2'dz;x=2'dz;ctr=2'dz; end      //slt_slti
else if(ALUop==4'd10) begin ctrl=3'b100; ctr=2'd0; flag=1'bz;sel=2'dz;x=2'dz;end      //beq
else if(ALUop==4'd11) begin ctrl=3'b100; ctr=2'd1; flag=1'bz;sel=2'dz;x=2'dz;end      //bnq
else if(ALUop==4'd12) begin ctrl=3'b100; ctr=2'd2; flag=1'bz;sel=2'dz;x=2'dz;end      //blt
else if(ALUop==4'd13) begin ctrl=3'b100; ctr=2'd3; flag=1'bz;sel=2'dz;x=2'dz;end      //bge
else if(ALUop==4'd14) begin ctrl=4'b101; flag=1'b0; sel=2'dz;x=2'dz;ctr=2'dz;end      //jalr
else                  begin ctrl=3'dz;flag=1'bz;sel=2'dz;x=2'dz;ctr=2'dz;    end  

end
endmodule
