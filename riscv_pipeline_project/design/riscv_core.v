module riscv_core(input logic clk, rst);
    // IF stage
    logic [31:0] pc, pc_next, instr;
    PC pc0(clk, rst, pc_next, pc);
    memory imem(.addr(pc), .instr(instr));

    // IF/ID
    logic [31:0] pc_id, instr_id;
    IF_IDstage ifid(clk, rst, pc, instr, pc_id, instr_id);

    // ID stage decode
    logic [4:0] rs1, rs2, rd_id;
    assign rs1 = instr_id[19:15];
    assign rs2 = instr_id[24:20];
    assign rd_id = instr_id[11:7];

    // immediate decoder (I & B & J subset)
    logic [31:0] imm_id;
    always_comb unique case (instr_id[6:0])
        7'b0010011,7'b0000011: imm_id = {{20{instr_id[31]}}, instr_id[31:20]}; // I-type
        7'b0100011: imm_id = {{20{instr_id[31]}}, instr_id[31:25], instr_id[11:7]}; // S-type
        7'b1100011: imm_id = {{19{instr_id[31]}}, instr_id[31], instr_id[7], instr_id[30:25], instr_id[11:8], 1'b0}; // B-type
        7'b1101111: imm_id = {{11{instr_id[31]}}, instr_id[31], instr_id[19:12], instr_id[20], instr_id[30:21], 1'b0}; // J-type
        default:    imm_id = 0;
    endcase

    // register file
    logic [31:0] rdata1_id, rdata2_id, wdata_wb;
    logic [4:0] rd_wb;
    logic        regwrite_wb;
    regfile rf(clk, regwrite_wb, rs1, rs2, rd_wb, wdata_wb, rdata1_id, rdata2_id);

    // control
    logic alusrc_id, regwrite_id, memwrite_id, memread_id, branch_id;
    logic [2:0] aluop_id;
    control cu(instr_id[6:0], instr_id[14:12], instr_id[31:25],
               alusrc_id, regwrite_id, memwrite_id, memread_id,
               branch_id, aluop_id);

    // ID/EXE pipeline register
    logic [31:0] pc_exe, imm_exe, rdata1_exe, rdata2_exe;
    logic [4:0]  rd_exe;
    logic        alusrc_exe, regwrite_exe, memwrite_exe, memread_exe, branch_exe;
    logic [2:0]  aluop_exe;
    ID_EXEstage idexe(clk, rst, pc_id, imm_id, rdata1_id, rdata2_id, rd_id,
                      alusrc_id, regwrite_id, memwrite_id, memread_id, branch_id, aluop_id,
                      pc_exe, imm_exe, rdata1_exe, rdata2_exe, rd_exe,
                      alusrc_exe, regwrite_exe, memwrite_exe, memread_exe, branch_exe, aluop_exe);

    // EXE stage
    logic [31:0] alu_b = alusrc_exe ? imm_exe : rdata2_exe;
    logic [31:0] alu_y;
    logic        zero;
    alu alu0(rdata1_exe, alu_b, aluop_exe, alu_y, zero);

    // branch decision & next PC
    assign pc_next = (branch_exe && zero) ? pc_exe + imm_exe : pc + 4;

    // EXE/WB pipeline register
    logic [31:0] alu_y_wb;
    EXE_WBstage exewb(clk, rst, alu_y, rd_exe, regwrite_exe,
                      alu_y_wb, rd_wb, regwrite_wb);

    // WB stage
    assign wdata_wb = alu_y_wb;
endmodule
