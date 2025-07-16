module alu(
    input  logic [31:0] a, b,
    input  logic [2:0]  aluop,
    output logic [31:0] y,
    output logic        zero
);
    always_comb begin
        unique case(aluop)
            3'b000 : y = a + b;   // ADD
            3'b001 : y = a - b;   // SUB
            3'b010 : y = a & b;   // AND
            3'b011 : y = a | b;   // OR
            default: y = 32'hDEAD_BEEF;
        endcase
    end
    assign zero = (y == 0);
endmodule
