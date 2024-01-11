import sys

def generate_lfsr_code(width, polynomial, seed):
    code = f"module lfsr #(parameter LFSR_Width = {width}, LFSR_Polynomial = {width}'h{polynomial}, LFSR_Seed = {width}'h{seed}) (\n"
    code += "    input clk,\n"
    code += "    input reset_n,\n"
    code += "    input ld,\n"
    code += "    input en,\n"
    code += "    output wire dout\n"
    code += ");\n"

    code += "    reg feedback;\n"
    code += f"    reg [{width-1}:0] d_ff;\n"
    code += "    always @(posedge clk or negedge reset_n) begin\n"
    code += "        if (!reset_n)\n"
    code += "            feedback <= 1'b0;\n"
    code += "        else\n"
    code += f"            feedback <= {width}'b0"
    
    for i in range(width - 1, 0, -1):
        if (polynomial >> i) & 1:
            code += f" ^ d_ff[{i}]"

    code += f" && en;\n"
    code += "    end\n"

    code += f"    lfsr_node i_lfsr_node0 (.clk(clk), .reset_n(reset_n), .d(feedback), .ld(ld), .en(en), .seed(LFSR_Seed[0]), .q(d_ff[0]));\n"

    for i in range(1, width):
        code += f"    lfsr_node i_lfsr_node{i} (.clk(clk), .reset_n(reset_n), .d(d_ff[{i-1}]), .ld(ld), .en(en), .seed(LFSR_Seed[{i}]), .q(d_ff[{i}]));\n"

    code += f"    assign dout = d_ff[{width-1}];\n"
    code += "endmodule // lfsr\n"

    return code

def save_to_file(filename, code):
    with open(filename, 'w') as file:
        file.write(code)

# Checking if there is all arguments that are neccessary
if len(sys.argv) != 4:
    print("Usage: python generate_lfsr.py <width> <polynomial> <seed>")
    sys.exit(1)

# Reading arguments from command line
width       = int(sys.argv[1])
polynomial  = int(sys.argv[2], 16)  # HEX value reading
seed        = int(sys.argv[3], 16)  # HEX value reading

# Generisanje koda i čuvanje u datoteku
generated_code = generate_lfsr_code(width, polynomial, seed)
save_to_file("lfsr_generated.v", generated_code)

