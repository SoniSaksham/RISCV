`timescale 1ns / 1ps


module reg_file(instr,wr_data,reg_wr,reg_rd,clk,rd1,rd2);
input [31:0]instr,wr_data;
input reg_wr,reg_rd,clk;
output reg[31:0]rd1,rd2;
reg [31:0]R[0:31];
reg [4:0]rs1,rs2,rd;

always@(negedge clk)
begin
rd =instr[11:7];

if(reg_wr)
begin
case(rd)
5'd0: R[0]=wr_data; 5'd8: R[8]=wr_data;  5'd16: R[16]=wr_data; 5'd24: R[24]=wr_data;
5'd1: R[1]=wr_data; 5'd9: R[9]=wr_data;  5'd17: R[17]=wr_data; 5'd25: R[25]=wr_data;
5'd2: R[2]=wr_data; 5'd10:R[10]=wr_data; 5'd18: R[18]=wr_data; 5'd26: R[26]=wr_data;
5'd3: R[3]=wr_data; 5'd11:R[11]=wr_data; 5'd19: R[19]=wr_data; 5'd27: R[27]=wr_data;
5'd4: R[4]=wr_data; 5'd12:R[12]=wr_data; 5'd20: R[20]=wr_data; 5'd28: R[28]=wr_data;
5'd5: R[5]=wr_data; 5'd13:R[13]=wr_data; 5'd21: R[21]=wr_data; 5'd29: R[29]=wr_data;
5'd6: R[6]=wr_data; 5'd14:R[14]=wr_data; 5'd22: R[22]=wr_data; 5'd30: R[30]=wr_data;
5'd7: R[7]=wr_data; 5'd15:R[15]=wr_data; 5'd23: R[23]=wr_data; 5'd31: R[31]=wr_data;
endcase
end
end

always@(posedge clk)
begin
rs1=instr[19:15]; rs2=instr[24:20];

if(reg_rd)
begin

case(rs1)
5'd0: rd1=R[0]; 5'd8: rd1=R[8];  5'd16: rd1=R[16]; 5'd24: rd1=R[24];
5'd1: rd1=R[1]; 5'd9: rd1=R[9];  5'd17: rd1=R[17]; 5'd25: rd1=R[25];
5'd2: rd1=R[2]; 5'd10:rd1=R[10]; 5'd18: rd1=R[18]; 5'd26: rd1=R[26];
5'd3: rd1=R[3]; 5'd11:rd1=R[11]; 5'd19: rd1=R[19]; 5'd27: rd1=R[27];
5'd4: rd1=R[4]; 5'd12:rd1=R[12]; 5'd20: rd1=R[20]; 5'd28: rd1=R[28];
5'd5: rd1=R[5]; 5'd13:rd1=R[13]; 5'd21: rd1=R[21]; 5'd29: rd1=R[29];
5'd6: rd1=R[6]; 5'd14:rd1=R[14]; 5'd22: rd1=R[22]; 5'd30: rd1=R[30];
5'd7: rd1=R[7]; 5'd15:rd1=R[15]; 5'd23: rd1=R[23]; 5'd31: rd1=R[31];
endcase

case(rs2)
5'd0: rd2=R[0]; 5'd8: rd2=R[8];  5'd16: rd2=R[16]; 5'd24: rd2=R[24];
5'd1: rd2=R[1]; 5'd9: rd2=R[9];  5'd17: rd2=R[17]; 5'd25: rd2=R[25];
5'd2: rd2=R[2]; 5'd10:rd2=R[10]; 5'd18: rd2=R[18]; 5'd26: rd2=R[26];
5'd3: rd2=R[3]; 5'd11:rd2=R[11]; 5'd19: rd2=R[19]; 5'd27: rd2=R[27];
5'd4: rd2=R[4]; 5'd12:rd2=R[12]; 5'd20: rd2=R[20]; 5'd28: rd2=R[28];
5'd5: rd2=R[5]; 5'd13:rd2=R[13]; 5'd21: rd2=R[21]; 5'd29: rd2=R[29];
5'd6: rd2=R[6]; 5'd14:rd2=R[14]; 5'd22: rd2=R[22]; 5'd30: rd2=R[30];
5'd7: rd2=R[7]; 5'd15:rd2=R[15]; 5'd23: rd2=R[23]; 5'd31: rd2=R[31];
endcase

end
end

initial
begin
R[1]=32'h00000007;
R[2]=32'h0000000a;
end

endmodule