`timescale 1ns / 1ps



module ALU(AluOut, Zero, InputA, InputB, AluOp);
                

    output  reg [31:0] AluOut;
    output  reg Zero;
    input   [31:0]  InputA,InputB;
    input   [3:0]   AluOp;
    

    always @(AluOp,InputA,InputB) begin
    case (AluOp[2:0])
    3'h0: AluOut <= InputA;
    3'h1: AluOut <= ~InputA;
    3'h2: AluOut <= (InputA + InputB);
    3'h3: AluOut <= (InputA - InputB);
    3'h4: AluOut <= (InputA | InputB);
    3'h5: AluOut <= (InputA & InputB);
    3'h6: AluOut <= (InputA ^ InputB);
    3'h7: AluOut <= (($signed(InputA) < $signed(InputB))? 1:0); 
    endcase
    
    end
    
    always @(AluOut) begin
        if (AluOut == 0) begin
            Zero <= 1;
        end else begin
            Zero <= 0;
        end
    end

endmodule
