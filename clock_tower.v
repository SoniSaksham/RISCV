`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////



module clock_tower(h1,h2,m1,m2,ap,clk,reset);
input clk,reset;
output reg[3:0]h1,h2,m1,m2;
output reg ap;
integer i=0,j=0,k=0,l=0;

always@(posedge clk && l<10)
begin
if(l==0)
m2=4'b0000;

if(reset)
begin
h1=4'b0000;h2=4'b0000;m1=4'b0000;m2=4'b0000;ap=1'b0;
end

else
begin
m2=m2+4'b0001;
l=l+1;
end
$display($time,"h1=%d ,h2=%d ,m1=%d ,m2=%d,l=%d ,j=%d ,k=%d ,l=%d ",h1,h2,m1,m2,i,j,k,l);
end

always@(l)
begin
if(k==0)
m1=4'b0000;

if(m2==4'b1010 && k<7)
begin
m1=m1+4'b0001;m2=4'b0000;l=0;
k=k+1;
end

end

always@(k)
begin
if(j==0)
h2=4'b0000;

/*if(i==0)
h1=4'b0000;
*/
if(m1==4'b0110 && j<10)
begin
h2=h2+4'b0001;m1=4'b0000;k=0;
j=j+1;
end
/*
if(h2==4'b1010)
begin
h1=4'b0001;h2=4'b0000;j=0;i=i+1;
end
*/

end

always@(j)
begin

if(i==0)
h1=4'b0000;


if(h2==4'b1010)
begin
h1=4'b0001;h2=4'b0000;j=0;i=i+1;
end

if(h1==4'b0001&& m1==4'b0110 && i==1 && j<2)
begin
h2=h2+4'b0001;
j=j+1;
end

if(h2==4'b0010 && i==1)
begin
h1=4'b0000;i=0;
h2=4'b0000;j=0;
ap=~ap;
end

/*if(h1==4'b0001 )
begin
h1=4'b0000;i=0;
ap=~ap;
end*/

end

endmodule
