// Generates control signals and ALU op for RV32I subset
module control(
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic       alusrc,    // 1 = imm, 0 = reg
    output logic       regwrite,
    output logic       memwrite,
    output logic       memread,
    output logic       branch,
    output logic [2:0] aluop      // 000=ADD,001=SUB,010=AND,011=OR
);
    always_comb begin
        // defaults
        alusrc   = 0; regwrite=0; memwrite=0; memread=0; branch=0; aluop=3'b000;
        unique case (opcode)
            7'b0110011: begin // R-type
                regwrite=1;
                unique case({funct7,funct3})
                    10'b0000000_000: aluop=3'b000; // ADD
                    10'b0100000_000: aluop=3'b001; // SUB
                    10'b0000000_111: aluop=3'b010; // AND
                    10'b0000000_110: aluop=3'b011; // OR
                    default:         aluop=3'b000;
                endcase
            end
            7'b0010011: begin // LUI/AUIPC treated as ADDI imm to PC handled outside
                alusrc=1; regwrite=1; aluop=3'b000;
            end
            7'b0000011: begin // LW
                alusrc=1; regwrite=1; memread=1; aluop=3'b000;
            end
            7'b0100011: begin // SW
                alusrc=1; memwrite=1; aluop=3'b000;
            end
            7'b1100011: begin // BEQ/BNE
                branch=1; aluop=3'b001; // SUB for comparison
            end
            7'b1101111: begin // JAL
                regwrite=1; branch=1; aluop=3'b000;
            end
            default: ;
        endcase
    end
endmodule
