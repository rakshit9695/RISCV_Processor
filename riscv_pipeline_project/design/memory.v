// 1 KiB instruction ROM (byte-addressable, little-endian)
module memory #(
    parameter DEPTH = 256  // 1024 bytes / 4 = 256 words
)(
    input  logic [31:0] addr,      // byte address
    output logic [31:0] instr
);
    logic [7:0] mem [0:DEPTH*4-1];

    // preload a demo program
    initial $readmemh("program.hex", mem);

    assign instr = { mem[addr+3], mem[addr+2], mem[addr+1], mem[addr] };
endmodule
