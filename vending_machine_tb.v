`timescale 1ns/1ps

module vending_machine_tb;

    reg clk;
    reg reset;

    reg coin5;
    reg coin10;

    reg selectA;
    reg selectB;

    wire dispenseA;
    wire dispenseB;

    wire [4:0] change;
    wire [5:0] balance;

    //=====================================================
    // DUT INSTANTIATION
    //=====================================================

    vending_machine uut(
        .clk(clk),
        .reset(reset),

        .coin5(coin5),
        .coin10(coin10),

        .selectA(selectA),
        .selectB(selectB),

        .dispenseA(dispenseA),
        .dispenseB(dispenseB),

        .change(change),
        .balance(balance)
    );

    //=====================================================
    // CLOCK GENERATION
    //=====================================================

    always #5 clk = ~clk;

    //=====================================================
    // TESTING
    //=====================================================

    initial
    begin

        $dumpfile("vending.vcd");
        $dumpvars(0, vending_machine_tb);

        clk = 0;
        reset = 1;

        coin5 = 0;
        coin10 = 0;

        selectA = 0;
        selectB = 0;

        #10;
        reset = 0;

        //=================================================
        // CASE 1
        // Buy Product A using 5 + 10
        //=================================================

        $display("CASE 1 : Product A Exact Payment");

        #10 coin5 = 1;
        #10 coin5 = 0;

        #10 coin10 = 1;
        #10 coin10 = 0;

        #10 selectA = 1;
        #10 selectA = 0;

        //=================================================
        // RESET
        //=================================================

        #20 reset = 1;
        #10 reset = 0;

        //=================================================
        // CASE 2
        // Buy Product B using 10 + 10
        //=================================================

        $display("CASE 2 : Product B Exact Payment");

        #10 coin10 = 1;
        #10 coin10 = 0;

        #10 coin10 = 1;
        #10 coin10 = 0;

        #10 selectB = 1;
        #10 selectB = 0;

        //=================================================
        // RESET
        //=================================================

        #20 reset = 1;
        #10 reset = 0;

        //=================================================
        // CASE 3
        // Product A with extra money
        // 10 + 10 = 20
        // Change = 5
        //=================================================

        $display("CASE 3 : Product A With Change");

        #10 coin10 = 1;
        #10 coin10 = 0;

        #10 coin10 = 1;
        #10 coin10 = 0;

        #10 selectA = 1;
        #10 selectA = 0;

        //=================================================
        // RESET
        //=================================================

        #20 reset = 1;
        #10 reset = 0;

        //=================================================
        // CASE 4
        // Product B with extra money
        // 10 + 10 + 5 = 25
        // Change = 5
        //=================================================

        $display("CASE 4 : Product B With Change");

        #10 coin10 = 1;
        #10 coin10 = 0;

        #10 coin10 = 1;
        #10 coin10 = 0;

        #10 coin5 = 1;
        #10 coin5 = 0;

        #10 selectB = 1;
        #10 selectB = 0;

        //=================================================
        // CASE 5
        // Insufficient balance
        //=================================================

        $display("CASE 5 : Insufficient Balance");

        #20 reset = 1;
        #10 reset = 0;

        #10 coin5 = 1;
        #10 coin5 = 0;

        #10 selectB = 1;
        #10 selectB = 0;

        //=================================================
        // END
        //=================================================

        #50;
        $finish;

    end

endmodule