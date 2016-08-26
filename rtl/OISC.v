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

  output reg                          SDRAMReadReady,
  input                               SDRAMReadValid,
  input      [`SRAMDataWidth-1:0]     SDRAMReadData,
  output reg [`SRAMAddrWidth-1:0]     SDRAMReadAddr,

  input                               SDRAMWriteReady,
  output reg                          SDRAMWriteValid,
  output reg [`SRAMDataWidth-1:0]     SDRAMWriteData,
  output reg [`SRAMAddrWidth-1:0]     SDRAMWriteAddr
);

reg [`PCRegWidth-1:0] PC;
reg [`GeneralPurposeRegWidth-1:0] GPR [`GeneralPurposeRegNum-1:0];
assign GPR[0] = 0;
reg [`HiLoRegsWidth-1:0] HI,LO;


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
  case (MoveDst)
  `BootCode,`PC: PC <= MoveSrc;
  `GPR0:
end

always @(posedge RST or posedge CLK) begin
  if (RST) begin
    
  end else if (Move) begin
    case ()
  end else
    
end

endmodule