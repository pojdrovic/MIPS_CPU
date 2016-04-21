`timescale 1ns / 1ps

module Datapath(ProgramCounter, MainInstruction, MainImmediateSelect, MainSelectedImmediate, MainSelectedDataA, MainSelectedDataB, MainAluOutput, MainReadReg1, MainReadReg2, MainWriteReg, MainWriteData, Opcode, PCSource, PCWrite, BEQcontrol, BNEcontrol, AluOp, AluSrcA, AluSrcB, IRWrite, RFWrite, MDRWrite, DMemWrite, MemToReg, ImmedAddr, ReadDataSrc1, ReadDataSrc2, Clk, Reset);
                    

    parameter   DataSize = 32;
    parameter   ImmediateSize = 16;
    parameter   RegisterSize = 5;
    parameter   OpcodeSize = 6;
    parameter   ALUOpSize = 4;
    

    output  [DATA_WIDTH-1:0]  ProgramCounter, MainInstruction, MainAluOutput, MainSelectedDataA, MainSelectedDataB, MainSelectedImmediate, MainWriteData;
                                        
    output  [REG_SIZE-1:0]    MainReadReg1, MainReadReg2, MainWriteReg;
                        
    output  [1:0]   MainImmediateSelect;
    
    assign MainImmediateSelect = ImmedSrc;
    assign ProgramCounter = CurrentPC;
    assign MainInstruction = Instruction;
    assign MainAluOutput = AluOut;
    assign MainSelectedDataA = SelectedDataA;
    assign MainSelectedDataB = SelectedDataB;
    assign MainSelectedImmediate = SelectedImmediate;
    assign MainReadReg1 = R1orR2;
    assign t_ReadReg2 = R2orR3;
    assign MainReadReg2 = R1;
    assign MainWriteData = RFWriteData;
    
    

    output [OpcodeSize-1:0] Opcode;
    
    input       PCSource;
    input       PCWrite;
    input       BEQcontrol;
	input		 BNEcontrol;
    input       [ALUOP_SIZE-1:0] AluOp;
    input       AluSrcA;
    input       [1:0] AluSrcB;
    input       IRWrite;
    input       RFWrite;
    input       MDRWrite;
    input       DMemWrite;
    input       MemToReg;
    input       ImmedAddr;
    input       ReadDataSrc1;
    input       ReadDataSrc2;
    input       Clk;
    input       Reset;
 
    wire    [DATA_WIDTH-1:0]    NewPC, CurrentPC, Instr, CurrentInstr, MemData, CurrentMemData, RFWriteData, DataA, DataB, CurrentDataA, CurrentDataB, SelectedDataA, SelectedDataB, CurrentAluOut, CurrentAluOut, ImmedSE, ImmedZE, ImmedSHL, SelectedImmed, JumpTargetSE;
    
    wire    [RegisterSize-1:0]      R1, R2, R3, R1orR2, R2orR3;
    wire    [ImmediateSize-1:0]   Immed, MemAddr;
    wire    [AluopSize-1:0]    AluOpOut;
    wire    [25:0]              JumpTarget;
    wire    [1:0]               ImmedSrc, InstrType;
                    
    wire    PCWriteEnable, PCWriteCondResult0, PCWriteCondResult1, BranchResult0, NotZero, Zero;
    

    Register_32bit PC(CurrentPC,NewPC,PCWriteEnable,Reset,Clk);
    Register_32bit IR(CurrentInstr,Instr,IRWrite,Reset,Clk);
    Register_32bit MDR(CurrentMemData,MemData,1'b1,Reset,Clk);
    Register_32bit A(CurrentDataA,DataA,1'b1,Reset,Clk);
    Register_32bit B(CurrentDataB,DataB,1'b1,Reset,Clk);
    Register_32bit AluOut(CurrentAluOut,CurrentAluOut,1'b1,Reset,Clk);
    

    
    // Branch Logic
	not (NotZero, Zero);
    and (PCWriteCondResult0,BEQcontrol,Zero);
	and (PCWriteCondResult1,BNEcontrol, NotZero);
	or  (BranchResult0, PCWriteCondResult0, PCWriteCondResult1);
    or  (PCWriteEnable,PCWrite,BranchResult0);
    

    assign MemAddr = (ImmedAddr) ? CurrentAluOut[15:0] : Immed;
    

    IMem    InstrMemory(Instr,CurrentPC);
    DMem    DataMemory(MemData, CurrentDataA, MemAddr, DMemWrite, Clk);

    ALU MainALU(CurrentAluOut, Zero, SelectedDataA, SelectedDataB, AluOpOut);
    ALU_Control ALU_Controller(AluOpOut, ImmedSrc, AluOp, InstrType);
    
    

    assign R1 = CurrentInstr[25:21];
    assign R2 = CurrentInstr[20:16];
    assign R3 = CurrentInstr[15:11];
    assign Immed = CurrentInstr[15:0];
    assign JumpTarget = CurrentInstr[25:0];
    assign Opcode = CurrentInstr[31:26];
    assign InstrType = CurrentInstr[31:30]; 
    assign R1orR2 = ReadDataSrc1 ? R2 : R1;
    assign R2orR3 = ReadDataSrc2 ? R3 : R2;
    assign RFWriteData = MemToReg ? CurrentMemData : CurrentAluOut;


    nbit_register_file #(DataSize,RegisterSize)     RF(DataA, DataB, RFWriteData, R1orR2, R2orR3, R1, RFWrite, Reset, Clk);
    

    assign ImmedSE = (Immed[15] == 1) ? {16'hFFFF,Immed} : {16'h0000,Immed};
    assign JumpTargetSE = (JumpTarget[25] == 1)? {6'b111111,JumpTarget} : {6'b000000,JumpTarget};
    assign ImmedZE = {16'h0000,Immed};
    assign SelectedDataA = AluSrcA ? CurrentDataA : CurrentPC;
    assign SelectedDataB = (AluSrcB == 0) ? 32'd1 : (AluSrcB == 1) ? CurrentDataB : (AluSrcB == 2) ? JumpTargetSE : SelectedImmed;
    assign SelectedImmed = (ImmedSrc == 0) ? ImmedSE : (ImmedSrc == 1) ? ImmedZE : (ImmedSrc == 2) ? ImmedSHL : 0;
    

    
    assign NewPC = PCSource ? CurrentAluOut : CurrentAluOut;
    
endmodule
