module tb_top;

    // PARAMETERS

    parameter int DEPTH = 4;

    typedef struct packed {
        logic isWrite;
        logic [3:0] addr;
        logic [31:0] data;
    } data_t;

    // CLKRST

    logic   clk_i;
    logic   arst_ni;

    // INPUT DATA

    data_t  data_i;
    logic   data_valid_i;
    logic   data_ready_o;

    // OUTPUT DATA

    data_t  data_o;
    logic   data_valid_o;
    logic   data_ready_i;

    // CSR SIGNALS

    logic   isFull_o;
    logic   isEmpty_o;
    logic   [$clog2(DEPTH)-1:0] count_o;

    // DUT

    fifo_top #(
        .DEPTH(DEPTH),
        .data_t(data_t)
    ) u_dut (
        .clk_i          (clk_i),
        .arst_ni        (arst_ni),
        .data_i         (data_i),
        .data_valid_i   (data_valid_i),
        .data_ready_o   (data_ready_o),
        .data_o         (data_o),
        .data_valid_o   (data_valid_o),
        .data_ready_i   (data_ready_i),
        .isFull_o       (isFull_o),
        .isEmpty_o      (isEmpty_o),
        .count_o        (count_o)
    );

    always #5 clk_i <= ~clk_i;

    initial begin
        fork
        begin
            clk_i <= '1;
        end
        begin
            arst_ni <= '1;
            repeat (10) @(posedge clk_i);
            arst_ni <= '0;
            repeat (5) @(posedge clk_i);
            arst_ni <= '1;
        end
        begin
            @(posedge arst_ni);
            @(posedge arst_ni);
            repeat (2) @(posedge clk_i);

            repeat (7) begin
                data_i <= $urandom;
                data_valid_i <= '1;
                fork
                begin
                    do @(posedge clk_i);
                    while (!data_ready_o);    
                end
                begin
                    repeat (10) @(posedge clk_i);
                end
                join_any
                data_valid_i <= '0;
            end
            repeat (5) begin
                data_ready_i <= '1;
                fork
                begin
                    do @(posedge clk_i);
                    while (!data_valid_o);
                end
                begin
                    repeat (10) @(posedge clk_i);
                end
                join_any
                data_ready_i <= '0;
            end

            repeat (8) begin
                data_i <= $urandom;
                data_valid_i <= '1;
                do @(posedge clk_i);
                while (!data_ready_o);
                data_valid_i <= '0;

                repeat (2) @(posedge clk_i);

                data_ready_i <= '1;
                do @(posedge clk_i);
                while (!data_valid_o);
                data_ready_i <= '0;
            end

            $finish;

        end
        begin
            #100000;
            $finish;
        end
        join            
    end

endmodule