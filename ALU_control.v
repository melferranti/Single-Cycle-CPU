`timescale 1ns / 1ns

module ALU_control(
    input [5:0] instruction,
	input [1:0] ALUOp,
	output reg [2:0] func
);

    always @(*) begin
        if (ALUOp == 2'b00) begin   // R-Format  
            if (instruction == 6'h20)   // ADD
		      func = 3'd0;
            else if (instruction == 6'h22)  // SUB
		      func = 3'd1;
		    else if (instruction == 6'h24)    // AND
		      func = 3'd2;
		    else if (instruction == 6'h25)    // OR
		      func = 3'd3;
		    else if (instruction == 6'h27)    // NOR
		      func = 3'd4;
		    else if (instruction == 6'h2A)    // SLT
		      func = 3'd5;
		    else
		      func = 3'd7;
	   end else if (ALUOp == 2'b01) begin  // BRANCH, BNE
            func = 3'd1;
	   end else if (ALUOp == 2'b10) begin // LW, SW
		    func = 3'd0;
	   end else if (ALUOp == 2'b11) begin  // LUI
	        func = 3'd6;    
	   end else begin
		    func = 3'd7;
	   end
    end


endmodule
