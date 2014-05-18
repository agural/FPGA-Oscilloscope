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


// $Id: //acds/rel/13.1/ip/merlin/altera_tristate_conduit_bridge/altera_tristate_conduit_bridge.sv.terp#1 $
// $Revision: #1 $
// $Date: 2013/08/11 $
// $Author: swbranch $

//Defined Terp Parameters


			    

`timescale 1 ns / 1 ns
  				      
module proc_BRIDGE (
     input  logic clk
    ,input  logic reset
    ,input  logic request
    ,output logic grant
    ,input  logic[ 17 :0 ] tcs_address
    ,output  wire [ 17 :0 ] address
    ,output logic[ 0 :0 ] tcs_VRAM_ctrl_tcm_waitrequest_in
    ,input  logic[ 0 :0 ] VRAM_ctrl_tcm_waitrequest_in
    ,input  logic[ 0 :0 ] tcs_VRAM_ctrl_tcm_chipselect_n_out
    ,output  wire [ 0 :0 ] VRAM_ctrl_tcm_chipselect_n_out
    ,output logic[ 15 :0 ] tcs_data_in
    ,input  logic[ 15 :0 ] tcs_data
    ,input  logic tcs_data_outen
    ,inout  wire [ 15 :0 ]  data
    ,input  logic[ 0 :0 ] tcs_ROM_ctrl_tcm_chipselect_n_out
    ,output  wire [ 0 :0 ] ROM_ctrl_tcm_chipselect_n_out
    ,input  logic[ 0 :0 ] tcs_RAM_ctrl_tcm_chipselect_n_out
    ,output  wire [ 0 :0 ] RAM_ctrl_tcm_chipselect_n_out
    ,input  logic[ 0 :0 ] tcs_r_w
    ,output  wire [ 0 :0 ] r_w
		     
   );
   reg grant_reg;
   assign grant = grant_reg;
   
   always@(posedge clk) begin
      if(reset)
	grant_reg <= 0;
      else
	grant_reg <= request;      
   end
   


 // ** Output Pin address 
 
    reg                       addressen_reg;     
  
    always@(posedge clk) begin
	 if( reset ) begin
	   addressen_reg <= 'b0;
	 end
	 else begin
	   addressen_reg <= 'b1;
	 end
     end		     
   
 
    reg [ 17 : 0 ] address_reg;   

     always@(posedge clk) begin
	 address_reg   <= tcs_address[ 17 : 0 ];
      end
          
 
    assign 	address[ 17 : 0 ] = addressen_reg ? address_reg : 'z ;
        


 // ** Input Pin VRAM_ctrl_tcm_waitrequest_in 
 
    reg [ 0 : 0 ] 	VRAM_ctrl_tcm_waitrequest_in_reg;
								    
    always@(posedge clk) begin
	 VRAM_ctrl_tcm_waitrequest_in_reg <= VRAM_ctrl_tcm_waitrequest_in;
    end
           
 
    assign      tcs_VRAM_ctrl_tcm_waitrequest_in[ 0 : 0 ] = VRAM_ctrl_tcm_waitrequest_in_reg[ 0 : 0 ];
         


 // ** Output Pin VRAM_ctrl_tcm_chipselect_n_out 
 
    reg                       VRAM_ctrl_tcm_chipselect_n_outen_reg;     
  
    always@(posedge clk) begin
	 if( reset ) begin
	   VRAM_ctrl_tcm_chipselect_n_outen_reg <= 'b0;
	 end
	 else begin
	   VRAM_ctrl_tcm_chipselect_n_outen_reg <= 'b1;
	 end
     end		     
   
 
    reg [ 0 : 0 ] VRAM_ctrl_tcm_chipselect_n_out_reg;   

     always@(posedge clk) begin
	 VRAM_ctrl_tcm_chipselect_n_out_reg   <= tcs_VRAM_ctrl_tcm_chipselect_n_out[ 0 : 0 ];
      end
          
 
    assign 	VRAM_ctrl_tcm_chipselect_n_out[ 0 : 0 ] = VRAM_ctrl_tcm_chipselect_n_outen_reg ? VRAM_ctrl_tcm_chipselect_n_out_reg : 'z ;
        


 // ** Bidirectional Pin data 
   
    reg                       data_outen_reg;
  
    always@(posedge clk) begin
	 data_outen_reg <= tcs_data_outen;
     end
  
  
    reg [ 15 : 0 ] data_reg;   

     always@(posedge clk) begin
	 data_reg   <= tcs_data[ 15 : 0 ];
      end
         
  
    assign 	data[ 15 : 0 ] = data_outen_reg ? data_reg : 'z ;
       
  
    reg [ 15 : 0 ] 	data_in_reg;
								    
    always@(posedge clk) begin
	 data_in_reg <= data[ 15 : 0 ];
    end
    
  
    assign      tcs_data_in[ 15 : 0 ] = data_in_reg[ 15 : 0 ];
        


 // ** Output Pin ROM_ctrl_tcm_chipselect_n_out 
 
    reg                       ROM_ctrl_tcm_chipselect_n_outen_reg;     
  
    always@(posedge clk) begin
	 if( reset ) begin
	   ROM_ctrl_tcm_chipselect_n_outen_reg <= 'b0;
	 end
	 else begin
	   ROM_ctrl_tcm_chipselect_n_outen_reg <= 'b1;
	 end
     end		     
   
 
    reg [ 0 : 0 ] ROM_ctrl_tcm_chipselect_n_out_reg;   

     always@(posedge clk) begin
	 ROM_ctrl_tcm_chipselect_n_out_reg   <= tcs_ROM_ctrl_tcm_chipselect_n_out[ 0 : 0 ];
      end
          
 
    assign 	ROM_ctrl_tcm_chipselect_n_out[ 0 : 0 ] = ROM_ctrl_tcm_chipselect_n_outen_reg ? ROM_ctrl_tcm_chipselect_n_out_reg : 'z ;
        


 // ** Output Pin RAM_ctrl_tcm_chipselect_n_out 
 
    reg                       RAM_ctrl_tcm_chipselect_n_outen_reg;     
  
    always@(posedge clk) begin
	 if( reset ) begin
	   RAM_ctrl_tcm_chipselect_n_outen_reg <= 'b0;
	 end
	 else begin
	   RAM_ctrl_tcm_chipselect_n_outen_reg <= 'b1;
	 end
     end		     
   
 
    reg [ 0 : 0 ] RAM_ctrl_tcm_chipselect_n_out_reg;   

     always@(posedge clk) begin
	 RAM_ctrl_tcm_chipselect_n_out_reg   <= tcs_RAM_ctrl_tcm_chipselect_n_out[ 0 : 0 ];
      end
          
 
    assign 	RAM_ctrl_tcm_chipselect_n_out[ 0 : 0 ] = RAM_ctrl_tcm_chipselect_n_outen_reg ? RAM_ctrl_tcm_chipselect_n_out_reg : 'z ;
        


 // ** Output Pin r_w 
 
    reg                       r_wen_reg;     
  
    always@(posedge clk) begin
	 if( reset ) begin
	   r_wen_reg <= 'b0;
	 end
	 else begin
	   r_wen_reg <= 'b1;
	 end
     end		     
   
 
    reg [ 0 : 0 ] r_w_reg;   

     always@(posedge clk) begin
	 r_w_reg   <= tcs_r_w[ 0 : 0 ];
      end
          
 
    assign 	r_w[ 0 : 0 ] = r_wen_reg ? r_w_reg : 'z ;
        

endmodule


