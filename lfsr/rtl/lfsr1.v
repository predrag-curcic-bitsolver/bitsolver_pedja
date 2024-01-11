// Predrag Curcic
// Bitsolver
// Description 
// -> Linear Feedback Shift Register with POLYNOMIAL, WIDTH, and SEED parameters

module lfsr1 (
    // Inputs
    clk,
    reset_n,
    ld,
    en,
    // Outputs 
    dout
);
    // width of LFSR
    parameter LFSR_WIDTH = 7;
    // primitive polynomial for feedback
    parameter [LFSR_WIDTH-1:0] LFSR_POLYNOMIAL = 1000010;
    // starting seed 
    parameter [LFSR_WIDTH-1:0] LFSR_SEED = 11011011011;

    input clk           ;
    input reset_n       ;
    input ld            ; // Loading seed
    input en            ; // Enables functionality of LFSR

    output wire dout    ; // LFSR out

    reg feedback;
    reg [LFSR_WIDTH-1:0] d_ff;

    // Feedback calculation based on parametrized polynomial
    always @(posedge clk or negedge reset_n) 
    begin
        if(!reset_n)
            feedback <= 'b0;
        else    
            if (en == 1)
                for (int i = 1; i < LFSR_WIDTH; i = i + 1) 
                    if (LFSR_POLYNOMIAL[i] == 1'b1)
                        feedback <= (feedback ^ d_ff[i]);
    end

    // Shift and feedback calculation
    always @(posedge clk or negedge reset_n)
    begin
        if (!reset_n)
            d_ff <= 'b0;
        else if (ld)
            d_ff <= LFSR_SEED;
        else if (en)
            d_ff <= {d_ff[LFSR_WIDTH-2:0], feedback};
    end

    assign dout = d_ff[LFSR_WIDTH-1];

endmodule // lfsr