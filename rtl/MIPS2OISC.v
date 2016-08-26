`timescale 1ns/1ps
`include "defines.vh"

module MIPS2OISC (
  input                                   CLK,
  input                                   RST,

  output                                  InstructionInReady,
  input                                   InstructionInValid,
  input      [`MIPSInstructionWidth-1:0]  InstructionInData,

  input                                   InstructionOutReady,
  output                                  InstructionOutValid,
  output reg [`OISCInstructionWidth-1:0]  InstructionOutData
);

wire InstructionReceived    = InstructionInReady  & InstructionInValid;
wire InstructionSending     = InstructionOutReady & InstructionOutValid;
wire InstructionSent        = InstructionSending & (OISCInstCounter == OISCInstNum);
assign InstructionInReady   = ~InstrutionDecoding;
assign InstructionOutValid  = InstrutionDecoding;

reg                               InstrutionDecoding;
reg [`MIPSInstructionWidth  -1:0] MIPSInstruction;
reg [`OISCInstNumPerMipsInst-1:0] OISCInstCounter;

always @(posedge CLK or posedge RST) begin
  if (RST)
    InstrutionDecoding <= 1'b0;
  else if (InstructionReceived)
    InstrutionDecoding <= 1'b1;
  else if (InstructionSent)
    InstrutionDecoding <= 1'b0;
end

always @(posedge CLK or posedge RST) begin
  if (RST)
    MIPSInstruction <= 0;
  else if (InstructionReceived)
    MIPSInstruction <= InstructionInData;
end

reg [] OISCInstBase;
reg [] OISCAdderCtrl;
always @* case (MIPSInstruction[31:26],MIPSInstruction[5:0])


  32'b000000_?????_?????_?????_?????_001100: begin:SYSCALL
                                                          OISCInstBase = `;       OISCInstType = ;                          OISCAdderCtrl = ;                                                           end
  32'b000000_?????_?????_?????_?????_001101: begin:BREAK
                                                          OISCInstBase = `BREAK;  OISCInstType = ;                          OISCAdderCtrl = ;                                                           end


  32'b0100??_?????_?????_?????_?????_??????: begin:COPz
                                                          OISCInstBase = `;       OISCInstType = ;                          OISCAdderCtrl = ;               COPz              = MIPSInstruction[27:26]; end


  32'b000000_?????_?????_?????_00000_100100: begin:AND
                                                          OISCInstBase = `AND;    OISCInstType = `MIPS_3R_TypeSimple_Inst;                                                                              end
  32'b000000_?????_?????_?????_00000_100101: begin:OR
                                                          OISCInstBase = `OR;     OISCInstType = `MIPS_3R_TypeSimple_Inst;                                                                              end
  32'b000000_?????_?????_?????_00000_100111: begin:NOR
                                                          OISCInstBase = `NOR;    OISCInstType = `MIPS_3R_TypeSimple_Inst;                                                                              end
  32'b000000_?????_?????_?????_00000_100110: begin:XOR
                                                          OISCInstBase = `XOR;    OISCInstType = `MIPS_3R_TypeSimple_Inst;                                                                              end
  32'b001100_?????_?????_?????_?????_??????: begin:ANDI
                                                          OISCInstBase = `AND;    OISCInstType = `MIPS_2I_TypeSimple_Inst;                                                                              end
  32'b001101_?????_?????_?????_?????_??????: begin:ORI
                                                          OISCInstBase = `OR;     OISCInstType = `MIPS_2I_TypeSimple_Inst;                                                                              end
  32'b001110_?????_?????_?????_?????_??????: begin:XORI
                                                          OISCInstBase = `XOR;    OISCInstType = `MIPS_2I_TypeSimple_Inst;                                                                              end


  32'b000000_?????_?????_?????_00000_101010: begin:SLT
                                                          OISCInstBase = `SLT;    OISCInstType = `MIPS_2I_TypeSimple_Inst;                                                                              end
  32'b001010_?????_?????_?????_?????_??????: begin:SLTI
                                                          OISCInstBase = `SLT;    OISCInstType = `MIPS_2I_TypeSimple_Inst;                                                                              end
  32'b001011_?????_?????_?????_?????_??????: begin:SLTIU
                                                          OISCInstBase = `SLT;    OISCInstType = `MIPS_2I_TypeSimple_Inst;                                                                              end
  32'b000000_?????_?????_?????_00000_101011: begin:SLTU
                                                          OISCInstBase = `SLT;    OISCInstType = `MIPS_2I_TypeSimple_Inst;                                                                              end


  32'b000000_00000_?????_?????_?????_000000: begin:SLL
                                                          OISCInstBase = `SHIFT;  OISCInstType = `MIPS_2I_TypeWithCtrl_Inst; OISCCtrlType = `ShiftCtrl;      OISCSHIFTType         = 2'b10;             end//[0] - Arithmetic shift
  32'b000000_00000_?????_?????_?????_000010: begin:SRL
                                                          OISCInstBase = `SHIFT;  OISCInstType = `MIPS_2I_TypeWithCtrl_Inst; OISCCtrlType = `ShiftCtrl;      OISCShiftType         = 2'b00;             end//[1] - Shift to the left
  32'b000000_00000_?????_?????_?????_000011: begin:SRA
                                                          OISCInstBase = `SHIFT;  OISCInstType = `MIPS_2I_TypeWithCtrl_Inst; OISCCtrlType = `ShiftCtrl;      OISCShiftType         = 2'b01;             end
  32'b000000_?????_?????_?????_00000_000100: begin:SLLV
                                                          OISCInstBase = `SHIFT;  OISCInstType = `MIPS_3R_TypeShift_Inst;    OISCCtrlType = `ShiftCtrl;      OISCShiftType         = 2'b10;             end
  32'b000000_?????_?????_?????_00000_000110: begin:SRLV
                                                          OISCInstBase = `SHIFT;  OISCInstType = `MIPS_3R_TypeShift_Inst;    OISCCtrlType = `ShiftCtrl;      OISCShiftType         = 2'b00;             end
  32'b000000_?????_?????_?????_00000_000111: begin:SRAV
                                                          OISCInstBase = `SHIFT;  OISCInstType = `MIPS_3R_TypeShift_Inst;    OISCCtrlType = `ShiftCtrl;      OISCShiftType         = 2'b01;             end


  32'b000000_?????_?????_?????_00000_100000: begin:ADD
                                                          OISCInstBase = `ADD;    OISCInstType = `MIPS_3R_TypeWithOV_Inst;   OISCCtrlType = `AdderCtrl;      OISCAdderCtrl         = 2'b01;             end
  32'b000000_?????_?????_?????_00000_100001: begin:ADDU
                                                          OISCInstBase = `ADD;    OISCInstType = `MIPS_3R_TypeWithOV_Inst;   OISCCtrlType = `AdderCtrl;      OISCAdderCtrl         = 2'b00;             end
  32'b001000_?????_?????_?????_?????_??????: begin:ADDI
                                                          OISCInstBase = `ADD;    OISCInstType = `MIPS_2I_TypeWithCtrl_Inst; OISCCtrlType = `AdderCtrl;      OISCAdderCtrl         = 2'b01;             end
  32'b001001_?????_?????_?????_?????_??????: begin:ADDIU
                                                          OISCInstBase = `ADD;    OISCInstType = `MIPS_2I_TypeWithCtrl_Inst; OISCCtrlType = `AdderCtrl;      OISCAdderCtrl         = 2'b00;             end
  32'b000000_?????_?????_00000_00000_011010: begin:DIV
                                                          OISCInstBase = `DIV;    OISCInstType = `MIPS_2R_TypeInstHiLo;      OISCCtrlType = `DividerCtrl;    OISCDividerCtrl       = 1;                 end// Signed
  32'b000000_?????_?????_00000_00000_011011: begin:DIVU
                                                          OISCInstBase = `DIV;    OISCInstType = `MIPS_2R_TypeInstHiLo;      OISCCtrlType = `DividerCtrl;    OISCDividerCtrl       = 0;                 end
  32'b000000_?????_?????_00000_00000_011000: begin:MULT
                                                          OISCInstBase = `MULT;   OISCInstType = `MIPS_2R_TypeInstHiLo;      OISCCtrlType = `MultiplierCtrl; OISCMultiplierCtrl    = 1;                 end// Signed
  32'b000000_?????_?????_00000_00000_011001: begin:MULTU
                                                          OISCInstBase = `MULT;   OISCInstType = `MIPS_2R_TypeInstHiLo;      OISCCtrlType = `MultiplierCtrl; OISCMultiplierCtrl    = 0;                 end
  32'b000000_?????_?????_?????_00000_100010: begin:SUB
                                                          OISCInstBase = `ADD;    OISCInstType = `MIPS_3R_TypeWithOV_Inst;   OISCCtrlType = `AdderCtrl;      OISCAdderCtrl         = 2'b11;             end//[0] - OverFlow control
  32'b000000_?????_?????_?????_00000_100011: begin:SUBU
                                                          OISCInstBase = `ADD;    OISCInstType = `MIPS_3R_TypeWithOV_Inst;   OISCCtrlType = `AdderCtrl;      OISCAdderCtrl         = 2'b10;             end//[1] - Subtrac, convert second operand to 2's complement


  32'b001111_00000_?????_?????_?????_??????: begin:LUI
                                                          OISCInstBase = `LUI;    OISCInstType = ; OISCAdderCtrl   = ; end
  32'b000000_00000_00000_?????_00000_010000: begin:MFHI
                                                          OISCInstBase = `MOVE;   OISCInstType = `MIPS_1R_TypeMove_Inst;     OISCSourceAddr = `HI;           OISCDestinationAddr = OISCDestinationReg;  end
  32'b000000_00000_00000_?????_00000_010010: begin:MFLO
                                                          OISCInstBase = `MOVE;   OISCInstType = `MIPS_1R_TypeMove_Inst;     OISCSourceAddr = `LO;           OISCDestinationAddr = OISCDestinationReg;  end
  32'b000000_?????_00000_00000_00000_010001: begin:MTHI
                                                          OISCInstBase = `MOVE;   OISCInstType = `MIPS_1R_TypeMove_Inst;     OISCSourceAddr = OISCSourceReg; OISCDestinationAddr = `HI;                 end
  32'b000000_?????_00000_00000_00000_010011: begin:MTLO
                                                          OISCInstBase = `MOVE;   OISCInstType = `MIPS_1R_TypeMove_Inst;     OISCSourceAddr = OISCSourceReg; OISCDestinationAddr = `LO;                 end


  32'b000010_?????_?????_?????_?????_??????: begin:J
                                                          OISCInstBase = `JUMP;   OISCInstType = ; OISCAdderCtrl   = ; end
  32'b000011_?????_?????_?????_?????_??????: begin:JAL
                                                          OISCInstBase = `JUMP;   OISCInstType = ; OISCAdderCtrl   = ; end
  32'b000000_?????_00000_00000_00000_001000: begin:JR
                                                          OISCInstBase = `JUMP;   OISCInstType = ; OISCAdderCtrl   = ; end
  32'b000000_?????_00000_?????_00000_001001: begin:JALR
                                                          OISCInstBase = `JUMP;   OISCInstType = ; OISCAdderCtrl   = ; end


  32'b100000_?????_?????_?????_?????_??????: begin:LB
                                                          OISCInstBase = `LOAD;   OISCInstType = `MIPS_2R_TypeRAMAccess_Inst; OISCRAMAccessCtrl   = 5'b011_00; end//[1:0] - 2'b00-Byte,2'b01-HalfWord,2'b10-Word,2'b11-DoubleWord
  32'b100100_?????_?????_?????_?????_??????: begin:LBU
                                                          OISCInstBase = `LOAD;   OISCInstType = `MIPS_2R_TypeRAMAccess_Inst; OISCRAMAccessCtrl   = 5'b010_00; end//[2] - Signed
  32'b100001_?????_?????_?????_?????_??????: begin:LH
                                                          OISCInstBase = `LOAD;   OISCInstType = `MIPS_2R_TypeRAMAccess_Inst; OISCRAMAccessCtrl   = 5'b011_01; end//[3] - Alligned
  32'b100101_?????_?????_?????_?????_??????: begin:LHU
                                                          OISCInstBase = `LOAD;   OISCInstType = `MIPS_2R_TypeRAMAccess_Inst; OISCRAMAccessCtrl   = 5'b010_01; end//[4] - Place on the left (Most_segn_part) of the reg
  32'b100011_?????_?????_?????_?????_??????: begin:LW
                                                          OISCInstBase = `LOAD;   OISCInstType = `MIPS_2R_TypeRAMAccess_Inst; OISCRAMAccessCtrl   = 5'b010_01; end
  32'b100010_?????_?????_?????_?????_??????: begin:LWL
                                                          OISCInstBase = `LOAD;   OISCInstType = `MIPS_2R_TypeRAMAccess_Inst; OISCRAMAccessCtrl   = 5'b101_01; end
  32'b100110_?????_?????_?????_?????_??????: begin:LWR
                                                          OISCInstBase = `LOAD;   OISCInstType = `MIPS_2R_TypeRAMAccess_Inst; OISCRAMAccessCtrl   = 5'b001_01; end
  32'b1100??_?????_?????_?????_?????_??????: begin:LWCz
                                                          OISCInstBase = `LOAD;   OISCInstType = ; OISCAdderCtrl   = ; COPz          = MIPSInstruction[27:26]; end
  32'b101000_?????_?????_?????_?????_??????: begin:SB
                                                          OISCInstBase = `STOR;   OISCInstType = `; OISCRAMAccessCtrl   = ; end
  32'b101001_?????_?????_?????_?????_??????: begin:SH
                                                          OISCInstBase = `STOR;   OISCInstType = `; OISCRAMAccessCtrl   = ; end
  32'b101011_?????_?????_?????_?????_??????: begin:SW
                                                          OISCInstBase = `STOR;   OISCInstType = `; OISCRAMAccessCtrl   = ; end
  32'b101010_?????_?????_?????_?????_??????: begin:SWL
                                                          OISCInstBase = `STOR;   OISCInstType = `; OISCRAMAccessCtrl   = ; end
  32'b101110_?????_?????_?????_?????_??????: begin:SWR
                                                          OISCInstBase = `STOR;   OISCInstType = `; OISCRAMAccessCtrl   = ; end
  32'b1110??_?????_?????_?????_?????_??????: begin:SWCz
                                                          OISCInstBase = `STOR;   OISCInstType = ; OISCAdderCtrl   = ; COPz          = MIPSInstruction[27:26]; end


  32'b000100_?????_?????_?????_?????_??????: begin:BEQ
                                                          OISCInstBase = `Branch; OISCInstType = ; OISCAdderCtrl   = ; end
  32'b000001_?????_00001_?????_?????_??????: begin:BGEZ
                                                          OISCInstBase = `Branch; OISCInstType = ; OISCAdderCtrl   = ; end
  32'b000001_?????_10001_?????_?????_??????: begin:BGEZAL
                                                          OISCInstBase = `Branch; OISCInstType = ; OISCAdderCtrl   = ; end
  32'b000111_?????_00000_?????_?????_??????: begin:BGTZ
                                                          OISCInstBase = `Branch; OISCInstType = ; OISCAdderCtrl   = ; end
  32'b000110_?????_00000_?????_?????_??????: begin:BLEZ
                                                          OISCInstBase = `Branch; OISCInstType = ; OISCAdderCtrl   = ; end
  32'b000001_?????_00000_?????_?????_??????: begin:BLTZ
                                                          OISCInstBase = `Branch; OISCInstType = ; OISCAdderCtrl   = ; end
  32'b000001_?????_10000_?????_?????_??????: begin:BLTZAL
                                                          OISCInstBase = `Branch; OISCInstType = ; OISCAdderCtrl   = ; end
  32'b000101_?????_?????_?????_?????_??????: begin:BNE
                                                          OISCInstBase = `Branch; OISCInstType = ; OISCAdderCtrl   = ; end
endcase

always @* case (OISCInstType)
//   `MIPS_0I_TypeInstruction:       OISCInstNum  =  `MIPS_0I_TypeOISCIntsNum;
//   `MIPS_1I_TypeInstruction:       OISCInstNum  =  `MIPS_1I_TypeOISCIntsNum;
  `MIPS_2I_TypeSimple_Inst:         OISCInstNum  =  `MIPS_2I_TypeShift_OISCIntsNum;
  `MIPS_2I_TypeWithCtrl_Inst:       OISCInstNum  =  `MIPS_2I_TypeWithCtrl_OISCIntsNum;
  `MIPS_3R_TypeSimple_Inst:         OISCInstNum  =  `MIPS_3R_TypeSimple_OISCIntsNum;
  `MIPS_3R_TypeWithCtrl_Inst:       OISCInstNum  =  `MIPS_3R_TypeWithCtrl_OISCIntsNum;
//   `MIPS_3I_TypeInstruction:       OISCInstNum  =  `MIPS_3I_TypeOISCIntsNum;
//   `MIPS_4R_TypeInstruction:       OISCInstNum  =  `MIPS_4R_TypeOISCIntsNum;
//   `MIPS_ComplexI_TypeInstruction: OISCInstNum  =  `MIPS_ComplexI_TypeOISCIntsNum;
//   `MIPS_J_TypeInstruction:        OISCInstNum  =  `MIPS_J_TypeOISCIntsNum;
endcase

wire []MIPSSourceReg      = MIPSInstruction[25:21];
wire []MIPSTempReg        = MIPSInstruction[20:16];
wire []MIPSDestinationReg = MIPSInstruction[15:11];
wire []MIPS16Imm          = MIPSInstruction[15:0];
wire []MIPSShiftAmount    = MIPSInstruction[10:6];

wire []OISCSourceReg      = `GPRAddrStart+MIPSSourceReg;
wire []OISCTempReg        = `GPRAddrStart+MIPSTempReg;
wire []OISCDestinationReg = `GPRAddrStart+MIPSDestinationReg;
wire []OISCImm            = `IMM;

wire []OISCInstPointer    = OISCInstBase+OISCInstCounter
wire []OISCInstStep       = OISCInstType+OISCInstCounter;
wire []OISCAccumulator    = OISCInstBase;
wire []OISCSecondOperand  = OISCInstBase+1;
wire []OISCCtrlOperand    = OISCInstBase+2;
wire []OISCUnitCtrl;

always @* case (OISCCtrlType)
  `AdderCtrl      : OISCUnitCtrl = OISCAdderCtrl;
  `ShiftCtrl      : OISCUnitCtrl = OISCShiftType;
  `DividerCtrl    : OISCUnitCtrl = OISCDividerCtrl;
  `MultiplierCtrl : OISCUnitCtrl = OISCDividerCtrl;
endcase

always @* case (OISCInstStep)
  //MFHI,MFLO,MTHI,MTLO
  `MIPS_1R_TypeMove_Inst        :    OISCInstruction = {   OISCSourceAddr   ,   OISCDestinationAddr   };
  //
  `MIPS_2R_TypeRAMAccess_Inst   :    OISCInstruction = {   MIPSSourceReg    ,   `OISCMMUBase          };
  `MIPS_2R_TypeRAMAccess_Inst +1:    OISCInstruction = {   MIPS16Imm        ,   `OISCMMUOffset        };
  `MIPS_2R_TypeRAMAccess_Inst +2:    OISCInstruction = {   OISCRAMAccessCtrl,   `OISCMMUAccessCtrl    };
  `MIPS_2R_TypeRAMAccess_Inst +3:    OISCInstruction = {   `OISCMMUReadData ,   OISCTempReg           };
  //AND,OR,XOR,NOR
  `MIPS_3R_TypeSimple_Inst      :    OISCInstruction = {   OISCSourceReg    ,   OISCAccumulator       };
  `MIPS_3R_TypeSimple_Inst    +1:    OISCInstruction = {   OISCTempReg      ,   OISCSecondOperand     };
  `MIPS_3R_TypeSimple_Inst    +2:    OISCInstruction = {   OISCAccumulator  ,   OISCDestinationReg    };
  //ANDI,ORI,XORI
  `MIPS_2I_TypeSimple_Inst      :    OISCInstruction = {   OISCSourceReg    ,   OISCAccumulator       };
  `MIPS_2I_TypeSimple_Inst    +1:    OISCInstruction = {   MIPS16Imm        ,   OISCImm               };//Make immediate
  `MIPS_2I_TypeSimple_Inst    +2:    OISCInstruction = {   OISCImm          ,   OISCSecondOperand     };
  `MIPS_2I_TypeSimple_Inst    +3:    OISCInstruction = {   OISCAccumulator  ,   OISCTempReg           };
  //ADD,ADDU,AND,SLLV,SRAV,SRLV
  `MIPS_3R_TypeWithCtrl_Inst    :    OISCInstruction = {   OISCSourceReg    ,   OISCAccumulator       };
  `MIPS_3R_TypeWithCtrl_Inst  +1:    OISCInstruction = {   OISCTempReg      ,   OISCSecondOperand     };
  `MIPS_3R_TypeWithCtrl_Inst  +2:    OISCInstruction = {   OISCUnitCtrl     ,   OISCCtrlOperand       };
  `MIPS_3R_TypeWithCtrl_Inst  +3:    OISCInstruction = {   OISCAccumulator  ,   OISCDestinationReg    };
  //ADDI,ADDIU,ANDI,SLL,SRA,SRL
  `MIPS_2I_TypeWithCtrl_Inst    :    OISCInstruction = {   OISCSourceReg    ,   OISCAccumulator       };
  `MIPS_2I_TypeWithCtrl_Inst  +1:    OISCInstruction = {   MIPS16Imm        ,   OISCImm               };//Make immediate
  `MIPS_2I_TypeWithCtrl_Inst  +2:    OISCInstruction = {   OISCImm          ,   OISCSecondOperand     };
  `MIPS_2I_TypeWithCtrl_Inst  +3:    OISCInstruction = {   OISCUnitCtrl     ,   OISCCtrlOperand       };
  `MIPS_2I_TypeWithCtrl_Inst  +4:    OISCInstruction = {   OISCAccumulator  ,   OISCTempReg           };
endcase

always @(posedge CLK or posedge RST) begin
  if (RST)
    OISCInstCounter <= 0;
  else if (InstructionReceived)
    OISCInstCounter <= 0;
  else if (InstructionSending)
    OISCInstCounter <= OISCInstCounter + 1;
end

always @(posedge CLK) InstructionOutData <= OISCInstruction;

endmodule