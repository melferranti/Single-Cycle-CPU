`timescale 1ns / 1ns

module control(
    input [5:0] instruction,
	output reg [1:0] ALUOp,
	output reg MemRead,
	output reg MemtoReg,
	output reg RegDst,
    output reg Branch,
    output reg BNE, 
    output reg Jump,
    output reg LUI,
	output reg ALUSrc,
	output reg MemWrite,
	output reg RegWrite
);


    always @ (*) begin
        if (instruction == 6'b00_0000) begin	// R-TYPE
            ALUOp = 2'b00;
		    MemRead = 1'b0;
		    MemtoReg = 1'b0;
		    RegDst = 1'b1;
            Branch = 1'b0;	
            BNE = 1'b0;
            Jump = 1'b0;	
            LUI = 1'b0;
	        ALUSrc = 1'b0;
		    MemWrite = 1'b0;
		    RegWrite = 1'b1;
		end else if (instruction == 6'b00_0100) begin   // BRANCH
		    ALUOp = 2'b01; // Subtraction
		    MemRead = 1'b0;
		    MemtoReg = 1'b0;
		    RegDst = 1'b0;
            Branch = 1'b1;
            BNE = 1'b0;	
            Jump = 1'b0;
            LUI = 1'b0;		
	        ALUSrc = 1'b0;
		    MemWrite = 1'b0;
		    RegWrite = 1'b0;
		end else if (instruction == 6'b10_1011) begin   // SW
		    ALUOp = 2'b10;
		    MemRead = 1'b0;
		    MemtoReg = 1'b0;
		    RegDst = 1'b0;
            Branch = 1'b0;	
            BNE = 1'b0;	
            Jump = 1'b0;
            LUI = 1'b0;	
	        ALUSrc = 1'b1;
		    MemWrite = 1'b1;
		    RegWrite = 1'b0;
		end else if (instruction == 6'b10_0011) begin   // LW
            ALUOp = 2'b10;
            MemRead = 1'b1;
            MemtoReg = 1'b1;
            RegDst = 1'b0;
            Branch = 1'b0;
            BNE = 1'b0;
            Jump = 1'b0;
            LUI = 1'b0;			
            ALUSrc = 1'b1;
            MemWrite = 1'b0;
            RegWrite = 1'b1;
		end else if (instruction == 6'b00_1000) begin // ADDI
		    ALUOp = 2'b10;
		    MemRead = 1'b0;
		    MemtoReg = 1'b0;
		    RegDst = 1'b0;
            Branch = 1'b0;
            BNE = 1'b0;
            Jump = 1'b0;	
            LUI = 1'b0;		
	        ALUSrc = 1'b1;
		    MemWrite = 1'b0;
		    RegWrite = 1'b1;
		end else if (instruction == 6'b00_0010) begin // JUMP 
		    ALUOp = 2'b11;
		    MemRead = 1'b0;
		    MemtoReg = 1'b0;
		    RegDst = 1'b0;
            Branch = 1'b0;
            BNE = 1'b0;
            Jump = 1'b1;
            LUI = 1'b0;			
	        ALUSrc = 1'b0;
		    MemWrite = 1'b0;
		    RegWrite = 1'b0;
		end else if (instruction == 6'b00_0011) begin // BNE
		    ALUOp = 2'b01; // Subtraction
		    MemRead = 1'b0;
		    MemtoReg = 1'b0;
		    RegDst = 1'b0;
            Branch = 1'b0;
            BNE = 1'b1;	
            Jump = 1'b0;
            LUI = 1'b0;		
	        ALUSrc = 1'b0;
		    MemWrite = 1'b0;
		    RegWrite = 1'b0;
		end else if (instruction == 6'b00_1111) begin // LUI
		    ALUOp = 2'b11;
		    MemRead = 1'b0;
		    MemtoReg = 1'b0;
		    RegDst = 1'b0;
            Branch = 1'b0;	
            BNE = 1'b0;	
            Jump = 1'b0;
            LUI = 1'b1;	
	        ALUSrc = 1'b1;
		    MemWrite = 1'b0;
		    RegWrite = 1'b1;
		end else begin
            ALUOp = 2'b00;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            RegDst = 1'b0;
            Branch = 1'b0;
            BNE = 1'b0;
            Jump = 1'b0;
            LUI = 1'b0;		
            ALUSrc = 1'b0;
            MemWrite = 1'b0;
            RegWrite = 1'b0;
		end
    end
    
endmodule
