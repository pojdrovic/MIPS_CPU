`timescale 1ns / 1ps

module CPU(SystemState, MainAluOP, ProgramCounter, MainInstruction, MainAluSrcA, MainAluSrcB, MainImmediateSelect, MainSelectedImmediate, MainSelectedDataA, MainSelectedDataB, MainAluOutput, MainOpcodeOut, MainReadReg1, MainReadReg2, MainWriteReg, MainWriteData, Clk, Reset);
              
 
    parameter   DataSize = 32;
    parameter   ImmediateSize = 16;
    parameter   RegisterSize = 5;
    parameter   OpcodeSize = 6;
    parameter   ALUOpSize = 4;
    
    output  [DataSize-1:0]  ProgramCounter, LatchedInstr_1, MainSelectedDataA, MainSelectedDataB, MainSelectedImmediate,  MainAluOutput, MainWriteData;
                                        
                                        
    output  [5:0] MainOpcodeOut;
    output  [4:0] MainReadReg1,
                  ReadReg2,
                  MainWriteReg;
    output  [3:0] SystemState,
                  AluOp_1;
    output  [1:0] MainAluSrcA,
                  MainImmediateSelect;
    output        MainAluSrcA;
    
    assign t_OpcodeOut = Opcode;
    assign MainAluSrcA = AluSrcA;
    assign MainAluSrcB = AluSrcB;
    assign MainAluOP = AluOp;
    

    input Clk, Reset;
    

    wire        [OpcodeSize-1:0]   Opcode;
    wire        PCSource;
    wire        PCWrite;
    wire        PCWriteCond;
    wire        [ALUOpSize-1:0] AluOp;
    wire        AluSrcA;
    wire        [1:0] AluSrcB;
    wire        IRWrite;
    wire        RFWrite;
    wire        MDRWrite;
    wire        DMemWrite;
    wire        MemToReg;
    wire        ImmedAddr;
    wire        ReadDataSrc1;
    wire        ReadDataSrc2;

    // Instantiation of the System Controller
    CPU_Control CPU_Controller(SystemState, PCSource, PCWrite, BEQcontrol, BNEcontrol, AluOp, AluSrcA, AluSrcB, IRWrite, RFWrite, MDRWrite,DMemWrite, MemToReg, ImmedAddr, ReadDataSrc1, ReadDataSrc2, Opcode, Clk, Reset);
    
    // Instantiation of the System Datapath
    Datapath    CPU_Datapath(ProgramCounter, MainInstruction, MainAluOutput, MainSelectedDataA, MainSelectedDataB, MainImmediateSelect, MainSelectedImmediate, t_ReadReg1, t_ReadReg2, t_WriteReg, t_WriteData, Opcode, PCSource, PCWrite, BEQcontrol, BNEcontrol, AluOp, AluSrcA, AluSrcB, IRWrite, RFWrite, MDRWrite, DMemWrite, MemToReg, ImmedAddr, ReadDataSrc1, ReadDataSrc2, Clk, Reset);

endmodule
