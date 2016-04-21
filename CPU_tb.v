`timescale 1ns / 1ps


module CPU_tb;

    // Inputs
    reg Clk;
    reg Reset;

    // Outputs
    wire [3:0]  t_State;
    wire [3:0]  t_AluOp;
    wire [31:0] t_CurrentPC;
    wire [31:0] t_LatchedInstr;
    wire        t_AluSrcA;
    wire [1:0]  t_AluSrcB;
    wire [1:0]  t_ImmedSel;
    wire [31:0] t_SelectedImmed;
    wire [31:0] t_SelectedDataA;
    wire [31:0] t_SelectedDataB;
    wire [31:0] t_LatchedAluOut;
    wire [5:0]  t_OpcodeOut;
    wire [4:0]  t_ReadReg1;
    wire [4:0]  t_ReadReg2;
    wire [4:0]  t_WriteReg;
    wire [31:0] t_WriteData;

    // Instantiate the Unit Under Test (UUT)
    CPU uut (
        .t_State(t_State), 
        .t_AluOp(t_AluOp),
        .t_CurrentPC(t_CurrentPC), 
        .t_LatchedInstr(t_LatchedInstr), 
        .t_AluSrcA(t_AluSrcA), 
        .t_AluSrcB(t_AluSrcB), 
        .t_ImmedSel(t_ImmedSel),
        .t_SelectedImmed(t_SelectedImmed),
        .t_SelectedDataA(t_SelectedDataA), 
        .t_SelectedDataB(t_SelectedDataB), 
        .t_LatchedAluOut(t_LatchedAluOut), 
        .t_OpcodeOut(t_OpcodeOut),
        .t_ReadReg1(t_ReadReg1),
        .t_ReadReg2(t_ReadReg2),
        .t_WriteReg(t_WriteReg),
        .t_WriteData(t_WriteData),
        .Clk(Clk), 
        .Reset(Reset)
    );

    initial begin
        // Initialize Inputs
        Clk = 0;
        Reset = 0;

        // Wait 100 ns for global reset to finish
        
        // Add stimulus here
        Reset = 1;
        #10;
        
        // Start execution
        Reset = 0;
    
    end
    
    always begin
    #5 Clk = ~Clk;
    end
      
endmodule

