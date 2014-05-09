// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// (C) 2001-2010 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/13.1/ip/merlin/altera_merlin_std_arbitrator/altera_merlin_std_arbitrator_core.sv#1 $
// $Revision: #1 $
// $Date: 2013/08/11 $
// $Author: swbranch $

/* -----------------------------------------------------------------------
Round-robin/fixed arbitration implementation.

Q: how do you find the least-significant set-bit in an n-bit binary number, X?

A: M = X & (~X + 1)

Example: X = 101000100
 101000100 & 
 010111011 + 1 =

 101000100 &
 010111100 =
 -----------
 000000100

The method can be generalized to find the first set-bit
at a bit index no lower than bit-index N, simply by adding
2**N rather than 1.


Q: how does this relate to round-robin arbitration?
A:
Let X be the concatenation of all request signals.
Let the number to be added to X (hereafter called the
top_priority) initialize to 1, and be assigned from the
concatenation of the previous saved-grant, left-rotated
by one position, each time arbitration occurs.  The
concatenation of grants is then M.

Problem: consider this case:

top_priority            = 010000
request                 = 001001
~request + top_priority = 000110
next_grant              = 000000 <- no one is granted!

There was no "set bit at a bit index no lower than bit-index 4", so 
the result was 0.

We need to propagate the carry out from (~request + top_priority) to the LSB, so
that the sum becomes 000111, and next_grant is 000001.  This operation could be
called a "circular add". 

A bit of experimentation on the circular add reveals a significant amount of 
delay in exiting and re-entering the carry chain - this will vary with device
family.  Quartus also reports a combinational loop warning.  Finally, 
Modelsim 6.3g has trouble with the expression, evaluating it to 'X'.  But 
Modelsim _doesn't_ report a combinational loop!)

An alternate solution: concatenate the request vector with itself, and OR
corresponding bits from the top and bottom halves to determine next_grant.

Example:

top_priority                        =        010000
{request, request}                  = 001001 001001
{~request, ~request} + top_priority = 110111 000110
result of & operation               = 000001 000000
next_grant                          =        000001

Notice that if request = 0, the sum operation will overflow, but we can ignore
this; the next_grant result is 0 (no one granted), as you might expect.
In the implementation, the last-granted value must be maintained as
a non-zero value - best probably simply not to update it when no requests
occur.

----------------------------------------------------------------------- */ 

`timescale 1 ns / 1 ns

module altera_merlin_std_arbitrator_core
#(
    parameter NUM_REQUESTERS = 8,
    // --------------------------------------
    // Implemented schemes
    // "round-robin"
    // "fixed-priority"
    // "no-arb"
    // --------------------------------------
    parameter SCHEME         = "round-robin" 
)
(
    input clk,
    input reset,
   
    // --------------------------------------
    // Request sink
    // --------------------------------------
    input [NUM_REQUESTERS-1:0]  request,       // st sink data
   
    // --------------------------------------
    // Grant source
    // --------------------------------------
    output [NUM_REQUESTERS-1:0] next_grant,    // st source data
    input                       ack            // st source ready
);

    // --------------------------------------
    // Signals
    // --------------------------------------
    wire [NUM_REQUESTERS-1:0]   top_priority;
    reg  [NUM_REQUESTERS-1:0]   last_grant;
    wire [2*NUM_REQUESTERS-1:0] result;

    // --------------------------------------
    // Scheme Selection
    // --------------------------------------
    generate
        if (SCHEME == "round-robin" && NUM_REQUESTERS > 1) begin
            // Left-rotate the last next_grant vector to create top_priority.
            assign top_priority = {
                last_grant[NUM_REQUESTERS - 2 : 0],
                last_grant[NUM_REQUESTERS - 1]
            };
        end
        else begin
            // Fixed arbitration (or single-requester corner case).
            assign top_priority = 1'b1;
        end
    endgenerate

    // --------------------------------------
    // Decision Logic
    // --------------------------------------
    altera_merlin_std_arb_adder
    #(
        .WIDTH (2 * NUM_REQUESTERS)
    ) 
    adder
    (
        .a ({ ~request, ~request }),
        .b ({{NUM_REQUESTERS{1'b0}}, top_priority}),
        .sum (result)
    );

    generate if (SCHEME == "no-arb") begin

        // --------------------------------------
        // No arbitration: just wire request directly to grant
        // --------------------------------------
        assign next_grant = request;

    end else begin

        // --------------------------------------
        // Extract next_grant from the top and bottom halves
        // of the double vector.
        // --------------------------------------
        wire [2*NUM_REQUESTERS-1:0] grant_double_vector;
        assign grant_double_vector = {request, request} & result;
        assign next_grant =
            grant_double_vector[NUM_REQUESTERS - 1 : 0] |
            grant_double_vector[2 * NUM_REQUESTERS - 1 : NUM_REQUESTERS];

    end
    endgenerate

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset value is chosen so that top_priority begins at 1'b1.
            last_grant <= (1'b1 << (NUM_REQUESTERS - 1));
        end
        else if (ack) begin

            // ----------------------------------------------
            // Save the last non-zero next_grant value. As an
            // optimization, we know that next_grant is only
            // zero if all requests are 0.
            // ----------------------------------------------
            last_grant <= (|request) ? next_grant : last_grant;
        end
    end

endmodule

// ----------------------------------------------
// Adder for the standard arbitrator
// ----------------------------------------------
module altera_merlin_std_arb_adder
#(
    parameter WIDTH = 8
)
(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,

    output [WIDTH-1:0] sum
);

    // ----------------------------------------------
    // Benchmarks indicate that for small widths, the full
    // adder has higher fmax because synthesis can merge
    // it with the mux, allowing partial decisions to be 
    // made early.
    //
    // The magic number is 4 requesters, which means an
    // 8 bit adder.
    // ----------------------------------------------
    genvar i;
    generate if (WIDTH <= 8) begin : full_adder

        wire cout[WIDTH-1:0];

        assign sum[0]  = (a[0] ^ b[0]);
        assign cout[0] = (a[0] & b[0]);

        for (i = 1; i < WIDTH; i = i+1) begin : arb

            assign sum[i] = (a[i] ^ b[i]) ^ cout[i-1];
            assign cout[i] = (a[i] & b[i]) | (cout[i-1] & (a[i] ^ b[i]));

        end

    end else begin : carry_chain

        assign sum = a + b;

    end
    endgenerate

endmodule
