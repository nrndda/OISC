`timescale 1ns/1ps
`include "defines.vh"

module OISC (
  input                               CLK,
  input                               RST,

  input                               Start,
  input                               Reset,

  output reg                          InstructionReadReady,
  input                               InstructionReadValid,
  input      [`InstructionWidth-1:0]  InstructionReadData,

  output reg                          MMUAccessValid,
  input                               MMUAccessReady,
  output reg [`GPRWidth-1:0]          MMUBase,
  output reg [`GPRWidth-1:0]          MMUOffset,
  output reg [`GPRWidth-1:0]          MMUWriteData,
  output reg                          MMUAccessCtrl,

  input                               MMUReadValid,
  output reg                          MMUReadReady,
  input      [`GPRWidth-1:0]          MMUReadData
);

reg [`PCRegWidth-1:0] PC;
reg [`GPRWidth-1:0] GPR [`GPRNum-1:0];
assign GPR[0] = 0;
reg [`HiLoRegsWidth-1:0] Hi,Lo;
reg [`OISC_ImmRegWidth-1:0] Imm;

wire [`GPRWidth-1:0] MoveComm;


reg [`InstructionWidth/2-1:0] MoveSrc,MoveDst;
wire InstructionReceived = InstructionReadReady & InstructionReadValid;
always @(posedge RST or posedge CLK) begin
  if (RST) begin
    MoveSrc <= 0;
    MoveDst <= 0;
    Move    <= 0;
  end else if (InstructionReceived) begin
    MoveSrc <= InstructionReadData[`InstructionWidth-1:`InstructionWidth/2];
    MoveDst <= InstructionReadData[`InstructionWidth/2-1:0];
    Move    <= 1'b1;
  end else
    Move    <= 1'b0;
end

always @* begin
  case (MoveSrc)
  `OISC_PC                  : MoveComm              = PC;
  `OISC_RAM                 : MoveComm              = MoveSrc;
  `OISC_GPRRegExp           : MoveComm              = GPR[MoveDst[4:0]];

  `OISC_Hi                  : MoveComm              = Hi;
  `OISC_Lo                  : MoveComm              = Lo;

  `OISC_Imm                 : MoveComm              = Imm;

  `OISC_MMUBase             : MoveComm              = MMUBase;
  `OISC_MMUOffset           : MoveComm              = MMUOffset;//NOTE Don't calculate full address here in order to get address overflow in MMU.
  `OISC_MMUWriteData        : MoveComm              = MMUWriteData;
  `OISC_MMUReadData         : MoveComm              = MMUReadData;
  `OISC_MMUAccessCtrl       : MoveComm              = MMUAccessCtrl;

  `OISC_OBFFOp              : MoveComm              = OBFFOp;
  `OISC_OBFCtrl             : MoveComm              = OBFCtrl;
  `OISC_OBFRes              : MoveComm              = OBFRes;

  `OISC_MUBFOp              : MoveComm              = MUBFOp;
  `OISC_MUHFOp              : MoveComm              = MUHFOp;
  `OISC_MUBRes              : MoveComm              = MUBRes;
  `OISC_MUHRes              : MoveComm              = MUHRes;

  `OISC_AndFOp              : MoveComm              = AndFOp;
  `OISC_OrFOp               : MoveComm              =  OrFOp;
  `OISC_XOrFOp              : MoveComm              = XOrFOp;
  `OISC_NOrFOp              : MoveComm              = NOrFOp;
  `OISC_AndSOp              : MoveComm              = AndSOp;
  `OISC_OrSOp               : MoveComm              =  OrSOp;
  `OISC_XOrSOp              : MoveComm              = XOrSOp;
  `OISC_NOrSOp              : MoveComm              = NOrSOp;
  `OISC_AndRes              : MoveComm              = AndRes;
  `OISC_OrRes               : MoveComm              =  OrRes;
  `OISC_XOrRes              : MoveComm              = XOrRes;
  `OISC_NOrRes              : MoveComm              = NOrRes;

  `OISC_SLTFOp              : MoveComm              = SLTFOp;
  `OISC_SLTSOp              : MoveComm              = SLTSOp;
  `OISC_SLTCtrl             : MoveComm              = SLTCtrl;
  `OISC_SLTRes              : MoveComm              = SLTRes;

  `OISC_ShiftFOp            : MoveComm              = ShiftFOp;
  `OISC_ShiftSOp            : MoveComm              = ShiftSOp;
  `OISC_ShiftCtrl           : MoveComm              = ShiftCtrl;
  `OISC_ShiftRes            : MoveComm              = ShiftRes;

  `OISC_AddFOp              : MoveComm              = AddFOp;
  `OISC_AddSOp              : MoveComm              = AddSOp;
  `OISC_AddCtrl             : MoveComm              = AddCtrl;
  `OISC_AddRes              : MoveComm              = AddRes;

  `OISC_MultFOp             : MoveComm              = MultFOp;
  `OISC_MultSOp             : MoveComm              = MultSOp;
  `OISC_MultCtrl            : MoveComm              = MultCtrl;
  `OISC_MultResHi           : MoveComm              = MultResHi;
  `OISC_MultResLo           : MoveComm              = MultResLo;

  `OISC_DivFOp              : MoveComm              = DivFOp;
  `OISC_DivSOp              : MoveComm              = DivSOp;
  `OISC_DivCtrl             : MoveComm              = DivCtrl;
  `OISC_DivResHi            : MoveComm              = DivResHi;
  `OISC_DivResLo            : MoveComm              = DivResLo;
end

always @* begin
  case (MoveDst)
  `OISC_BootCode,`OISC_PC   : PC                    = MoveComm;
  `OISC_GPRRegExp           : GPR[MoveDst[4:0]]     = /*TODO I've need te read it first*/;

  `OISC_Hi                  : Hi                    = MoveComm;
  `OISC_Lo                  : Lo                    = MoveComm;

  `OISC_Imm                 : Imm                   = MoveComm;//TODO Sign-extend

  `OISC_MMUBase             : MMUBase               = MoveComm;
  `OISC_MMUOffset           : MMUOffset             = MoveComm;
  `OISC_MMUWriteData        : MMUWriteData          = MoveComm;//NOTE We can write here value and then rewrite from RAM only part of it or vise versa.
  `OISC_MMUReadData         : MMUReadData           = MoveComm;
  `OISC_MMUAccessCtrl       : MMUAccessCtrl         = MoveComm;

  `OISC_OBFFOp              : OBFFOp                = MoveComm;
  `OISC_OBFCtrl             : OBFCtrl               = MoveComm;
  `OISC_OBFRes              : OBFRes                = MoveComm;

  `OISC_MUBFOp              : MUBFOp                = MoveComm;
  `OISC_MUHFOp              : MUHFOp                = MoveComm;
  `OISC_MUBRes              : MUBRes                = MoveComm;
  `OISC_MUHRes              : MUHRes                = MoveComm;

  `OISC_AndFOp              : AndFOp                = MoveComm;
  `OISC_OrFOp               :  OrFOp                = MoveComm;
  `OISC_XOrFOp              : XOrFOp                = MoveComm;
  `OISC_NOrFOp              : NOrFOp                = MoveComm;
  `OISC_AndSOp              : AndSOp                = MoveComm;
  `OISC_OrSOp               :  OrSOp                = MoveComm;
  `OISC_XOrSOp              : XOrSOp                = MoveComm;
  `OISC_NOrSOp              : NOrSOp                = MoveComm;
  `OISC_AndRes              : AndRes                = MoveComm;
  `OISC_OrRes               :  OrRes                = MoveComm;
  `OISC_XOrRes              : XOrRes                = MoveComm;
  `OISC_NOrRes              : NOrRes                = MoveComm;

  `OISC_SLTFOp              : SLTFOp                = MoveComm;
  `OISC_SLTSOp              : SLTSOp                = MoveComm;
  `OISC_SLTCtrl             : SLTCtrl               = MoveComm;
  `OISC_SLTRes              : SLTRes                = MoveComm;

  `OISC_ShiftFOp            : ShiftFOp              = MoveComm;
  `OISC_ShiftSOp            : ShiftSOp              = MoveComm;
  `OISC_ShiftCtrl           : ShiftCtrl             = MoveComm;
  `OISC_ShiftRes            : ShiftRes              = MoveComm;

  `OISC_AddFOp              : AddFOp                = MoveComm;
  `OISC_AddSOp              : AddSOp                = MoveComm;
  `OISC_AddCtrl             : AddCtrl               = MoveComm;
  `OISC_AddRes              : AddRes                = MoveComm;

  `OISC_MultFOp             : MultFOp               = MoveComm;
  `OISC_MultSOp             : MultSOp               = MoveComm;
  `OISC_MultCtrl            : MultCtrl              = MoveComm;
  `OISC_MultResHi           : MultResHi             = MoveComm;
  `OISC_MultResLo           : MultResLo             = MoveComm;

  `OISC_DivFOp              : DivFOp                = MoveComm;
  `OISC_DivSOp              : DivSOp                = MoveComm;
  `OISC_DivCtrl             : DivCtrl               = MoveComm;
  `OISC_DivResHi            : DivResHi              = MoveComm;
  `OISC_DivResLo            : DivResLo              = MoveComm;
end
always @(posedge CLK) begin
                              MUBRes               <= {MUBFOp[ 7:0],24'b0};// Move in Upper Byte
                              MUHRes               <= {MUHFOp[15:0],16'b0};// Move in Upper HalfWord
end

wire                          OBFBitNum             = OBFCtrl;
always @(posedge CLK)         OBFRes               <= {`GPRWidth{OBFFOp[OBFBitNum]}};// Fill with one bit
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------AND,OR,XOR,NOR*/
always @(posedge CLK) begin
                              AndRes               <=   AndFOp  & AndSOp;
                               OrRes               <=    OrFOp  |  OrSOp;
                              XOrRes               <=   XOrFOp  ^ XOrSOp;
                              NOrRes               <= ~(NOrFOp  | NOrSOp);
end
/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------SLT*/
wire                          SLTSigned             = SLTCtrl[0];
wire                          SLTSignsXOr           = SLTFOp[`GPRWidth-1]   ^ SLTSOp[`GPRWidth-1];
wire                          SLTExceptSigns        = SLTFOp[`GPRWidth-2:0] < SLTSOp[`GPRWidth-2:0];
wire                          SLTResComb            = SLTSigned   &  SLTFOp[`GPRWidth-1] & !SLTSOp[`GPRWidth-1] ||
                                                     !SLTSigned   & !SLTFOp[`GPRWidth-1] &  SLTSOp[`GPRWidth-1] ||
                                                     ~SLTSignsXOr &  SLTTemp;
always @(posedge CLK)         SLTRes               <= {{`GPRWidth-1{1'b0}},SLTResComb};// Extend with zeros.
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------SHIFT*/
wire                          ShiftArith            = ShiftCtrl[0];//Arithmetic shift
wire                          Shift2Left            = ShiftCtrl[1];//Shift to the left
always @(posedge CLK)         ShiftRes             <= ShiftArith ? (Shift2Left ? ShiftFOp <<< ShiftSOp : ShiftFOp >>> ShiftSOp):
                                                             (Shift2Left ? ShiftFOp <<  ShiftSOp : ShiftFOp >>  ShiftSOp);
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ADD*/
wire                          AddWithOV             = AddCtrl[0];//Enable OVerflow processing
wire                          Add2sComplement       = AddCtrl[1];//Convert second operand to 2's complement.
assign                        AddSOp2sComp          = Add2sComplement ? ~AddSOp : AddSOp;
assign                       {AddCarry,AddComb}     = Add2sComplement ? (AddFOp + AddSOp2sComp + 1) : AddFOp + AddSOp;//TODO Two additions
wire                          AddOVFlag             = AddWithOV & AddFOp[`GPRWidth-1] & AddSOp[`GPRWidth-1] & AddComb[`GPRWidth-1] & ;
always @(posedge CLK)        {AddOV,AddRes}        <= AddOVFlag ? {1'b1,AddFOp} : {1'b0,AddComb};/* If OV flags is enabled and there is overflow, then do not alter accumulator.*/
/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------MULT*/
wire                          MultSigned            = MultCtrl[0];
wire                          MultComb              = MultFOp[`GPRWidth-1:0] * MultSOp[`GPRWidth-1:0];//TODO Merge two mutipliers.
wire                          MultCombSigned        = MultFOp[`GPRWidth-2:0] * MultSOp[`GPRWidth-2:0];
always @(posedge CLK)        {MultResHi,MultResLo} <= MultSigned ? {MultSign,1'b0,MultCombSigned} : MultComb;
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------DIV*/
wire                          DivSigned             = DivCtrl[0];
wire                          DivSign               = DivFOp[`GPRWidth-1  ] ^ DivSOp[`GPRWidth-1  ];
wire                          DivComb               = DivFOp[`GPRWidth-1:0] / DivSOp[`GPRWidth-1:0];//TODO Merge two mutipliers.
wire                          DivCombSigned         = DivFOp[`GPRWidth-2:0] / DivSOp[`GPRWidth-2:0];
wire                          DivRemainder          = DivFOp[`GPRWidth-1:0] % DivSOp[`GPRWidth-1:0];
always @(posedge CLK)         DivResLo             <= DivSigned ? {DivSign,1'b0,DivCombSigned} : DivComb;
always @(posedge CLK)         DivResHi             <= DivRemainder;

endmodule
