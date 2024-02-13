`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:11:33 10/25/2016 
// Design Name: 
// Module Name:    cpu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

// 8 bit data
// 4 bit wide address for memories and reg file
// 32 bit wide instruction
// 4 bit immediate

module cpu(
    rst,
	clk,
	initialize,
	instruction_initialize_data,
	instruction_initialize_address
);
	 	 	 
    input rst;
	input clk;
	input initialize;
	input [31:0] instruction_initialize_data;
	input [31:0] instruction_initialize_address;
	wire [31:0] PC_out;
	wire [31:0] instruction;
	wire [31:0] instruction_mem_out;
	assign instruction = (initialize) ? 32'hFFFF_FFFF : instruction_mem_out;
    InstrMem InstructionMemory (instruction_mem_out, instruction_initialize_data  , (initialize) ? instruction_initialize_address : PC_out , initialize , clk);
	
	
	wire [1:0] ALUOp;
	wire MemRead;
	wire MemtoReg;
	wire RegDst;
	wire Branch;
	wire BNE;
	wire Jump;
	wire LUI; 
	wire ALUSrc;
	wire MemWrite;
	wire RegWrite;
    control Control(instruction[31:26], ALUOp, MemRead, MemtoReg, RegDst, Branch, BNE, Jump, LUI, ALUSrc, MemWrite, RegWrite); 
	
	 
	wire [31:0] write_data;
    wire [4:0] write_register;
    wire [31:0] read_data_1, read_data_2;
	wire [31:0] ALUOut, MemOut;
	mux #(5) Write_Reg_MUX (RegDst, instruction[20:16], instruction[15:11], write_register);
	nbit_register_file Register_File(write_data, read_data_1, read_data_2, instruction[25:21] , instruction[20:16], write_register, RegWrite, clk);
    
     
	wire [31:0] immediate;
    sign_extend Sign_Extend(instruction[15:0], immediate);
    
    // LUI
    wire [31:0] immediate_lui;
	lui #(32) Load_Upper_Immediate (immediate, immediate_lui);
	 
	wire [31:0] immediate_alu;
	mux #(32) ALU_Immediate_MUX (LUI, immediate, immediate_lui, immediate_alu); 
	  
	wire [31:0] ALU_input_2;
    wire zero_flag;
	wire [2:0] ALU_function;
	mux #(32) ALU_Input_2_Mux (ALUSrc, read_data_2, immediate_alu, ALU_input_2);
	// mux #(32) ALU_Input_2_Mux (ALUSrc, read_data_2, immediate, ALU_input_2);
	ALU_control ALU_Control(instruction[5:0], ALUOp, ALU_function);
    ALU ALU(read_data_1, ALU_input_2, ALU_function, ALUOut, zero_flag);
	 
	
	Memory Data_Memory(ALUOut, read_data_2, MemOut, MemRead, MemWrite, clk);


    mux #(32) ALU_Mem_Select_MUX (MemtoReg, ALUOut, MemOut, write_data);	 
	 
	 
	wire [31:0] PC_in;
	PC Program_Counter(PC_out, PC_in, clk, rst);
	 
	
	wire [31:0] PC_plus_4;
	Adder #(32) PC_Increment_Adder (PC_out, 32'd4, PC_plus_4);

    // BRANCH
	wire [31:0] Branch_target_address;
	wire [31:0] immediate_x_4;
	shift_left_2 #(32) Shift_Left_Two (immediate, immediate_x_4);
	Adder #(32) Branch_Target_Adder (PC_plus_4, immediate_x_4, Branch_target_address);
	 
	// BEQ  
	wire PCSrc;
	wire PC_BEQ;
	and Branch_And (PC_BEQ, Branch, zero_flag);
	
	// BNE
	wire PC_BNE;
	and BNE_And (PC_BNE, BNE, ~(zero_flag));
	or PC_Or (PCSrc, PC_BEQ, PC_BNE);
	
	wire [31:0] PC_B;
	mux #(32) PC_Input_B_MUX (PCSrc, PC_plus_4, Branch_target_address, PC_B);
	// mux #(32) PC_Input_MUX (PCSrc, PC_plus_4, Branch_target_address, PC_in);
	
	// JUMP
    wire [31:0] Jump_target_address;
	wire [27:0] immediate_j;
	shift_left_2 #(32) Shift_Left_J (instruction[25:0], immediate_j);
	assign Jump_target_address = {PC_plus_4[31:28], immediate_j};
	
	wire [31:0] PC_J;
	mux #(32) PC_Input_Jump_MUX (Jump, PC_plus_4, Jump_target_address, PC_J);
	mux #(32) PC_Input_MUX (PCSrc, PC_J, PC_B, PC_in);
	  							 
endmodule
