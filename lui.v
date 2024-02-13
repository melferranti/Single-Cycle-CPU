`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2023 10:13:06 PM
// Design Name: 
// Module Name: lui
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lui(in, out);

    parameter size = 32;
    
    input [size-1:0] in;
    output [size-1:0] out;
    
    assign out = {in[size-17:0], 16'b0};

endmodule
