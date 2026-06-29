module tb_phase1;

    logic [3:0] number;
    logic clk;
    logic btn1;
    logic rst;
    logic led;

    // DUT
    phse1 dut (
        .number(number),
        .clk(clk),
        .btn1(btn1),
        .rst(rst),
        .led(led)
    );

	//clock generaton for simulation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        // Initialize
        rst    = 1;
        btn1   = 0;
        number = 0;

        #150;
        rst = 0;

        number = 4'd7; //testing 0111 -> _ _ . . .

        #150;
        btn1 = 1;

        #10;
        btn1 = 0;

        #1500;


        number = 4'd1;   //testing 0001 -> . _ _ _ _

        #150;
        btn1 = 1;

        #10;
        btn1 = 0;

        #2200;

        number = 4'd0; //testing 0000 -> _ _ _ _ _

        #150;
        btn1 = 1;

        #10;
        btn1 = 0;

        #2200;

        $stop;
    end
    
    endmodule
