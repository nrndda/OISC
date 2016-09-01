`define InstructionWidth              = 64
`define SRAMDataWidth                 = 64
`define SRAMAddrWidth                 = 32
`define GeneralPurposeRegWidth        = 32
`define GeneralPurposeRegLogNum       = 5
`define GeneralPurposeRegNum          = 1 << GeneralPurposeRegLogNum
`define PCRegWidth                    = `GeneralPurposeRegWidth
`define HiLoRegsWidth                 = `GeneralPurposeRegWidth


`define MIPS_3R_TypeInstruction       = 1
`define MIPS_3R_TypeOISCIntsNum       = 4
`define MIPS_3R_TypeInstShift         = `MIPS_3R_TypeInstruction        + `MIPS_3R_TypeOISCIntsNum
`define MIPS_3R_TypeShiftOISCIntsNum  = 4
`define MIPS_4R_TypeInstruction       = `MIPS_3R_TypeInstShift          + `MIPS_3R_TypeShiftOISCIntsNum
`define MIPS_4R_TypeOISCIntsNum       = 
`define MIPS_0I_TypeInstruction       = `MIPS_4R_TypeInstruction        + `MIPS_4R_TypeOISCIntsNum
`define MIPS_0I_TypeOISCIntsNum       = 
`define MIPS_1I_TypeInstruction       = `MIPS_0I_TypeInstruction        + `MIPS_0I_TypeOISCIntsNum
`define MIPS_1I_TypeOISCIntsNum       = 
`define MIPS_2I_TypeInstruction       = `MIPS_1I_TypeInstruction        + `MIPS_1I_TypeOISCIntsNum
`define MIPS_2I_TypeOISCIntsNum       = 5
`define MIPS_2I_TypeInstShift         = `MIPS_2I_TypeInstruction        + `MIPS_2I_TypeOISCIntsNum
`define MIPS_2I_TypeShiftOISCIntsNum  = 4
`define MIPS_3I_TypeInstruction       = `MIPS_2I_TypeInstShift          + `MIPS_2I_TypeShiftOISCIntsNum
`define MIPS_3I_TypeOISCIntsNum       = 
`define MIPS_ComplexI_TypeInstruction = `MIPS_3I_TypeInstruction        + `MIPS_3I_TypeOISCIntsNum
`define MIPS_ComplexI_TypeOISCIntsNum = 
`define MIPS_J_TypeInstruction        = `MIPS_ComplexI_TypeInstruction  + `MIPS_ComplexI_TypeOISCIntsNum
`define MIPS_J_TypeOISCIntsNum        = 


`define MIPS_Off26Instruction         = MIPS_0I_TypeInstruction
`define MIPS_Off21Instruction         = MIPS_1I_TypeInstruction
`define MIPS_Imm16Instruction         = MIPS_2I_TypeInstruction
`define MIPS_Off11Instruction         = MIPS_3I_TypeInstruction
`define MIPS_Off9Instruction          = MIPS_ComplexI_TypeInstruction



`define OISC_BOOT                     = 32'h0000_0000
`define OISC_PC                       = 32'h0000_0010

`define OISC_Imm                      = 32'h0000_0020

`define OISC_Hi                       = 32'h0000_0030
`define OISC_Lo                       = 32'h0000_0031

`define OISC_GPRRegsStart             = 32'h0000_0100
`define OISC_GPRRegsEnd               = `OISC_GPRRegsStart + `GeneralPurposeRegNum
`define OISC_GPRRegExp                = {`OISC_GPRRegsStart >> `GeneralPurposeRegLogNum,{GeneralPurposeRegLogNum{1'b?}}}

`define OISC_MMUBase                  = 32'h0000_0200
`define OISC_MMUOffset                = 32'h0000_0201
`define OISC_MMUWriteData             = 32'h0000_0202
`define OISC_MMUReadData              = 32'h0000_0203
`define OISC_MMUAccessCtrl            = 32'h0000_0204

`define OISC_OBFFOp                   = 32'h0000_0210
`define OISC_OBFCtrl                  = 32'h0000_0211
`define OISC_OBFRes                   = 32'h0000_0212

`define OISC_MUBFOp                   = 32'h0000_0220
`define OISC_MUBRes                   = 32'h0000_0221
`define OISC_MUHFOp                   = 32'h0000_0222
`define OISC_MUHRes                   = 32'h0000_0223

`define OISC_AndFOp                   = 32'h0000_0230
`define OISC_AndSOp                   = 32'h0000_0231
`define OISC_AndRes                   = 32'h0000_0232
`define OISC_OrFOp                    = 32'h0000_0233
`define OISC_OrSOp                    = 32'h0000_0234
`define OISC_OrRes                    = 32'h0000_0235
`define OISC_XOrFOp                   = 32'h0000_0236
`define OISC_XOrSOp                   = 32'h0000_0237
`define OISC_XOrRes                   = 32'h0000_0238
`define OISC_NOrFOp                   = 32'h0000_0239
`define OISC_NOrSOp                   = 32'h0000_023A
`define OISC_NOrRes                   = 32'h0000_023B

`define OISC_SLTFOp                   = 32'h0000_0240
`define OISC_SLTSOp                   = 32'h0000_0241
`define OISC_SLTCtrl                  = 32'h0000_0242
`define OISC_SLTRes                   = 32'h0000_0243

`define OISC_ShiftFOp                 = 32'h0000_0250
`define OISC_ShiftSOp                 = 32'h0000_0251
`define OISC_ShiftCtrl                = 32'h0000_0252
`define OISC_ShiftRes                 = 32'h0000_0253

`define OISC_AddFOp                   = 32'h0000_0260
`define OISC_AddSOp                   = 32'h0000_0261
`define OISC_AddCtrl                  = 32'h0000_0262
`define OISC_AddRes                   = 32'h0000_0263

`define OISC_MultFOp                  = 32'h0000_0270
`define OISC_MultSOp                  = 32'h0000_0271
`define OISC_MultCtrl                 = 32'h0000_0272
`define OISC_MultResHi                = 32'h0000_0273
`define OISC_MultResLo                = 32'h0000_0274

`define OISC_DivFOp                   = 32'h0000_0280
`define OISC_DivSOp                   = 32'h0000_0281
`define OISC_DivCtrl                  = 32'h0000_0282
`define OISC_DivResHi                 = 32'h0000_0283
`define OISC_DivResLo                 = 32'h0000_0284
