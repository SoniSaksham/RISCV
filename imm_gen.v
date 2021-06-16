`timescale 1ns / 1ps


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
