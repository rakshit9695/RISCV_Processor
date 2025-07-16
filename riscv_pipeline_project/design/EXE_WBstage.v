module EXE_WBstage(
    input  logic        clk, rst,
    // from EXE
    input  logic [31:0] alu_y_in,
    input  logic [4:0]  rd_in,
    input  logic        regwrite_in,
    // to WB
    output logic [31:0] alu_y_out,
    output logic [4:0]  rd_out,
    output logic        regwrite_out
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            alu_y_out<=0; rd_out<=0; regwrite_out<=0;
        end else begin
            alu_y_out<=alu_y_in; rd_out<=rd_in; regwrite_out<=regwrite_in;
        end
    end
endmodule
