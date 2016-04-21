`timescale 1ns / 1ps

module ALU_Control(AluOpOut, ImmedSel, AluOpIn, InstrType);


    parameter   ControlSize = 4;
    

    parameter   SignExtend  = 2'b00;
    parameter   ZeroExtend  = 2'b01;

    parameter   ADD = 4'b0010;
    parameter   SUB = 4'b0011;
    parameter   OR  = 4'b0100;
    parameter   AND = 4'b0101;
    parameter   XOR = 4'b0110;
    parameter   SLT = 4'b0111;
    parameter   LI  = 4'b1001;
    parameter   LWI = 4'b1011;
    parameter   SWI = 4'b1100;
    

    output reg  [ControlSize-1:0] AluOpOut;
    output reg  [1:0] ImmedSel;
    input   [ControlSize-1:0] AluOpIn;
    input   [1:0] Type;
    

    always @(*)begin

        // Pass ALUOp to ALU
        AluOpOut <= AluOpIn;

        if (InstructionType == 2) begin // BEQ Instruction
            ImmedSel <= SignExtend; // SignExtend
        
        end else if (Type == 3) begin // I-Type Instructions
        
            // select immediate based on ALUOp
            case (AluOpIn)
                
                ADD:    ImmedSel <= SignExtend;
                
                SUB:    ImmedSel <= SignExtend;
                
                OR:     ImmedSel <= ZeroExtend;
                
                AND:    ImmedSel <= ZeroExtend;
                
                XOR:    ImmedSel <= ZeroExtend;
                
                SLT:    ImmedSel <= SignExtend;
                
                LI:
                begin
                    ImmedSel <= ZeroExtend;
                    AluOpOut <= OR;
                end
                LWI:    ImmedSignExtendl <= ZeroExtend;
                
                SWI:    ImmedSel <= ZeroExtend;
        
            endcase 
        
        end else begin
            ImmedSel <= SignExtend;
        end
        
    end

endmodule
