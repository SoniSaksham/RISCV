`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


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
           4'b0001: begin ALUop=4'd6;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd1;alu_dt=1'b0; end   //slli
           4'b0101: begin ALUop=4'd7;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd1;alu_dt=1'b0; end   //srli
           4'b1101: begin ALUop=4'd8;PC_src=1'b0;JT=1'b0;reg_rd=1'b1;reg_wr=1'b1;wr_rd=1'b0;pc_r=1'b0;mem_alu=2'd3;alu_src=2'd1;alu_dt=1'b0; end   //srai
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
