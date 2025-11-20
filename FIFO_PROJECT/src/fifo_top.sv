module fifo_top #(
    parameter int DEPTH = 32,
    `ifndef USE_TYPE
    parameter type data_t = logic
    // `else
    // parameter type data_t = 
    `endif
) (
    input logic clk_i,
    input logic arst_ni,

    input data_t data_i,
    input logic data_valid_i,
    output logic data_ready_o,

    output data_t data_o,
    output logic data_valid_o,
    input logic data_ready_i,

    output logic isFull_o,
    output logic isEmpty_o,
    output logic [$clog2(DEPTH)-1:0] count_o
);

    localparam int PTR_WIDTH = $clog2(DEPTH);

    logic [PTR_WIDTH-1:0] w_ptr;
    logic [PTR_WIDTH-1:0] r_ptr;
    logic [$clog2(DEPTH):0] count;

    data_t fifo_slots [DEPTH];

    assign count_o = count;
    assign isEmpty_o = (count == 0) ? '1 : '0;
    assign isFull_o  = (count == DEPTH) ? '1 : '0;

    assign data_ready_o = (count == DEPTH) ? '0 : '1;
    assign data_valid_o = (count > 0) ? '1 : '0;

    assign data_o = fifo_slots[r_ptr];

    always_ff @( posedge clk_i ) begin
        if (~arst_ni) begin
            count <= '0;

            w_ptr <= '0;
            r_ptr <= '0;
        end else begin
            if (data_valid_i && data_ready_o) begin
                fifo_slots[w_ptr] <= data_i;
                w_ptr <= w_ptr + 1;
                count <=  count + 1;
            end else if (data_valid_o && data_ready_i) begin
                r_ptr <= r_ptr + 1;
                count <=  count - 1;
            end
        end
    end

endmodule