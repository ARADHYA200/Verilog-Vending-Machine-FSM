//=========================================================
// Vending Machine FSM
// Products:
// Product A = Rs.15
// Product B = Rs.20
//
// Coins Accepted:
// Rs.5 and Rs.10
//
// Features:
// - Handles exact payment
// - Handles extra payment with change return
// - Separate product selection
// - FSM based sequential design
//=========================================================

module vending_machine(
    input clk,
    input reset,

    input coin5,
    input coin10,

    input selectA,     // Product A = 15
    input selectB,     // Product B = 20

    output reg dispenseA,
    output reg dispenseB,
    output reg [4:0] change,
    output reg [5:0] balance
);

    //=====================================================
    // STATE ENCODING
    //=====================================================

    parameter S0  = 0;
    parameter S5  = 1;
    parameter S10 = 2;
    parameter S15 = 3;
    parameter S20 = 4;
    parameter S25 = 5;

    reg [2:0] state, next_state;

    //=====================================================
    // STATE MEMORY
    //=====================================================

    always @(posedge clk or posedge reset)
    begin
        if(reset)
            state <= S0;
        else
            state <= next_state;
    end

    //=====================================================
    // NEXT STATE LOGIC
    //=====================================================

    always @(*)
    begin
        next_state = state;

        case(state)

            //---------------------------------------------
            // Rs.0
            //---------------------------------------------
            S0:
            begin
                if(coin5)
                    next_state = S5;

                else if(coin10)
                    next_state = S10;
            end

            //---------------------------------------------
            // Rs.5
            //---------------------------------------------
            S5:
            begin
                if(coin5)
                    next_state = S10;

                else if(coin10)
                    next_state = S15;
            end

            //---------------------------------------------
            // Rs.10
            //---------------------------------------------
            S10:
            begin
                if(coin5)
                    next_state = S15;

                else if(coin10)
                    next_state = S20;
            end

            //---------------------------------------------
            // Rs.15
            //---------------------------------------------
            S15:
            begin
                if(coin5)
                    next_state = S20;

                else if(coin10)
                    next_state = S25;
            end

            //---------------------------------------------
            // Rs.20
            //---------------------------------------------
            S20:
            begin
                if(coin5)
                    next_state = S25;
            end

            //---------------------------------------------
            // Rs.25
            //---------------------------------------------
            S25:
            begin
                next_state = S25;
            end

            default:
                next_state = S0;

        endcase
    end

    //=====================================================
    // OUTPUT LOGIC
    //=====================================================

    always @(*)
    begin

        dispenseA = 0;
        dispenseB = 0;
        change = 0;

        case(state)

            //-------------------------------------------------
            // PRODUCT A (Rs.15)
            //-------------------------------------------------

            S15:
            begin
                if(selectA)
                begin
                    dispenseA = 1;
                    change = 0;
                end
            end

            S20:
            begin
                if(selectA)
                begin
                    dispenseA = 1;
                    change = 5;
                end

                else if(selectB)
                begin
                    dispenseB = 1;
                    change = 0;
                end
            end

            S25:
            begin
                if(selectA)
                begin
                    dispenseA = 1;
                    change = 10;
                end

                else if(selectB)
                begin
                    dispenseB = 1;
                    change = 5;
                end
            end

        endcase
    end

    //=====================================================
    // BALANCE DISPLAY
    //=====================================================

    always @(*)
    begin
        case(state)

            S0  : balance = 0;
            S5  : balance = 5;
            S10 : balance = 10;
            S15 : balance = 15;
            S20 : balance = 20;
            S25 : balance = 25;

            default : balance = 0;

        endcase
    end

endmodule