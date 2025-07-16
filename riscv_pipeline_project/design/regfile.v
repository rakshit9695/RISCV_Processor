module regfile(
    input  logic        clk,
    input  logic        we,
    input  logic [4:0]  rs1, rs2, rd,
    input  logic [31:0] wdata,
    output logic [31:0] rdata1, rdata2
);
    logic [31:0] regs [31:0];

    // asynchronous reads
    assign rdata1 = (rs1==0) ? 0 : regs[rs1];
    assign rdata2 = (rs2==0) ? 0 : regs[rs2];

    // synchronous write
    always_ff @(posedge clk) begin
        if (we && rd!=0) regs[rd] <= wdata;
    end
endmodule
