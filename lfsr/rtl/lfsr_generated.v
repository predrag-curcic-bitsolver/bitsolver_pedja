module lfsr #(parameter LFSR_Width = 8, LFSR_Polynomial = 8'h153, LFSR_Seed = 8'h170) (
    input clk,
    input reset_n,
    input ld,
    input en,
    output wire dout
);
    reg feedback;
    reg [7:0] d_ff;
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            feedback <= 1'b0;
        else
            feedback <= 8'b0 ^ d_ff[7] ^ d_ff[4] ^ d_ff[3] && en;
    end
    lfsr_node i_lfsr_node0 (.clk(clk), .reset_n(reset_n), .d(feedback), .ld(ld), .en(en), .seed(LFSR_Seed[0]), .q(d_ff[0]));
    lfsr_node i_lfsr_node1 (.clk(clk), .reset_n(reset_n), .d(d_ff[0]), .ld(ld), .en(en), .seed(LFSR_Seed[1]), .q(d_ff[1]));
    lfsr_node i_lfsr_node2 (.clk(clk), .reset_n(reset_n), .d(d_ff[1]), .ld(ld), .en(en), .seed(LFSR_Seed[2]), .q(d_ff[2]));
    lfsr_node i_lfsr_node3 (.clk(clk), .reset_n(reset_n), .d(d_ff[2]), .ld(ld), .en(en), .seed(LFSR_Seed[3]), .q(d_ff[3]));
    lfsr_node i_lfsr_node4 (.clk(clk), .reset_n(reset_n), .d(d_ff[3]), .ld(ld), .en(en), .seed(LFSR_Seed[4]), .q(d_ff[4]));
    lfsr_node i_lfsr_node5 (.clk(clk), .reset_n(reset_n), .d(d_ff[4]), .ld(ld), .en(en), .seed(LFSR_Seed[5]), .q(d_ff[5]));
    lfsr_node i_lfsr_node6 (.clk(clk), .reset_n(reset_n), .d(d_ff[5]), .ld(ld), .en(en), .seed(LFSR_Seed[6]), .q(d_ff[6]));
    lfsr_node i_lfsr_node7 (.clk(clk), .reset_n(reset_n), .d(d_ff[6]), .ld(ld), .en(en), .seed(LFSR_Seed[7]), .q(d_ff[7]));
    assign dout = d_ff[7];
endmodule // lfsr
