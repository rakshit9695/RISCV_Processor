module IF_IDstage(
    input  logic        clk, rst,
    input  logic [31:0] pc_in, instr_in,
    output logic [31:0] pc_out, instr_out
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out    <= 0;
            instr_out <= 32'h0000_0013; // NOP = ADDI x0,x0,0
        end else begin
            pc_out    <= pc_in;
            instr_out <= instr_in;
        end
    end
endmodule
