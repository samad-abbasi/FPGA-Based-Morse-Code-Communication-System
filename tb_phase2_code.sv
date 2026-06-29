module tb_phase2;

    logic [3:0] number;
    logic       clk, btn1, btn2, rst, mode;
    logic       led;

    // DUT
    phase_2 dut (
        .number(number),
        .clk(clk),
        .btn1(btn1),
        .btn2(btn2),
        .rst(rst),
        .mode(mode),
        .led(led)
    );

    // 10 ns clock (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    task press_btn1;
        begin
            @(posedge clk); #1; btn1 = 1;
            @(posedge clk); #1; btn1 = 0;
        end
    endtask

    task press_btn2;
        begin
            @(posedge clk); #1; btn2 = 1;
            @(posedge clk); #1; btn2 = 0;
        end
    endtask


    initial begin
        rst    = 1;
        btn1   = 0;
        btn2   = 0;
        number = 0;
        mode   = 0;
        repeat(4) @(posedge clk);
        rst = 0;
        repeat(2) @(posedge clk);

        // phase 1: encode digit 1
        mode = 1'b0;
        number = 4'd1;
        #10;
        press_btn1;
        #2000;

        // phase 1: encode digit 5
        number = 4'd5;
        #10;
        press_btn1;
        #1500;

        // phase 2: store and transmit digits 1, 2, 3
        mode = 1'b1;
        rst = 1;
        repeat(4) @(posedge clk);
        rst = 0;
        repeat(2) @(posedge clk);

        number = 4'd1;
        #10;            // let number settle before pressing button
        press_btn1;
        repeat(5) @(posedge clk);

        number = 4'd2;
        #10;
        press_btn1;
        repeat(5) @(posedge clk);

        number = 4'd3;
        #10;
        press_btn1;
        repeat(5) @(posedge clk);


        press_btn2;

        #8000;


        number = 4'd5;
        #10;
        press_btn1;
        repeat(5) @(posedge clk);
        press_btn2;

        #8000;

        $stop;
    end

endmodule
