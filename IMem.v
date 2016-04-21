// IMem
//
// A module used to mimic Instruction memory, for the EC413 project.
// Returns hardcoded instructions based on the current PC.
//
// Fixed a false nop instruction and reg select fields in 1.
//
`timescale 1ns / 1ps
// ----------------------------------------------------
// IMPORTANT!
// Which test program to use:
// - PROGRAM_1: first simple example.
//
// - PROGRAM_2: test remaining instructions 
//              and corner cases.
// - PROGRAM_3: optional LW/SW program.
//
`define PROGRAM_3 // <<<<<<<<<<<< CHANGE TEST PROGRAM HERE!
//
// Change the previous line to try a different program,
// when available.
// ----------------------------------------------------

module IMem(Instruction,          
				PC			// PC (address) of instruction in IMem
            );

`ifdef PROGRAM_1
	parameter PROG_LENGTH= 22;
`else
`ifdef PROGRAM_2
	parameter PROG_LENGTH= 26;
`else
`ifdef PROGRAM_3
	parameter PROG_LENGTH= 26;
`ifdef PROGRAM_4
	parameter PROG_LENGTH= 1;
`endif
`endif
`endif
`endif
//-------------Input Ports-----------------------------
input [31:0] PC;
//-------------Output Ports----------------------------
output [31:0] Instruction;
reg [31:0] Instruction;
//------------Code Starts Here-------------------------
always @(PC)
begin
case(PC)
//-----------------------------------------------------
`ifdef PROGRAM_1
//-----------------------------------------------------

	//
	// PROGRAM_1: Basic Math, Branches and Jump Test
	//

	//
	// 1.1) First part: 
	// Load values into:
	// $R0 = -1
	// $R1 = 0
	// $R2 = 2
	// Add $R0 and $R2 and get an answer in $R3: 
	// -1 + 2 = 1
	//

	// LI   $R0, 0xFFFF
	0: Instruction=  32'b111001_00000_00000_1111111111111111;
	// LUI  $R0, 0xFFFF
	1: Instruction=  32'b111010_00000_00000_1111111111111111;
	// LI   $R1, 0x0000
	2: Instruction=  32'b111001_00001_00000_0000000000000000;
	// LUI  $R1, 0x0000
	3: Instruction=  32'b111010_00001_00000_0000000000000000;
	// LI   $R2, 0x0002
	4: Instruction=  32'b111001_00010_00000_0000000000000010;
	// LUI  $R2, 0x0000
	5: Instruction=  32'b111010_00010_00000_0000000000000000;
	// ADD  $R3, $R0, $R2
	6: Instruction=  32'b010010_00011_00000_00010_00000000000;

	//
	// 1.2) Second part: store and load, should store $R3
	// (contains 1) into address 5.  Then load from 
	// address 5 into register $R1.  $R1 should then 
	// contain 1.
	//

	// SWI  $R3, [0x5]
	7: Instruction=  32'b111100_00011_00000_0000000000000101;
	// LWI  $R1, [0x5]
	8: Instruction=  32'b111011_00001_00000_0000000000000101;


	//
	// 1.3) Third part: simple loop tests, to check branch
	//     look at the PC and alu output to check
	//

	// LI	$R23, 0x0000
	9: Instruction=	 32'b111001_10111_00000_0000000000000000;
	// ADDI $R0, $R0, 0x0001
	10: Instruction=  32'b110010_00000_00000_0000000000000001;
	// SLT  $R31, $R0, $R1
	11: Instruction= 32'b010111_11111_00000_00001_00000000000;
	// BNE 	$R31, $R23, 0xFFFD
	12: Instruction= 32'b100001_11111_10111_1111111111111101;


	// LI	$R23, 0x0003
	13: Instruction=  32'b111001_10111_00000_0000000000000011;
	// ADDI $R24, $R24, 0x0001
	14: Instruction=  32'b110010_11000_11000_0000000000000001;
	// BLT 	$R24, $R23, 0xFFFE
	15: Instruction= 32'b100010_11000_10111_1111111111111110;

	
	// ADDI $R25, $R25, 0x0001
	16: Instruction= 32'b110010_11001_11001_0000000000000001;
	// BLE 	$R25, $R23, 0xFFFE
	17: Instruction= 32'b100011_11001_10111_1111111111111110;

	// J 21	/ should skip the two addi 5 and go to addi 7
	18: Instruction= 32'b000001_00000_00000_0000000000000010;
	// ADDI $R0, $R0, 0x0005
	19: Instruction= 32'b110010_00000_00000_0000000000000101;
	// ADDI $R0, $R0, 0x0005
	20: Instruction= 32'b110010_00000_00000_0000000000000101;
	// ADDI $R26, $R26, 0x0007
	21: Instruction= 32'b110010_11010_11010_0000000000000111;
	// NOOP
	22: Instruction= 32'b000000_00000_00000_0000000000000000;
	
`else
//-----------------------------------------------------
`ifdef PROGRAM_2
//-----------------------------------------------------

	//
	// PROGRAM_2:
	// Test all R-type and logical/arithmetic I-type instructions, 
	// also test remaining untested instructions and additional
	// corner cases.
	//

	//
	// 2.1) First part: 
	// Load values into:
	// $R0 = -2    (0xFFFFFFFE)
	// $R1 = 65537 (0x00010001)
	// $R2 = 1     (0x00000001)
	//

	// LI   $R0, 0xFFFE
	0: Instruction=  32'b111001_00000_00000_1111111111111110;
	// LUI  $R0, 0xFFFF
	1: Instruction=  32'b111010_00000_00000_1111111111111111;
	// LI   $R1, 0x0001
	2: Instruction=  32'b111001_00001_00000_0000000000000001;
	// LUI  $R1, 0x0001
	3: Instruction=  32'b111010_00001_00000_0000000000000001;
	// LI   $R2, 0x0001
	4: Instruction=  32'b111001_00010_00000_0000000000000001;
	// LUI  $R2, 0x0000
	5: Instruction=  32'b111010_00010_00000_0000000000000000;
	
	//
	// 2.2) Second part: 
	// Run through all R-Type instructions
	//
	
	// MOV  $R3, $R2: ALUOutput = 1
	6: Instruction=  32'b010000_00011_00010_00000_00000000000;
	// NOT  $R4, $R2: ALUOutput = (~0x00000001) = 0xFFFFFFFE
	7: Instruction=  32'b010001_00100_00010_00000_00000000000;
	// ADD  $R5, $R2, $R0: ALUOutput = 1 + (-2) = -1 (0xFFFFFFFF)
	8: Instruction=  32'b010010_00101_00010_00000_00000000000;
	// SUB  $R6, $R2, $R0: ALUOutput = 1 - (-2) = 3
	9: Instruction=  32'b010011_00110_00010_00000_00000000000;
	// OR   $R7, $R1, $R0: ALUOutput = (0x00010001 | 0xFFFFFFFE) = 0xFFFFFFFF
	10: Instruction= 32'b010100_00111_00001_00000_00000000000;
	// AND  $R8, $R1, $R0: ALUOutput = (0x00010001 & 0xFFFFFFFE) = 0x00010000
	11: Instruction= 32'b010101_01000_00001_00000_00000000000;
	// XOR  $R9, $R1, $R0: ALUOutput = (0x00010001 ^ 0xFFFFFFFE) = 0xFFFEFFFF
	12: Instruction= 32'b010110_01001_00001_00000_00000000000;
	// SLT  $R10, $R1, $R0: ALUOutput = (0x00010001 < -2) = 0
	13: Instruction= 32'b010111_01010_00001_00000_00000000000;
	
	//
	// 2.3) Third part: 
	// Run through all Logical/Arithmetic I-Type instructions
	//
	
	// ADDI  $R12, $R2, 5: ALUOutput = 1 + 5 = 6
	14: Instruction= 32'b110010_01100_00010_0000000000000101;
	// SUBI  $R13, $R2, 5: ALUOutput = 1 - 5 = -4
	15: Instruction= 32'b110011_01101_00010_0000000000000101;
	// ORI   $R14, $R2, 5: ALUOutput = (0x00000001 | 0x0005) = 0x00000005
	16: Instruction= 32'b110100_01110_00010_0000000000000101;
	// ANDI  $R15, $R2, 5: ALUOutput = (0x00000001 & 0x0005) = 0x00000001
	17: Instruction= 32'b110101_01111_00010_0000000000000101;
	// XORI  $R16, $R2, 5: ALUOutput = (0x00000001 ^ 0x0005) = 0x00000004
	18: Instruction= 32'b110110_10000_00010_0000000000000101;
	// SLTI  $R17, $R2, 5: ALUOutput = (1 < 5) = 1
	19: Instruction= 32'b110111_10001_00010_0000000000000101;

	//
	// 2.4) Fourth part: 
	// LWI and SWI, test corner cases
	//
	
	// SWI  $R3, [0x0000] (store 1 at address 0)
	20: Instruction= 32'b111100_00011_00000_0000000000000000;
	// SWI  $R4, [0x0000] (overwrite value of 1 with 0xFFFFFFFE at address 0)
	21: Instruction= 32'b111100_00100_00000_0000000000000000;
	// SWI  $R5, [0xFFFF] (store 0xFFFFFFFF at address 0xFFFF)
	22: Instruction= 32'b111100_00101_00000_0000000000001111;
	// LWI  $R19, [0x0000] (load 0xFFFFFFFE)
	23: Instruction= 32'b111011_10011_00000_0000000000000000;
	// ADDI  $R19, $R19, 1: ALUOutput = 0xFFFFFFFF
	24: Instruction= 32'b110010_10011_10011_0000000000000001;
	// LWI  $R19, [0xFFFF] (load 0xFFFFFFFF)
	25: Instruction= 32'b111011_10011_00000_0000000000001111;
	// ADDI  $R19, $R19, 1: ALUOutput = 0x00000000
	26: Instruction= 32'b110010_10011_10011_0000000000000001;

	
`else
//-----------------------------------------------------
`ifdef PROGRAM_3
//-----------------------------------------------------

   // Simple LW and SW test.

	//
	// 3.1) First part: 
	// Load values into:
	// $R0 = 0    (0x00000000)
	// $R1 = 10   (0x0000000A)
	//
	/*
	// LI   $R0, 0x0000
	0: Instruction=  32'b111001_00000_00000_0000000000000000;
	// LUI  $R0, 0x0000
	1: Instruction=  32'b111010_00000_00000_0000000000000000;
	// LI   $R1, 0x000A
	2: Instruction=  32'b111001_00001_00000_0000000000001010;
	// LUI  $R1, 0x0000
	3: Instruction=  32'b111010_00001_00000_0000000000000000;

	//
	// 3.2) Second part: 
	// Loop with SW test.
	// Stores the following:
	//
	// Address 1:  0
	// Address 2:  1
	// ...
	// Address 9:  8
	// Address 10: 9
	//
	
	// SW  $R0, $R0[0x1]
	4: Instruction=  32'b111110_00000_00000_0000000000000001;
	// ADDI $R0, $R0, 0x0001
	5: Instruction=  32'b110010_00000_00000_0000000000000001;
	// BLT	$R0, $R1, 0xFFFD
	6: Instruction=  32'b100010_00000_00001_1111111111111101;
	
	//
	// 3.3) Third part: 
	// Loop with LW test.
	// Should output out of the ALU on instruction 11: 1, 2, ..., 10
	//
	
	// LI   $R0, 0x0000
	7: Instruction=  32'b111001_00000_00000_0000000000000000;
	// LUI  $R0, 0x0000
	8: Instruction=  32'b111010_00000_00000_0000000000000000;
	// LW  $R19, $R0[0x0001]
	9: Instruction= 32'b111101_10011_00000_0000000000000001;
	// ADDI $R19, $R19, 0x0001
	10: Instruction= 32'b110010_10011_10011_0000000000000001;
	// ADDI $R0, $R0, 0x0001
	11: Instruction= 32'b110010_00000_00000_0000000000000001;
	// BLT $R0, $R1 0xFFFC
	12: Instruction= 32'b100001_11111_00000_1111111111111100;
	*/
	
			
		0: Instruction = 32'b000000_00000_00000_0000000000000000;		// NOOP
		//MEM_Addr = 16'd0;
		
		//#10
		1: Instruction = 32'b110010_00001_00001_0000000000000101;		// I, addi r1 with 00000005 		=> r1 = 00000005
		//MEM_Addr = 16'd1;
		
		//#10
		2: Instruction = 32'b110010_00010_00010_0000000000001010;		// I, addi r2 with 0000000A 		=> r2 = 0000000A
		//MEM_Addr = 16'd2;
		
		//#10
		3: Instruction = 32'b110010_00011_00011_1111111111111000;		// I, addi r3 with 0000FFF8 		=> r3 = FFFFFFF8
		//MEM_Addr = 16'd3;
		
		//#10
		4: Instruction = 32'b110011_00100_00100_0000000000000001;		// I, subi r4 with 00000001 		=> r4 = FFFFFFFF
		//MEM_Addr = 16'd4;
				
		//#10
		5: Instruction = 32'b110100_00101_00101_1010101010101010;		// I, ori r5 with 0000AAAA  		=> r5 = 00000AAAA
		//MEM_Addr = 16'd5;
				
		//#10
		6: Instruction = 32'b110101_00110_00110_1111111111111111;		// I, andi r6 with 0000FFFF 		=> r6 = 00000000
		//MEM_Addr = 16'd6;
				
		//#10
		7: Instruction = 32'b010000_00111_00001_0000000000000000;		// R, mov r1 to r7					=> r7 = 00000005
		//MEM_Addr = 16'd7;
				
		//#10
		8: Instruction = 32'b010000_01000_00010_0000000000000000;		// R, mov r2 to r8					=> r8 = 0000000A
		//MEM_Addr = 16'd8;
				
		//#10
		9: Instruction = 32'b010000_01001_00000_0000000000000000;		// R, mov r0 to r9					=> r9 = 000000000
		//MEM_Addr = 16'd9;
				 
		//#10
		10: Instruction = 32'b010010_01010_00111_01000_00000000000;		// R, r10 = r7 + r8					=> r10 = 0000000F
		//MEM_Addr = 16'd10;
				
		//#10
		11: Instruction = 32'b010011_01011_00111_01000_00000000000;		// R, r11 = r7 - r8					=> r11 = FFFFFFFB
		//MEM_Addr = 16'd11;
		      
		//#10
		12: Instruction = 32'b010100_01100_00111_01001_00000000000;		// R, r12 = r7 or r9				=> r12 = 00000005
		//MEM_Addr = 16'd12;
		
		//#10
		13: Instruction = 32'b010101_01101_01000_00100_00000000000;		// R, r13 = r8 and r4				=> r13 = 0000000A
		//MEM_Addr = 16'd13;
				
		//#10
		14: Instruction = 32'b100000_01100_01101_1111111111110010;		// BEQ, Jump to 0 when r12 = r13
		//MEM_Addr = 16'd14;
				
		//#10
		15: Instruction = 32'b100000_01000_01101_0000000000000001;		// BEQ, Jump to 17 when r8 = r13
		//MEM_Addr = 16'd15;
				
		//#10
		16: Instruction = 32'b010000_01101_00000_0000000000010000;		// R, mov r0 to r13				 	=> r13 = 00000000
		//MEM_Addr = 16'd16;
				
		//#10
		17: Instruction = 32'b111100_01101_00000_0000000000001000;		// SWI r13 to MEM address 0x08
		//MEM_Addr = 16'd17;
				
		//#10
		18: Instruction = 32'b111011_01110_00000_0000000000001000;		// LWI r14 from MEM address 0x08   	=> r14 = 0000000A
		//MEM_Addr = 16'd18;
		
		//#10
		19: Instruction = 32'b100001_01101_01110_0000000000000001;		// BNE, Jump to 21 when r13 != r14
		//MEM_Addr = 16'd19;
				
		//#10
		20: Instruction = 32'b111001_01111_00000_0000000000001000;		// LI r15 from immediate 8			=> r15 = 00000008
		//MEM_Addr = 16'd20;
		
		//#10
		21: Instruction = 32'b100001_01100_01110_0000000000000001;		// BNE, Jump to 23 when r12 != r14
		//MEM_Addr = 16'd21;
		
		//#10
		22: Instruction = 32'b111001_01111_00000_0000000000001011;		// LI r15 from immediate B			=> r15 = 0000000B
		//MEM_Addr = 16'd22;
		
		//#10
		23: Instruction = 32'b010111_10000_01111_01110_00000000000;		// SLT, r16 = (r15 < r14)			=> r16 = 00000001
		//MEM_Addr = 16'd23;
		
		//#10
		24: Instruction = 32'b010111_10001_01111_1111111111111111;		// SLTI, r17 = (r15 < -1)			=> r17 = 00000000
		//MEM_Addr = 16'd24;
		
		//#10
		25: Instruction = 32'b010111_10010_01111_0000000000001001;		// SLTI, r18 = (r15 < 9)			=> r18 = 00000001
		//MEM_Addr = 16'd25;
		
		//#10
		26: Instruction = 32'b000001_00000_00000_0000000000000000;		// Jump to Instr 0		//MEM_Addr = 16'd26;

`else
			`ifdef PROGRAM_4
			0: Instruction = 32'b100001_01100_01110_0000000000000001;
			
`endif
`endif
`endif
`endif
	default: Instruction= 0; //NOOP
endcase
end

endmodule
	
