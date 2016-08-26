`define InstructionWidth              = 64
`define SRAMDataWidth                 = 64
`define SRAMAddrWidth                 = 32
`define GeneralPurposeRegWidth        = 32
`define GeneralPurposeRegNum          = 32
`define PCRegWidth                    = `GeneralPurposeRegWidth
`define HiLoRegsWidth                 = `GeneralPurposeRegWidth



`define GPRAddrStart                  = 32'hxxxx


`define ADDAcc                        = 32'hxxxx


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