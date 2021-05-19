
module subservient_top
  #(//Memory parameters
    parameter memsize  = 512,
    parameter aw       = $clog2(memsize),
    //Enable CSR + interrupts
    parameter WITH_CSR = 0)
  (
   input wire 		i_clk,
   input wire 		i_rst,

   //SRAM interface
   output wire [aw-1:0] o_sram_waddr,
   output wire [7:0] 	o_sram_wdata,
   output wire 		o_sram_wen,
   output wire [aw-1:0] o_sram_raddr,
   input wire [7:0] 	i_sram_rdata,
   output wire 		o_sram_ren,

   //Debug interface
   input wire 		i_debug_mode,
   input wire [31:0] 	i_wb_dbg_adr,
   input wire [31:0] 	i_wb_dbg_dat,
   input wire [3:0] 	i_wb_dbg_sel,
   input wire 		i_wb_dbg_we ,
   input wire 		i_wb_dbg_stb,
   output wire [31:0] 	o_wb_dbg_rdt,
   output wire 		o_wb_dbg_ack,

   //External I/O
   output wire 		o_gpio);
    
    //Adapt the 8-bit SRAM interface from subservient to the 32-bit OpenRAM instance
    reg [1:0] sram_bsel;
    always @(posedge i_clk) begin
        sram_bsel <= sram_raddr[1:0];
    end
    
    wire [3:0] wmask0;// = 4'd1 << sram_waddr[1:0];
    assign wmask0        = 4'd1 << sram_waddr[1:0];
    wire [7:0] waddr0;// = sram_waddr[9:2]; //256 32-bit words = 1kB
    assign waddr0        = sram_waddr[9:2];
    wire [31:0] din0;//  = {4{sram_wdata}}; //Mirror write data to all byte lanes
    assign din0          = {4{sram_wdata}};
    
    wire [7:0]  addr1;// = sram_raddr[9:2];
    assign addr1         = sram_raddr[9:2];
    wire [31:0] dout1;
    assign sram_rdata = dout1[sram_bsel*8+:8]; //Pick the right byte from the read data
    
    subservient subservient_inst
    (
    // Clock & reset
    .i_clk (i_clk),
    .i_rst (i_rst),

    //SRAM interface
    .o_sram_waddr (sram_waddr),
    .o_sram_wdata (sram_wdata),
    .o_sram_wen   (sram_wen),
    .o_sram_raddr (sram_raddr),
    .i_sram_rdata (sram_rdata),
    .o_sram_ren   (sram_ren),
    
    //Debug interface
    .i_debug_mode (i_debug_mode),
    .i_wb_dbg_adr (i_wb_dbg_adr),
    .i_wb_dbg_dat (i_wb_dbg_dat),
    .i_wb_dbg_sel (i_wb_dbg_sel),
    .i_wb_dbg_we  (i_wb_dbg_we),
    .i_wb_dbg_stb (i_wb_dbg_stb),
    .o_wb_dbg_rdt (o_wb_dbg_rdt),
    .o_wb_dbg_ack (o_wb_dbg_ack),
    
    // External I/O
    .o_gpio (o_gpio)
    );
    
endmodule
