module ID_EXEstage(
    input  logic        clk, rst,
    // from ID
    input  logic [31:0] pc_id, imm_id,
    input  logic [31:0] rdata1_id, rdata2_id,
    input  logic [4:0]  rd_id,
    input  logic        alusrc_id, regwrite_id, memwrite_id, memread_id, branch_id,
    input  logic [2:0]  aluop_id,
    // to EXE
    output logic [31:0] pc_exe, imm_exe,
    output logic [31:0] rdata1_exe, rdata2_exe,
    output logic [4:0]  rd_exe,
    output logic        alusrc_exe, regwrite_exe, memwrite_exe, memread_exe, branch_exe,
    output logic [2:0]  aluop_exe
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_exe <= 0; imm_exe<=0; rdata1_exe<=0; rdata2_exe<=0; rd_exe<=0;
            alusrc_exe<=0; regwrite_exe<=0; memwrite_exe<=0; memread_exe<=0; branch_exe<=0; aluop_exe<=0;
        end else begin
            pc_exe <= pc_id; imm_exe<=imm_id; rdata1_exe<=rdata1_id; rdata2_exe<=rdata2_id; rd_exe<=rd_id;
            alusrc_exe<=alusrc_id; regwrite_exe<=regwrite_id; memwrite_exe<=memwrite_id;
            memread_exe<=memread_id; branch_exe<=branch_id; aluop_exe<=aluop_id;
        end
    end
endmodule
