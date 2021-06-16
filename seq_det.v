`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

module seq_det(CLK,PC_ADD,COUNT,RST,EN);

input CLK,RST,EN;
input [31:0]PC_ADD;
output [4:0]COUNT;

wire [31:0]INSTR,DATA_OUT,RD1,RD2,IMM_i,IMM_u,IMM_s,IMM_b,IMM_j,SHMT_i,DATA_IN,WR_DATA;
wire [31:0]RESULT,JLR,A,B,PC_plus_4,PC_plus_IMM_u,REG_INPUT;
wire [3:0]ALUop;
wire [2:0]CTRL;
wire [1:0]CTR,SEL,X,ALU_src,MEM_ALU;
wire FLAG,MEM_EN,WR_RD,REG_WR,REG_RD,PC_R,ALU_DT;
wire  BT,PC_SRC,JT,I_PC;
wire  [31:0]PC_OUT;

PC_GEN      M1(PC_OUT,CLK,I_PC,IMM_j,IMM_b,PC_SRC,JLR,JT,BT);//(pc_out,clock,i_pc,imm_j,imm_b,pc_src,jlr,jt,bt);

memory      M2(PC_ADD,RD2,RESULT,PC_R,CLK,MEM_EN,WR_RD,INSTR,DATA_OUT); 
assign      WR_DATA=ALU_DT?DATA_OUT:REG_INPUT;

reg_file    M4(INSTR,WR_DATA,REG_WR,REG_RD,CLK,RD1,RD2);
assign      A=RD1;
assign      B=ALU_src[1]?(ALU_src[0]?SHMT_i:IMM_s):(ALU_src[0]?IMM_i:RD2);

ALU         M7(A,B,CLK,CTRL,FLAG,SEL,X,CTR,BT,JLR,RESULT,COUNT,RST,EN);

addition    M8(PC_OUT,32'd1,PC_plus_4);
addition    M9(PC_OUT,IMM_u,PC_plus_IMM_u);
assign      REG_INPUT=MEM_ALU[1]?(MEM_ALU[0]?RESULT:IMM_u):(MEM_ALU[0]?PC_plus_IMM_u:PC_plus_4);

CONTROLLER  M3(INSTR,CLK,ALUop,PC_SRC,JT,REG_RD,REG_WR,WR_RD,MEM_EN,PC_R,ALU_DT,MEM_ALU,ALU_src);
ALU_ctrl    M5(ALUop,CLK,CTRL,FLAG,CTR,SEL,X);
imm_gen     M6(INSTR,CLK,IMM_i,IMM_u,IMM_s,IMM_b,IMM_j,SHMT_i);

endmodule


//////////////////////////////////////////////// MAIN CONTROLLER //////////////////////////////////////////////
module CONTROLLER(instr,clock,ALUop,PC_src,JT,reg_rd,reg_wr,wr_rd,mem_en,pc_r,alu_dt,mem_alu,alu_src);
input [31:0]instr;
input clock;
output reg [3:0]ALUop;
output reg [1:0]mem_alu;
output reg [1:0]alu_src;
output reg mem_en,wr_rd,pc_r,reg_wr,reg_rd,alu_dt,PC_src,JT;

integer i=0;

always@(posedge clock)
begin
mem_en=1'b1; 

case(instr[6:0])
7'b0110011:begin // R-TYPE
           case({instr[30],instr[14:12]})
           4'b0000: begin ALUop=4'd1;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd0;alu_dt=1'b0; end  //add
           4'b1000: begin ALUop=4'd2;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd0;alu_dt=1'b0; end  //sub
           4'b0001: begin ALUop=4'd6;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd0;alu_dt=1'b0; end  //sll
           4'b0010: begin ALUop=4'd9;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd0;alu_dt=1'b0; end  //slt
           4'b0100: begin ALUop=4'd5;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd0;alu_dt=1'b0; end  //xor
           4'b0101: begin ALUop=4'd7;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd0;alu_dt=1'b0; end  //srl
           4'b1101: begin ALUop=4'd8;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd0;alu_dt=1'b0; end  //sra
           4'b0110: begin ALUop=4'd3;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd0;alu_dt=1'b0; end  //or
           4'b0111: begin ALUop=4'd4;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd0;alu_dt=1'b0; end  //and
           default  : begin ALUop=4'dz;PC_src=1'bz;JT=1'bz;reg_rd=1'bz;reg_wr=1'bz;wr_rd=1'bz;pc_r=1'bz;mem_alu=2'dz;alu_src=2'dz;alu_dt=1'bz; end   
           endcase  
           end

7'b0010011:begin // I-TYPE
           case({instr[30],instr[14:12]})
           4'b000: begin ALUop=4'd1;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd1;alu_dt=1'b0; end  // addi
           4'b010: begin ALUop=4'd9;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd1;alu_dt=1'b0; end  // slti
           4'b100: begin ALUop=4'd5;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd1;alu_dt=1'b0; end  // xori
           4'b110: begin ALUop=4'd3;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd1;alu_dt=1'b0; end  // ori
           4'b111: begin ALUop=4'd4;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd1;alu_dt=1'b0; end  // andi
        //   default : begin ALUop=4'dz;PC_src=1'bz;JT=1'bz;reg_rd=1'bz;reg_wr=1'bz;wr_rd=1'bz;pc_r=1'bz;mem_alu=2'dz;alu_src=2'd1;alu_dt=1'bz; end   
        //   endcase
           
        //   case({instr[30],instr[14:12]})
           4'b0001: begin ALUop=4'd6;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd3;alu_dt=1'b0; end   //slli
           4'b0101: begin ALUop=4'd7;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd3;alu_dt=1'b0; end   //srli
           4'b1101: begin ALUop=4'd8;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd3;alu_dt=1'b0; end   //srai
           default  : begin ALUop=4'dz;PC_src=1'bz;JT=1'bz;reg_rd=1'bz;reg_wr=1'bz;wr_rd=1'bz;pc_r=1'bz;mem_alu=2'dz;alu_src=2'dz;alu_dt=1'bz; end   
           endcase
           end
           
7'b0000011:begin // I-TYPE
           if(instr[14:12]==5'b010)
           begin ALUop=4'd1;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b1;mem_alu=2'dz;alu_src=2'd1;alu_dt=1'b1; end // lw
           end           
           
7'b1100111:begin // I-TYPE
           if(instr[14:12]==5'b000) 
           begin ALUop=4'd14;PC_src=1'b0;JT=1'b1;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd0;alu_src=2'd1;alu_dt=1'b0; end //jalr
           end    
                  
7'b0100011:begin // S-TYPE
           if(instr[14:12]==5'b010) 
           begin ALUop=4'd1;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b0;wr_rd=1'b1;pc_r=1'b1;mem_alu=2'dz;alu_src=2'd2;alu_dt=1'b0; end //sw
           end
           
7'b1100011:begin // B-TYPE
           case(instr[14:12])
           3'b000: begin ALUop=4'd10;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b0;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'dz;alu_src=2'd0;alu_dt=1'b0; end //beq
           3'b001: begin ALUop=4'd11;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b0;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'dz;alu_src=2'd0;alu_dt=1'b0; end //bnq
           3'b100: begin ALUop=4'd12;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b0;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'dz;alu_src=2'd0;alu_dt=1'b0; end //blt
           3'b101: begin ALUop=4'd13;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b0;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'dz;alu_src=2'd0;alu_dt=1'b0; end //bge
           default : begin ALUop=4'dz;PC_src=1'bz;JT=1'bz;reg_rd=1'bz;reg_wr=1'bz;wr_rd=1'bz;pc_r=1'bz;mem_alu=2'dz;alu_src=2'dz;alu_dt=1'bz; end   
           endcase 
           end          
           
7'b1101111:begin // J-TYPE
           ALUop=4'dz;PC_src=1'b1;JT=1'b0;reg_rd=1'b0;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd0;alu_src=2'dz;alu_dt=1'b0;   // jal 
           end     

7'b0110111:begin // U-TYPE
           ALUop=4'dz;PC_src=1'b0;JT=1'b0;reg_rd=1'b0;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd2;alu_src=2'dz;alu_dt=1'b0;   // lui 
           end        
           
7'b0010111:begin // U-TYPE
           ALUop=4'd1;PC_src=1'b0;JT=1'b0;reg_rd=1'b0;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd1;alu_src=2'dz;alu_dt=1'b0; //auipc 
           end 
default   :begin ALUop=4'dz;PC_src=1'bz;JT=1'bz;reg_rd=1'bz;reg_wr=1'bz;wr_rd=1'bz;pc_r=1'bz;mem_alu=2'dz;alu_src=2'dz;alu_dt=1'bz; end                       
endcase

end
endmodule
////////////////////////////////////////////// MAIN CONTROLLER END ///////////////////////////////////////////

////////////////////////// ALU_CTRL /////////////////////////////////////////
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
///////////////////////// ALU_CTRL_END //////////////////////////////////////

////////////////////// MEMORY //////////////////////////////////////
module memory(add,data_in,ALU_res,i_r,clk,rd_i,wr_rd,instr,data_out);
input [31:0]add,data_in,ALU_res;
input clk,rd_i,wr_rd,i_r;
output reg[31:0]instr;
output [31:0]data_out;
reg [31:0]rom[0:28];
reg [31:0]data[0:120];
wire [31:0]add1;

assign add1=i_r?ALU_res:add;

always@(posedge clk)
begin
if(rd_i)
instr<=rom[add];

if(wr_rd)
data[add1]<=data_in;
end
assign data_out=wr_rd?32'bz:data[add1];

initial
begin

rom[0]=32'h00020133; ////////and
rom[1]=32'h402082b3;
rom[2]=32'h002092b3;
rom[3]=32'h0020a2b3;
rom[4]=32'h0020c2b3;
rom[5]=32'h0020d2b3;
rom[6]=32'h0020e2b3;
rom[7]=32'h4020d2b3;
rom[8]=32'h0020f2b3;
rom[9]=32'h01f17193; /////// andi
rom[10]=32'h0030a293;
rom[11]=32'h0030c293;
rom[12]=32'h0030e293;
rom[13]=32'h0030f293;
rom[14]=32'h0032a103; /////// lw
rom[15]=32'h00c082e7;
rom[16]=32'h00309293;
rom[17]=32'h00115213; // srli
rom[18]=32'h4030d293;
rom[19]=32'h0620a2a3;
rom[20]=32'h00308063;  //////// beq
rom[21]=32'h062092e3;
rom[22]=32'h0620c2e3;
rom[23]=32'h0620d2e3;
rom[24]=32'h000082ef;
rom[25]=32'h000082b7;
rom[26]=32'h00008297;
rom[27]=32'h01f27193;  ////// andi_bar


data[0]=32'b00110010010101000011010000110111;
data[1]=32'b01110111010101000011010000010111;
data[2]=32'b11111111111111110101010001101111;
data[3]=32'b11110100010111110000010001100111;
data[4]=32'b10011010100011110000010001100011;
data[5]=32'b10111111011001000001010101100011;
data[6]=32'b10111100010101000100111001100011;
data[7]=32'b10111100010101000101011001100011;
data[8]=32'b10110010001100000110011001100011;
data[9]=32'b10011001001100000111011001100011;
data[10]=32'b01010111000001110000001010101110;
data[11]=32'b01100101001100000001011000000011;
data[12]=32'b11111010110111100010011000000011;
data[13]=32'b11111010110111100100011000000011;
data[14]=32'b11001010111011100101011000000011;
data[15]=32'b11001010111011100000011000100011;
data[16]=32'b11000111100011100001011000100011;
data[17]=32'b10011000011111100010011000100011;
data[18]=32'b10011000011111100000011000010011;
data[19]=32'b10010101011011100001011000010011;
data[20]=32'b11110100010011100010011000010011;
data[21]=32'b00110011010111100011011000010011;
data[22]=32'b00110011010100100100011000010011;
data[23]=32'b10010011010100100101011000010011;
data[24]=32'b11000000010100100110011000010011;
data[25]=32'b11001111010110000111011000010011;
data[26]=32'b00000000010110000001011000010011;
data[27]=32'b00000001010110000101011000010011;
data[28]=32'b01000001010110000101011000010011;
data[29]=32'b00000000010110000000011000110011;
data[30]=32'b01000000010110000000011000110011;
data[31]=32'b00000000010110000001011000110011;
data[32]=32'b00000000111110000010011000110011;
data[33]=32'b00000000111111110011011000110011;
data[34]=32'b00000000100110010100011000110011;
data[35]=32'b00000000111110010101011000110011;
data[36]=32'b01000000111110010101011000110011;
data[37]=32'b00000000111110010110011000110011;
data[38]=32'b00000000111110010111011000110011;
data[39]=32'b10011000011111100000011000010011;
data[108]=32'b10011000011111100000011000010011;

end
endmodule

/////////////////////// MEMORY_END /////////////////////////////////////////

////////////////////// REG_FILE /////////////////////////////////////////////
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
5'd0: R[0]=32'b0; 5'd8: R[8]=wr_data;  5'd16: R[16]=wr_data; 5'd24: R[24]=wr_data;
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
rs1=instr[19:15]; rs2=instr[24:20];// rd =instr[11:7];

if(reg_rd)
begin

case(rs1)
5'd0: rd1=32'b0; 5'd8: rd1=R[8];  5'd16: rd1=R[16]; 5'd24: rd1=R[24];
5'd1: rd1=R[1]; 5'd9: rd1=R[9];  5'd17: rd1=R[17]; 5'd25: rd1=R[25];
5'd2: rd1=R[2]; 5'd10:rd1=R[10]; 5'd18: rd1=R[18]; 5'd26: rd1=R[26];
5'd3: rd1=R[3]; 5'd11:rd1=R[11]; 5'd19: rd1=R[19]; 5'd27: rd1=R[27];
5'd4: rd1=R[4]; 5'd12:rd1=R[12]; 5'd20: rd1=R[20]; 5'd28: rd1=R[28];
5'd5: rd1=R[5]; 5'd13:rd1=R[13]; 5'd21: rd1=R[21]; 5'd29: rd1=R[29];
5'd6: rd1=R[6]; 5'd14:rd1=R[14]; 5'd22: rd1=R[22]; 5'd30: rd1=R[30];
5'd7: rd1=R[7]; 5'd15:rd1=R[15]; 5'd23: rd1=R[23]; 5'd31: rd1=R[31];
endcase

case(rs2)
5'd0: rd2=32'b0; 5'd8: rd2=R[8];  5'd16: rd2=R[16]; 5'd24: rd2=R[24];
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
R[1]=32'h0000000e;
R[5]=32'h00000007;
end

endmodule
////////////////////// REG END /////////////////////////////////////////////////

////////////////////////////// PC GENERATION /////////////////////////////////////////////////////////////////////////////////////////
module PC_GEN(pc_out,clock,i_pc,imm_j,imm_b,pc_src,jlr,jt,bt);
input [31:0]jlr,imm_j,imm_b;
input jt,bt,clock,pc_src,i_pc;
output reg[31:0]pc_out;

wire [31:0]i1,i2,i3,pc,out;

assign i1=bt?imm_b:32'd1;
assign i2=pc_src?imm_j:i1;
assign pc=i_pc?32'b0:pc_out;
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

//////////////////////////////////////////////////PC END//////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////// imm_value generate ////////////////////////////////////////////////////////////////////
module imm_gen(instr,clock,imm_i,imm_u,imm_s,imm_b,imm_j,shmt_i);
input [31:0]instr;
input clock;
output reg[31:0]imm_i,imm_u,imm_s,imm_b,imm_j,shmt_i;

always @(posedge clock)
begin

if(instr[6:0]==7'b0000011) imm_i= {{20{instr[31]}},instr[31:20]};       // I-type
else if(instr[6:0]==7'b0010011) begin
            if((instr[14:12]==3'd1)||(instr[14:12]==3'd5))
            shmt_i= {27'b0,instr[24:20]};       // shamt I-type
            else
            imm_i= {{20{instr[31]}},instr[31:20]};       // I-type
            end
else if(instr[6:0]==7'b1100111) imm_i= {{20{instr[31]}},instr[31:20]};       // I-type
else if(instr[6:0]==7'b0100011) imm_s= {{20{instr[31]}},instr[31:25],instr[11:7]};       // S-type 
else if(instr[6:0]==7'b1100011) imm_b= {{18{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0};       // B-type
else if(instr[6:0]==7'b1101111) imm_j= {{11{instr[31]}},instr[31],instr[19:12],instr[21],instr[30:22],1'b0};       // J-type
else if(instr[6:0]==7'b0110111) imm_u= {instr[31:12],12'b0} ;       // U-type
else if(instr[6:0]==7'b0010111) imm_u= {instr[31:12],12'b0} ;       // U-type
else begin imm_i=32'bz;imm_u=32'bz;imm_s=32'bz;imm_b=32'bz;imm_j=32'bz;shmt_i=32'bz;end

end
endmodule
/////////////////////////////////////////////// imm_value_END ///////////////////////////////////////////////////////////////////////////////

/////////////////////// ALU ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module ALU(A,B,clock,ctrl,flag,sel,x,ctr,BT,JLR,result,count,rst,en);
input [31:0]A,B;
input [2:0]ctrl;
input [1:0]sel,x,ctr;
input clock,rst,en,flag;
output reg[31:0]result,JLR;
output reg BT;
output reg [4:0]count;
wire [32:0]i0;
wire [31:0]i1,i2;
wire i8,i3;
//wire [31:0]tempB;


//assign tempB = B_INV?(~B):B;
sub_add m1(A,B,flag,i0);          /// add or sub operation

logical m3(A,B,clock,sel,i1);    /// logical operation

shift   m6(A,B,clock,x,i2);     /// shift operation

comp    m9(A,B,2'd2,clock,i8);    /// comparision(SLT)

comp    m10(A,B,ctr,clock,i3);   /// comparision

always@(posedge clock)
begin

case (ctrl)
3'd0: begin result = i0; BT=1'b0; JLR=32'b0; end                                    //add_sub
3'd1: begin result = i1; BT=1'b0; JLR=32'b0; end                                    //logical
3'd2: begin result = i2; BT=1'b0; JLR=32'b0; end                                    //shift
3'd3: begin result =(i8)?(32'd1):(32'd0); BT=1'b0; JLR=32'b0; end                   //comp_[slt/slti]
3'd4:begin  BT=i3; JLR=32'b0; result = 32'd0; end                                   // comp_branch
3'd5:begin JLR=i0; result = 32'd0; BT=1'b0; end                                     // add_jalr
default:begin result = 32'dz; BT=1'bZ; JLR=32'bz; end
endcase

if(!rst)
count = 0;
else if(BT && en)
begin
count = count+1;
end

end

endmodule

//shift module ////////////////////////////////////////////

module shift(rs,s_value,clk,x,out);
input [31:0]rs,s_value;
input [1:0]x;
input clk;
output reg[31:0]out;
reg [31:0]temp_rs;
reg flag=1'b0;
reg [31:0]i=0;

always@(posedge clk)
begin
case(x)
2'd0:out=rs<<s_value;
2'd1:out=rs>>s_value;
2'd2:out=rs>>>s_value;
default:out=32'dz;
endcase
end
endmodule

/////////////////////////////////////////////////end //////////////////////////////////

// logical operation module //////////////////////////////////////

module logical(x,y,clk,sel,out);
input [31:0]x,y;
input [1:0]sel;
input clk;
output reg[31:0]out;

always@(posedge clk)
begin
case (sel)
2'd0: out=(x&y);
2'd1: out=(x|y);
2'd2: out=(x^y);
default: out=32'bz;
endcase
end
endmodule

//////////////////////////////////////// end ///////////////////////////////////////////

//comparator/////////////////////////////

module comp(x,y,ctrl,clk,bt);
input [31:0]x,y;
input clk;
input [1:0]ctrl;
output reg bt;

wire [32:0]tempo;

sub_add m1(x,y,1'b1,tempo);
always@ (posedge clk)
begin
case(ctrl)
2'd0: bt=(x==y)?1'b1:1'b0;
2'd1: bt=(x!=y)?1'b1:1'b0;
2'd2: bt=(tempo[32]==1'b1)?1'b1:1'b0;
2'd3: bt=(tempo[32]==1'b0)?1'b1:1'b0;
endcase

end
endmodule

/////////////////////////comparator end/////////////////////////////

// Design Module //
module sub_add(a,B,flag,res);

input [31:0]a,B;
input flag;
output [32:0]res;

wire [31:0]b;
wire c1,c2,c3,cin;
wire [31:16]out1,out2;
wire [32:0]out;

assign cin = flag?1'b1:1'b0;
assign b = cin?(~B):B;

adder A1(cin,a[15:0],b[15:0],out[15:0],c1);

adder A2(1'b0,a[31:16],b[31:16],out1[31:16],c2);

adder A3(1'b1,a[31:16],b[31:16],out2[31:16],c3);

assign out[32:16]=c1?{c3,out2[31:16]}:{c2,out1[31:16]};
//assign res = out[16]?{1'b0,out[15:0]}:{1'b1,(~out[15:0]+16'b1)};
assign res = {out[31],out[31:0]};

endmodule


/////// Adder Module ///////
module adder(carryin,x,y,s,carryout);

output [15:0]s;
output carryout;
input [15:0]x,y;
input carryin;
 
 wire [15:1]w;
 
full_adder fa0(s[0],w[1],x[0],y[0],carryin);
full_adder fa1(s[1],w[2],x[1],y[1],w[1]);
full_adder fa2(s[2],w[3],x[2],y[2],w[2]);
full_adder fa3(s[3],w[4],x[3],y[3],w[3]);
full_adder fa4(s[4],w[5],x[4],y[4],w[4]);
full_adder fa5(s[5],w[6],x[5],y[5],w[5]);
full_adder fa6(s[6],w[7],x[6],y[6],w[6]);
full_adder fa7(s[7],w[8],x[7],y[7],w[7]);
full_adder fa8(s[8],w[9],x[8],y[8],w[8]);
full_adder fa9(s[9],w[10],x[9],y[9],w[9]);
full_adder fa10(s[10],w[11],x[10],y[10],w[10]);
full_adder fa11(s[11],w[12],x[11],y[11],w[11]);
full_adder fa12(s[12],w[13],x[12],y[12],w[12]);
full_adder fa13(s[13],w[14],x[13],y[13],w[13]);
full_adder fa14(s[14],w[15],x[14],y[14],w[14]);
full_adder fa15(s[15],carryout,x[15],y[15],w[15]);

endmodule
 
///////////single bit adder///////////////
module full_adder(sum,cout,a,b,cin);

output sum,cout;
input a,b,cin;

assign sum = a^b^cin;
assign cout = (a&b)|(b&cin)|(a&cin);

endmodule

////////////////////// ALU END ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
