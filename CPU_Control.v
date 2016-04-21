`timescale 1ns / 1ps

module CPU_Control(SystemState, PCSource, PCWrite, BEQcontrol, BNEcontrol, AluOp, AluSrcA, AluSrcB, IRWrite, RFWrite, MDRWrite, DMemWrite, MemToReg, ImmedAddr, ReadDataSrc1, ReadDataSrc2, Opcode, Clk, Reset);
     




    // Important Definitions
     parameter  NOP = 6'b000000;
     parameter  J   = 6'b000001;
     parameter  BEQ = 6'b100000;
     parameter  BNW = 6'b100001;
     parameter  LWI = 6'b111011;
     parameter  SWI = 6'b111100;
     parameter  LI  = 6'b111001;
     parameter  OPsize = 6;
     parameter  ALUsize = 4;

    
     parameter  InstrFetch  = 4'b0000;
     parameter  InstrDecode  = 4'b0001;
     parameter  RTYPECompletion = 4'b0010;
     parameter  WriteBack  = 4'b0011;
     parameter  ITYPECompletion = 4'b0100;
     parameter  BEQCompletion = 4'b0101;
	 parameter  BNECompletion = 4'b0110;
     parameter  JumpCompletion = 4'b0111;
     parameter  MemoryLoadImmediate = 4'b1000;
     parameter  MemoryWriteBack = 4'b1001;
     parameter  MemoryStoreImmediate = 4'b1010;
     parameter  MemoryWriteEnable  = 4'b1011;

     
   
    output      [3:0] SystemState;
    output reg  PCSource;
    output reg  PCWrite;
    output reg  BEQcontrol;
	output reg  BNEcontrol;
    output reg  [ALUsize-1:0] AluOp;
    output reg  AluSrcA;
    output reg  [1:0] AluSrcB;
    output reg  IRWrite;
    output reg  RFWrite;
    output reg  MDRWrite;
    output reg  DMemWrite;
    output reg  MemToReg;
    output reg  ImmedAddr;
    output reg  ReadDataSrc1;
    output reg  ReadDataSrc2;
    
    // ----- INPUTS ----- //
    input [OPsize-1:0] Opcode;
    input Clk, Reset;
    
    // ----- STATE REGISTERS ----- //
    reg [4-1:0] state,nextstate;
    
    // ***************************************************** //
    // * STATE MACHINE                                     * //
    // ***************************************************** //
    
    assign SystemState = state; // Test
    
    // Reset logic
    always @(posedge Reset) begin
        if (Reset) begin
            nextstate <= InstrFetch;
        end
    end
    
    always @(posedge Clk) begin
        state <= nextstate;
    end
    
    always @(state) begin
        
        // next-state logic
        case (state)
        InstrFetch: nextstate <= InstrDecode;
        InstrDecode: if (Opcode == NOP) begin
                    nextstate <= InstrFetch;
                end else if (Opcode == BEQ) begin
                    nextstate <= BEQCompletion;
					 end else if (Opcode == BNE) begin
							nextstate <= BNECompletion;
                end else if (Opcode == J) begin
                    nextstate <= JumpCompletion;   
                end else if (Opcode == LWI) begin
                    nextstate <= MemoryLoadImmediate;   
                end else if (Opcode == SWI) begin
                    nextstate <= MemoryStoreImmediate;
                end else if (Opcode[5:4] == 2'b11) begin
                    nextstate <= ITYPECompletion; // I-Type
                end else begin
                    nextstate <= RTYPECompletion; // R-Type
                end         
        RTYPECompletion:    nextstate <= WriteBack;
        WriteBack:     nextstate <= InstrFetch;
        ITYPECompletion:    nextstate <= WriteBack;
        BEQCompletion:    nextstate <= InstrFetch;
		BNECompletion:    nextstate <= InstrFetch;
        JumpCompletion:    nextstate <= InstrFetch;    
        MemoryLoadImmediate:    nextstate <= MemoryWriteBack;   
        MemoryWriteBack:    nextstate <= InstrFetch;
        MemoryStoreImmediate:    nextstate <= MemoryWriteEnable;
        MemoryWriteEnable:     nextstate <= InstrFetch;
        endcase
    end
    

    
    always @(state) begin
        
        case (state)

        InstrFetch:
        begin
            // control signals
            PCSource    <= 0;
            PCWrite     <= 1;
            BEQcontrol  <= 0;
				BNEcontrol  <= 0;
            AluOp       <= 4'b0010; // ADD for PC + 1
            AluSrcA     <= 0;       // PC
            AluSrcB     <= 0;       // +1
            IRWrite     <= 1;
            RFWrite     <= 0;
            MDRWrite    <= 0;
            DMemWrite   <= 0;
            MemToReg    <= 0; // dont care
            ImmedAddr   <= 0; // dont care
            ReadDataSrc1<= 1; // dont care
            ReadDataSrc2<= 1; // dont care
        end
        
        InstrDecode:
        begin
            // control signals
            PCSource    <= 0;
            PCWrite     <= 0;
            BEQcontrol  <= 0;
				BNEcontrol  <= 0;
            AluOp       <= 4'b0010; // ADD for PC + Target
            AluSrcA     <= 0;       // (PC+1)
            AluSrcB     <= 3;       // + Branch Target (16-bit SE)
            IRWrite     <= 0;
            RFWrite     <= 0;
            MDRWrite    <= 0;
            DMemWrite   <= 0;
            MemToReg    <= 0; // dc
            ImmedAddr   <= 0; // dc
            ReadDataSrc1<= 1;
            ReadDataSrc2<= 1;
            

            if (Opcode == BEQ || Opcode == BNE) begin
                ReadDataSrc1 <= 0;
                ReadDataSrc2 <= 0;
            end else if (Opcode == J) begin
                AluSrcB <= 2;
            end else if (Opcode == LUI || Opcode == LI) begin
                ReadDataSrc1 <= 0;
            end
        end
            
          
        RTYPECompletion:
        begin

            PCSource    <= 0;
            PCWrite     <= 0;
            BEQcontrol  <= 0;
			BNEcontrol  <= 0;
            AluOp       <= Opcode[3:0];
            AluSrcA     <= 1;
            AluSrcB     <= 1;
            IRWrite     <= 0;
            RFWrite     <= 0;
            MDRWrite    <= 0;
            DMemWrite   <= 0;
            MemToReg    <= 0;
            ImmedAddr   <= 0;
            ReadDataSrc1<= 1;
            ReadDataSrc2<= 1;
        end
        

        WriteBack:
        begin
            PCSource    <= 0;
            PCWrite     <= 0;
            BEQcontrol  <= 0;
		  BNEcontrol    <= 0;
            AluOp       <= 0;
            AluSrcA     <= 1;
            AluSrcB     <= 1;
            IRWrite     <= 0;
            RFWrite     <= 1;
            MDRWrite    <= 0;
            DMemWrite   <= 0;
            MemToReg    <= 0;
            ImmedAddr   <= 0;
            ReadDataSrc1<= 1;
            ReadDataSrc2<= 1;
        end

        ITYPECompletion:
        begin
            PCSource    <= 0;
            PCWrite     <= 0;
            BEQcontrol  <= 0;
			BNEcontrol  <= 0;
            AluOp       <= Opcode[3:0];
            AluSrcA     <= 1;
            AluSrcB     <= 3;
            IRWrite     <= 0;
            RFWrite     <= 0;
            MDRWrite    <= 0;
            DMemWrite   <= 0;
            MemToReg    <= 0;
            ImmedAddr   <= 0;
            ReadDataSrc1<= 1;
            ReadDataSrc2<= 1;
        end
            

        BEQCompletion:
        begin
            PCSource    <= 1;
            PCWrite     <= 0;
            BEQcontrol  <= 1;
			BNEcontrol  <= 0;
            AluOp       <= 4'b0011;
            AluSrcA     <= 1;
            AluSrcB     <= 1;
            IRWrite     <= 0;
            RFWrite     <= 0;
            MDRWrite    <= 0;
            DMemWrite   <= 0;
            MemToReg    <= 0;
            ImmedAddr   <= 0;
            ReadDataSrc1<= 1;
            ReadDataSrc2<= 1;
        end
		  
		  BNECompletion:
		  begin
				PCSource   <= 1;
				PCWrite    <= 0;
				BEQcontrol <= 0;
				BNEcontrol <= 1;
				AluOp      <= 4'b0011;
				AluSrcA    <= 1;
				AluSrcB    <= 1;
				RFWrite    <= 0;
				MDRWrite   <= 0;
				DMemWrite  <= 0;
				MemToReg   <= 0;
				ImmedAddr  <= 0;
				ReadDataSrc1<= 1;
				ReadDataSrc2<= 1;
		  end
		  
        
        JumpCompletion:
        begin
            PCSource    <= 1;
            PCWrite     <= 1;
            BEQcontrol  <= 0;
			BNEcontrol  <= 0;
            AluOp       <= 0;
            AluSrcA     <= 0;
            AluSrcB     <= 0;
            IRWrite     <= 0;
            RFWrite     <= 0;
            MDRWrite    <= 0;
            DMemWrite   <= 0;
            MemToReg    <= 0;
            ImmedAddr   <= 0;
            ReadDataSrc1<= 1;
            ReadDataSrc2<= 1;
        end
        

        MemoryLoadImmediate:
        begin
            PCSource    <= 0;
            PCWrite     <= 0;
            BEQcontrol  <= 0;
			BNEcontrol  <= 0;
            AluOp       <= 0;
            AluSrcA     <= 0;
            AluSrcB     <= 0;
            IRWrite     <= 0;
            RFWrite     <= 0;
            MDRWrite    <= 1;
            DMemWrite   <= 0;
            MemToReg    <= 0;
            ImmedAddr   <= 0;
            ReadDataSrc1<= 1;
            ReadDataSrc2<= 1;
        end
            

        MemoryWriteBack:
        begin
            // control signals
            PCSource    <= 0;
            PCWrite     <= 0;
            BEQcontrol  <= 0;
			BNEcontrol  <= 0;
            AluOp       <= 0;
            AluSrcA     <= 0;
            AluSrcB     <= 0;
            IRWrite     <= 0;
            RFWrite     <= 1;
            MDRWrite    <= 0;
            DMemWrite   <= 0;
            MemToReg    <= 1;
            ImmedAddr   <= 0;
            ReadDataSrc1<= 1;
            ReadDataSrc2<= 1;
        end
            

        MemoryStoreImmediate:
        begin
            PCSource    <= 0;
            PCWrite     <= 0;
            BEQcontrol  <= 0;
			BNEcontrol  <= 0;
            AluOp       <= 0;
            AluSrcA     <= 0;
            AluSrcB     <= 0;
            IRWrite     <= 0;
            RFWrite     <= 0;
            MDRWrite    <= 0;
            DMemWrite   <= 0;
            MemToReg    <= 0;
            ImmedAddr   <= 0;
            ReadDataSrc1<= 0;
            ReadDataSrc2<= 1;
        end
            

        MemoryWriteEnable:
        begin

            PCSource    <= 0;
            PCWrite     <= 0;
            BEQcontrol  <= 0;
			BNEcontrol  <= 0;
            AluOp       <= 0;
            AluSrcA     <= 0;
            AluSrcB     <= 0;
            IRWrite     <= 0;
            RFWrite     <= 0;
            MDRWrite    <= 0;
            DMemWrite   <= 1;
            MemToReg    <= 0;
            ImmedAddr   <= 0;
            ReadDataSrc1<= 0;
            ReadDataSrc2<= 1;
        end
        endcase
    end

endmodule
