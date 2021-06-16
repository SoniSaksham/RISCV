module ALU(A,B,clock,ctrl,flag,sel,x,ctr,BT,JLR,result);
input [31:0]A,B;
input [2:0]ctrl;
input [1:0]sel,x,ctr;
input clock,flag;
output reg[31:0]result,JLR;
output reg BT;
wire [32:0]i0;
wire [31:0]i1,i2;
wire i8,i3;


sub_add m1(A,B,flag,i0);          /// add or sub operation         /// add or sub operation

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

assign sum = a^b^cin;
assign cout = (a&b)|(b&cin)|(a&cin);

endmodule
