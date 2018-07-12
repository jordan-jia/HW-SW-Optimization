
`timescale 1 ns / 1 ps

	module compute_sad_v1_0_S00_AXI #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 6
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write channel Protection type. This signal indicates the
    		// privilege and security level of the transaction, and whether
    		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave) 
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte lanes hold
    		// valid data. There is one write strobe bit for each eight
    		// bits of the write data bus.    
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Protection type. This signal indicates the privilege
    		// and security level of the transaction, and whether the
    		// transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY
	);

	// AXI4LITE signals
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arready;
	reg [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rvalid;

	// Example-specific design signals
	// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)
	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	localparam integer OPT_MEM_ADDR_BITS = 3;
	//----------------------------------------------
	//-- Signals for user logic register space example
	//------------------------------------------------
	//-- Number of Slave Registers 14
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg0;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg2;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg3;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg4;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg5;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg6;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg7;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg8;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg9;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg10;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg11;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg12;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg13;
	wire	 slv_reg_rden;
	wire	 slv_reg_wren;
	reg [C_S_AXI_DATA_WIDTH-1:0]	 reg_data_out;
	integer	 byte_index;
	reg	 aw_en;

	
	integer x;
	reg [18:0] result;
	reg [17:0] partial_sum9[0:1];
	reg [16:0] partial_sum8[0:3];
	reg [15:0] partial_sum7[0:7];
	reg [14:0] partial_sum6[0:15];
	reg [13:0] partial_sum5[0:31];
	reg [12:0] partial_sum4[0:63];
	reg [11:0] partial_sum3[0:127];
	reg [10:0] partial_sum2[0:255];
	reg [9:0] partial_sum1[0:511];
	reg [8:0] abs_diff[0:1023];
	reg [8:0] diff[0:1023];
	reg [10:0] j;
	reg [5:0] count;
	reg [1:0] face_select;
	
	reg [5:0] i;
	reg  we;
	reg [10:0] sram_addr;
	reg [8:0] data_in_1;
	wire [8:0] data_out_1;
	reg [8:0] data_in_2;
	wire [8:0] data_out_2;
	reg [8:0] data_in_3;
	wire [8:0] data_out_3;
	reg [8:0] data_in_4;
	wire [8:0] data_out_4;
	reg [8:0] data_in_5;
	wire [8:0] data_out_5;
	reg [8:0] data_in_6;
	wire [8:0] data_out_6;
	reg [8:0] data_in_7;
	wire [8:0] data_out_7;
	reg [8:0] data_in_8;
	wire [8:0] data_out_8;
	bram group_1 (.clk(S_AXI_ACLK),.we(we),.en(1),.data_in(data_in_1),.sram_addr(sram_addr),.data_out(data_out_1));
	bram group_2 (.clk(S_AXI_ACLK),.we(we),.en(1),.data_in(data_in_2),.sram_addr(sram_addr),.data_out(data_out_2));
	bram group_3 (.clk(S_AXI_ACLK),.we(we),.en(1),.data_in(data_in_3),.sram_addr(sram_addr),.data_out(data_out_3));
	bram group_4 (.clk(S_AXI_ACLK),.we(we),.en(1),.data_in(data_in_4),.sram_addr(sram_addr),.data_out(data_out_4));
	bram group_5 (.clk(S_AXI_ACLK),.we(we),.en(1),.data_in(data_in_5),.sram_addr(sram_addr),.data_out(data_out_5));
	bram group_6 (.clk(S_AXI_ACLK),.we(we),.en(1),.data_in(data_in_6),.sram_addr(sram_addr),.data_out(data_out_6));
	bram group_7 (.clk(S_AXI_ACLK),.we(we),.en(1),.data_in(data_in_7),.sram_addr(sram_addr),.data_out(data_out_7));
	bram group_8 (.clk(S_AXI_ACLK),.we(we),.en(1),.data_in(data_in_8),.sram_addr(sram_addr),.data_out(data_out_8));
	reg [5:0] i1;
	reg  we1;
	reg [10:0] sram_addr1;
	reg [8:0] data_in1_1;
	wire [8:0] data_out1_1;
	reg [8:0] data_in1_2;
	wire [8:0] data_out1_2;
	reg [8:0] data_in1_3;
	wire [8:0] data_out1_3;
	reg [8:0] data_in1_4;
	wire [8:0] data_out1_4;
	reg [8:0] data_in1_5;
	wire [8:0] data_out1_5;
	reg [8:0] data_in1_6;
	wire [8:0] data_out1_6;
	reg [8:0] data_in1_7;
	wire [8:0] data_out1_7;
	reg [8:0] data_in1_8;
	wire [8:0] data_out1_8;
	bram photo1_1 (.clk(S_AXI_ACLK),.we(we1),.en(1),.data_in(data_in1_1),.sram_addr(sram_addr1),.data_out(data_out1_1));
	bram photo1_2 (.clk(S_AXI_ACLK),.we(we1),.en(1),.data_in(data_in1_2),.sram_addr(sram_addr1),.data_out(data_out1_2));
	bram photo1_3 (.clk(S_AXI_ACLK),.we(we1),.en(1),.data_in(data_in1_3),.sram_addr(sram_addr1),.data_out(data_out1_3));
	bram photo1_4 (.clk(S_AXI_ACLK),.we(we1),.en(1),.data_in(data_in1_4),.sram_addr(sram_addr1),.data_out(data_out1_4));
	bram photo1_5 (.clk(S_AXI_ACLK),.we(we1),.en(1),.data_in(data_in1_5),.sram_addr(sram_addr1),.data_out(data_out1_5));
	bram photo1_6 (.clk(S_AXI_ACLK),.we(we1),.en(1),.data_in(data_in1_6),.sram_addr(sram_addr1),.data_out(data_out1_6));
	bram photo1_7 (.clk(S_AXI_ACLK),.we(we1),.en(1),.data_in(data_in1_7),.sram_addr(sram_addr1),.data_out(data_out1_7));
	bram photo1_8 (.clk(S_AXI_ACLK),.we(we1),.en(1),.data_in(data_in1_8),.sram_addr(sram_addr1),.data_out(data_out1_8));	
	reg [5:0] i2;
	reg  we2;
	reg [10:0] sram_addr2;
	reg [8:0] data_in2_1;
	wire [8:0] data_out2_1;
	reg [8:0] data_in2_2;
	wire [8:0] data_out2_2;
	reg [8:0] data_in2_3;
	wire [8:0] data_out2_3;
	reg [8:0] data_in2_4;
	wire [8:0] data_out2_4;
	reg [8:0] data_in2_5;
	wire [8:0] data_out2_5;
	reg [8:0] data_in2_6;
	wire [8:0] data_out2_6;
	reg [8:0] data_in2_7;
	wire [8:0] data_out2_7;
	reg [8:0] data_in2_8;
	wire [8:0] data_out2_8;
	bram photo2_1 (.clk(S_AXI_ACLK),.we(we2),.en(1),.data_in(data_in2_1),.sram_addr(sram_addr2),.data_out(data_out2_1));
	bram photo2_2 (.clk(S_AXI_ACLK),.we(we2),.en(1),.data_in(data_in2_2),.sram_addr(sram_addr2),.data_out(data_out2_2));
	bram photo2_3 (.clk(S_AXI_ACLK),.we(we2),.en(1),.data_in(data_in2_3),.sram_addr(sram_addr2),.data_out(data_out2_3));
	bram photo2_4 (.clk(S_AXI_ACLK),.we(we2),.en(1),.data_in(data_in2_4),.sram_addr(sram_addr2),.data_out(data_out2_4));
	bram photo2_5 (.clk(S_AXI_ACLK),.we(we2),.en(1),.data_in(data_in2_5),.sram_addr(sram_addr2),.data_out(data_out2_5));
	bram photo2_6 (.clk(S_AXI_ACLK),.we(we2),.en(1),.data_in(data_in2_6),.sram_addr(sram_addr2),.data_out(data_out2_6));
	bram photo2_7 (.clk(S_AXI_ACLK),.we(we2),.en(1),.data_in(data_in2_7),.sram_addr(sram_addr2),.data_out(data_out2_7));
	bram photo2_8 (.clk(S_AXI_ACLK),.we(we2),.en(1),.data_in(data_in2_8),.sram_addr(sram_addr2),.data_out(data_out2_8));
	reg [5:0] i3;
	reg  we3;
	reg [10:0] sram_addr3;
	reg [8:0] data_in3_1;
	wire [8:0] data_out3_1;
	reg [8:0] data_in3_2;
	wire [8:0] data_out3_2;
	reg [8:0] data_in3_3;
	wire [8:0] data_out3_3;
	reg [8:0] data_in3_4;
	wire [8:0] data_out3_4;
	reg [8:0] data_in3_5;
	wire [8:0] data_out3_5;
	reg [8:0] data_in3_6;
	wire [8:0] data_out3_6;
	reg [8:0] data_in3_7;
	wire [8:0] data_out3_7;
	reg [8:0] data_in3_8;
	wire [8:0] data_out3_8;
	bram photo3_1 (.clk(S_AXI_ACLK),.we(we3),.en(1),.data_in(data_in3_1),.sram_addr(sram_addr3),.data_out(data_out3_1));
	bram photo3_2 (.clk(S_AXI_ACLK),.we(we3),.en(1),.data_in(data_in3_2),.sram_addr(sram_addr3),.data_out(data_out3_2));
	bram photo3_3 (.clk(S_AXI_ACLK),.we(we3),.en(1),.data_in(data_in3_3),.sram_addr(sram_addr3),.data_out(data_out3_3));
	bram photo3_4 (.clk(S_AXI_ACLK),.we(we3),.en(1),.data_in(data_in3_4),.sram_addr(sram_addr3),.data_out(data_out3_4));
	bram photo3_5 (.clk(S_AXI_ACLK),.we(we3),.en(1),.data_in(data_in3_5),.sram_addr(sram_addr3),.data_out(data_out3_5));
	bram photo3_6 (.clk(S_AXI_ACLK),.we(we3),.en(1),.data_in(data_in3_6),.sram_addr(sram_addr3),.data_out(data_out3_6));
	bram photo3_7 (.clk(S_AXI_ACLK),.we(we3),.en(1),.data_in(data_in3_7),.sram_addr(sram_addr3),.data_out(data_out3_7));
	bram photo3_8 (.clk(S_AXI_ACLK),.we(we3),.en(1),.data_in(data_in3_8),.sram_addr(sram_addr3),.data_out(data_out3_8));
	reg [5:0] i4;
	reg  we4;
	reg [10:0] sram_addr4;
	reg [8:0] data_in4_1;
	wire [8:0] data_out4_1;
	reg [8:0] data_in4_2;
	wire [8:0] data_out4_2;
	reg [8:0] data_in4_3;
	wire [8:0] data_out4_3;
	reg [8:0] data_in4_4;
	wire [8:0] data_out4_4;
	reg [8:0] data_in4_5;
	wire [8:0] data_out4_5;
	reg [8:0] data_in4_6;
	wire [8:0] data_out4_6;
	reg [8:0] data_in4_7;
	wire [8:0] data_out4_7;
	reg [8:0] data_in4_8;
	wire [8:0] data_out4_8;
	bram photo4_1 (.clk(S_AXI_ACLK),.we(we4),.en(1),.data_in(data_in4_1),.sram_addr(sram_addr4),.data_out(data_out4_1));
	bram photo4_2 (.clk(S_AXI_ACLK),.we(we4),.en(1),.data_in(data_in4_2),.sram_addr(sram_addr4),.data_out(data_out4_2));
	bram photo4_3 (.clk(S_AXI_ACLK),.we(we4),.en(1),.data_in(data_in4_3),.sram_addr(sram_addr4),.data_out(data_out4_3));
	bram photo4_4 (.clk(S_AXI_ACLK),.we(we4),.en(1),.data_in(data_in4_4),.sram_addr(sram_addr4),.data_out(data_out4_4));
	bram photo4_5 (.clk(S_AXI_ACLK),.we(we4),.en(1),.data_in(data_in4_5),.sram_addr(sram_addr4),.data_out(data_out4_5));
	bram photo4_6 (.clk(S_AXI_ACLK),.we(we4),.en(1),.data_in(data_in4_6),.sram_addr(sram_addr4),.data_out(data_out4_6));
	bram photo4_7 (.clk(S_AXI_ACLK),.we(we4),.en(1),.data_in(data_in4_7),.sram_addr(sram_addr4),.data_out(data_out4_7));
	bram photo4_8 (.clk(S_AXI_ACLK),.we(we4),.en(1),.data_in(data_in4_8),.sram_addr(sram_addr4),.data_out(data_out4_8));
	
	// I/O Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RVALID	= axi_rvalid;
	// Implement axi_awready generation
	// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	// de-asserted when reset is low.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awready <= 1'b0;
	      aw_en <= 1'b1;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // slave is ready to accept write address when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_awready <= 1'b1;
	          aw_en <= 1'b0;
	        end
	        else if (S_AXI_BREADY && axi_bvalid)
	            begin
	              aw_en <= 1'b1;
	              axi_awready <= 1'b0;
	            end
	      else           
	        begin
	          axi_awready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_awaddr latching
	// This process is used to latch the address when both 
	// S_AXI_AWVALID and S_AXI_WVALID are valid. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awaddr <= 0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // Write Address latching 
	          axi_awaddr <= S_AXI_AWADDR;
	        end
	    end 
	end       

	// Implement axi_wready generation
	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	// de-asserted when reset is low. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_wready <= 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
	        begin
	          // slave is ready to accept write data when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_wready <= 1'b1;
	        end
	      else
	        begin
	          axi_wready <= 1'b0;
	        end
	    end 
	end       

	// Implement memory mapped register select and write logic generation
	// The write data is accepted and written to memory mapped registers when
	// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	// select byte enables of slave registers while writing.
	// These registers are cleared when reset (active low) is applied.
	// Slave register write enable is asserted when valid address and data are available
	// and the slave is ready to accept the write address and write data.
	assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      slv_reg0 <= 0;
	      slv_reg1 <= 0;
	      slv_reg2 <= 0;
	      slv_reg3 <= 0;
	      slv_reg4 <= 0;
	      slv_reg5 <= 0;
	      slv_reg6 <= 0;
	      slv_reg7 <= 0;
	      slv_reg8 <= 0;
	      slv_reg9 <= 0;
	      slv_reg10 <= 0;
	      slv_reg11 <= 0;
	      slv_reg12 <= 0;
	      slv_reg13 <= 0;
	    end 
	  else begin
	    if(i==3||i1==3||i2==3||i3==3||i4==3)
		  begin
			slv_reg9<=0;
		  end
		else if(count==12&&face_select==0)
		  begin
		    slv_reg10<=result;
		  end
		else if(count==12&&face_select==1)
		  begin
		    slv_reg11<=result;
		  end
		else if(count==12&&face_select==2)
		  begin
		    slv_reg12<=result;
		  end
		else if(count==12&&face_select==3)
		  begin
		    slv_reg13<=result;
		  end
		else if(count==13&&face_select==3)
		  begin
		    slv_reg9<=0;
		  end
	    else if (slv_reg_wren)
	      begin
	        case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	          4'h0:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 0
	                slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          4'h1:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 1
	                slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          4'h2:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 2
	                slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          4'h3:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 3
	                slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          4'h4:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 4
	                slv_reg4[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          4'h5:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 5
	                slv_reg5[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          4'h6:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg6[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          4'h7:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 7
	                slv_reg7[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          4'h8:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 8
	                slv_reg8[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          4'h9:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 9
	                slv_reg9[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          4'hA:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 10
	                slv_reg10[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          4'hB:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 11
	                slv_reg11[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          4'hC:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 12
	                slv_reg12[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          4'hD:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 13
	                slv_reg13[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          default : begin
	                      slv_reg0 <= slv_reg0;
	                      slv_reg1 <= slv_reg1;
	                      slv_reg2 <= slv_reg2;
	                      slv_reg3 <= slv_reg3;
	                      slv_reg4 <= slv_reg4;
	                      slv_reg5 <= slv_reg5;
	                      slv_reg6 <= slv_reg6;
	                      slv_reg7 <= slv_reg7;
	                      slv_reg8 <= slv_reg8;
	                      slv_reg9 <= slv_reg9;
	                      slv_reg10 <= slv_reg10;
	                      slv_reg11 <= slv_reg11;
	                      slv_reg12 <= slv_reg12;
	                      slv_reg13 <= slv_reg13;
	                    end
	        endcase
	      end
	  end
	end    

	// Implement write response logic generation
	// The write response and response valid signals are asserted by the slave 
	// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	// This marks the acceptance of address and indicates the status of 
	// write transaction.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_bvalid  <= 0;
	      axi_bresp   <= 2'b0;
	    end 
	  else
	    begin    
	      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
	        begin
	          // indicates a valid write response is available
	          axi_bvalid <= 1'b1;
	          axi_bresp  <= 2'b0; // 'OKAY' response 
	        end                   // work error responses in future
	      else
	        begin
	          if (S_AXI_BREADY && axi_bvalid) 
	            //check if bready is asserted while bvalid is high) 
	            //(there is a possibility that bready is always asserted high)   
	            begin
	              axi_bvalid <= 1'b0; 
	            end  
	        end
	    end
	end   

	// Implement axi_arready generation
	// axi_arready is asserted for one S_AXI_ACLK clock cycle when
	// S_AXI_ARVALID is asserted. axi_awready is 
	// de-asserted when reset (active low) is asserted. 
	// The read address is also latched when S_AXI_ARVALID is 
	// asserted. axi_araddr is reset to zero on reset assertion.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_arready <= 1'b0;
	      axi_araddr  <= 32'b0;
	    end 
	  else
	    begin    
	      if (~axi_arready && S_AXI_ARVALID)
	        begin
	          // indicates that the slave has acceped the valid read address
	          axi_arready <= 1'b1;
	          // Read address latching
	          axi_araddr  <= S_AXI_ARADDR;
	        end
	      else
	        begin
	          axi_arready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_arvalid generation
	// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	// S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	// data are available on the axi_rdata bus at this instance. The 
	// assertion of axi_rvalid marks the validity of read data on the 
	// bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	// is deasserted on reset (active low). axi_rresp and axi_rdata are 
	// cleared to zero on reset (active low).  
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rvalid <= 0;
	      axi_rresp  <= 0;
	    end 
	  else
	    begin    
	      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
	        begin
	          // Valid read data is available at the read data bus
	          axi_rvalid <= 1'b1;
	          axi_rresp  <= 2'b0; // 'OKAY' response
	        end   
	      else if (axi_rvalid && S_AXI_RREADY)
	        begin
	          // Read data is accepted by the master
	          axi_rvalid <= 1'b0;
	        end                
	    end
	end    

	// Implement memory mapped register select and read logic generation
	// Slave register read enable is asserted when valid address is available
	// and the slave is ready to accept the read address.
	assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
	always @(*)
	begin
	      // Address decoding for reading registers
	      case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	        4'h0   : reg_data_out <= slv_reg0;
	        4'h1   : reg_data_out <= slv_reg1;
	        4'h2   : reg_data_out <= slv_reg2;
	        4'h3   : reg_data_out <= slv_reg3;
	        4'h4   : reg_data_out <= slv_reg4;
	        4'h5   : reg_data_out <= slv_reg5;
	        4'h6   : reg_data_out <= slv_reg6;
	        4'h7   : reg_data_out <= slv_reg7;
	        4'h8   : reg_data_out <= slv_reg8;
	        4'h9   : reg_data_out <= slv_reg9;
	        4'hA   : reg_data_out <= slv_reg10;
	        4'hB   : reg_data_out <= slv_reg11;
	        4'hC   : reg_data_out <= slv_reg12;
	        4'hD   : reg_data_out <= slv_reg13;
	        default : reg_data_out <= 0;
	      endcase
	end

	// Output register or memory read data
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rdata  <= 0;
	    end 
	  else
	    begin    
	      // When there is a valid read address (S_AXI_ARVALID) with 
	      // acceptance of read address by the slave (axi_arready), 
	      // output the read dada 
	      if (slv_reg_rden)
	        begin
	          axi_rdata <= reg_data_out;     // register read data
	        end   
	    end
	end    

	// Add user logic here
//-------------------------------------------GROUP----------------------------------------------------
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in_1<=0;
	    end 
	  else if(slv_reg9==2'b10)
	    begin    
			data_in_1<={1'b0,slv_reg0[(31-i*8)-:8]};
	    end
	end

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in_2<=0;
	    end 
	  else if(slv_reg9==2'b10)
	    begin    
			data_in_2<={1'b0,slv_reg1[(31-i*8)-:8]};
	    end
	end    
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in_3<=0;
	    end 
	  else if(slv_reg9==2'b10)
	    begin    
			data_in_3<={1'b0,slv_reg2[(31-i*8)-:8]};
	    end
	end    
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in_4<=0;
	    end 
	  else if(slv_reg9==2'b10)
	    begin    
			data_in_4<={1'b0,slv_reg3[(31-i*8)-:8]};
	    end
	end    
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in_5<=0;
	    end 
	  else if(slv_reg9==2'b10)
	    begin    
			data_in_5<={1'b0,slv_reg4[(31-i*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in_6<=0;
	    end 
	  else if(slv_reg9==2'b10)
	    begin    
			data_in_6<={1'b0,slv_reg5[(31-i*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in_7<=0;
	    end 
	  else if(slv_reg9==2'b10)
	    begin    
			data_in_7<={1'b0,slv_reg6[(31-i*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in_8<=0;
	    end 
	  else if(slv_reg9==2'b10)
	    begin    
			data_in_8<={1'b0,slv_reg7[(31-i*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			sram_addr<=0;
	    end
      else if(slv_reg9==1'b1)
	    begin    
			sram_addr<=(j+(slv_reg8+1)*4)%128;
		end		
	  else if(slv_reg9==2'b10)
	    begin    
			sram_addr<=slv_reg8*4+i;
		end
	  else
	    begin
			sram_addr<=0;
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			we<=0;
	    end 
	  else if(slv_reg9==2'b10)
	    begin    
			we<=1;
		end
	  else
	    begin
			we<=0;
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			i<=0;
	    end
      else if(i==3&&slv_reg9==2'b10)
	    begin    
			i<=3;
		end		
	  else if(slv_reg9==2'b10)
	    begin    
			i<=i+1;
		end
	  else
	    begin
			i<=0;
		end
	end
//-----------------------------------------------------------------------------------------------	
//----------------------------------------------PHOTO1-------------------------------------------------
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in1_1<=0;
	    end 
	  else if(slv_reg9==2'b11)
	    begin    
			data_in1_1<={1'b0,slv_reg0[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in1_2<=0;
	    end 
	  else if(slv_reg9==2'b11)
	    begin    
			data_in1_2<={1'b0,slv_reg1[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in1_3<=0;
	    end 
	  else if(slv_reg9==2'b11)
	    begin   
			data_in1_3<={1'b0,slv_reg2[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in1_4<=0;
	    end 
	  else if(slv_reg9==2'b11)
	    begin    
 			data_in1_4<={1'b0,slv_reg3[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in1_5<=0;
	    end 
	  else if(slv_reg9==2'b11)
	    begin    
			data_in1_5<={1'b0,slv_reg4[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in1_6<=0;
	    end 
	  else if(slv_reg9==2'b11)
	    begin    
			data_in1_6<={1'b0,slv_reg5[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in1_7<=0;
	    end 
	  else if(slv_reg9==2'b11)
	    begin    
			data_in1_7<={1'b0,slv_reg6[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in1_8<=0;
	    end 
	  else if(slv_reg9==2'b11)
	    begin    
			data_in1_8<={1'b0,slv_reg7[(31-i1*8)-:8]}; 
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			sram_addr1<=0;
	    end
	  else if(slv_reg9==1'b1)
	    begin    
			sram_addr1<=j;
		end
	  else if(slv_reg9==2'b11)
	    begin    
			sram_addr1<=slv_reg8*4+i1;
		end
	  else
	    begin
			sram_addr1<=0;
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			we1<=0;
	    end 
	  else if(slv_reg9==2'b11)
	    begin    
			we1<=1;
		end
	  else
	    begin
			we1<=0;
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			i1<=0;
	    end
      else if(i1==3&&slv_reg9==2'b11)
	    begin    
			i1<=3;
		end		
	  else if(slv_reg9==2'b11)
	    begin    
			i1<=i1+1;
		end
	  else
	    begin
			i1<=0;
		end
	end
//-----------------------------------------------------------------------------------------------
//----------------------------------------------PHOTO2-------------------------------------------------
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in2_1<=0;
	    end 
	  else if(slv_reg9==3'b100)
	    begin    
			data_in2_1<={1'b0,slv_reg0[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in2_2<=0;
	    end 
	  else if(slv_reg9==3'b100)
	    begin    
			data_in2_2<={1'b0,slv_reg1[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in2_3<=0;
	    end 
	  else if(slv_reg9==3'b100)
	    begin   
			data_in2_3<={1'b0,slv_reg2[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in2_4<=0;
	    end 
	  else if(slv_reg9==3'b100)
	    begin    
 			data_in2_4<={1'b0,slv_reg3[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in2_5<=0;
	    end 
	  else if(slv_reg9==3'b100)
	    begin    
			data_in2_5<={1'b0,slv_reg4[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in2_6<=0;
	    end 
	  else if(slv_reg9==3'b100)
	    begin    
			data_in2_6<={1'b0,slv_reg5[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in2_7<=0;
	    end 
	  else if(slv_reg9==3'b100)
	    begin    
			data_in2_7<={1'b0,slv_reg6[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in2_8<=0;
	    end 
	  else if(slv_reg9==3'b100)
	    begin    
			data_in2_8<={1'b0,slv_reg7[(31-i1*8)-:8]}; 
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			sram_addr2<=0;
	    end
	  else if(slv_reg9==1'b1)
	    begin    
			sram_addr2<=j;
		end
	  else if(slv_reg9==3'b100)
	    begin    
			sram_addr2<=slv_reg8*4+i2;
		end
	  else
	    begin
			sram_addr2<=0;
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			we2<=0;
	    end 
	  else if(slv_reg9==3'b100)
	    begin    
			we2<=1;
		end
	  else
	    begin
			we2<=0;
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			i2<=0;
	    end
      else if(i2==3&&slv_reg9==3'b100)
	    begin    
			i2<=3;
		end		
	  else if(slv_reg9==3'b100)
	    begin    
			i2<=i2+1;
		end
	  else
	    begin
			i2<=0;
		end
	end
//-----------------------------------------------------------------------------------------------
//----------------------------------------------PHOTO3-------------------------------------------------
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in3_1<=0;
	    end 
	  else if(slv_reg9==3'b101)
	    begin    
			data_in3_1<={1'b0,slv_reg0[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in3_2<=0;
	    end 
	  else if(slv_reg9==3'b101)
	    begin    
			data_in3_2<={1'b0,slv_reg1[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in3_3<=0;
	    end 
	  else if(slv_reg9==3'b101)
	    begin   
			data_in3_3<={1'b0,slv_reg2[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in3_4<=0;
	    end 
	  else if(slv_reg9==3'b101)
	    begin    
 			data_in3_4<={1'b0,slv_reg3[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in3_5<=0;
	    end 
	  else if(slv_reg9==3'b101)
	    begin    
			data_in3_5<={1'b0,slv_reg4[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in3_6<=0;
	    end 
	  else if(slv_reg9==3'b101)
	    begin    
			data_in3_6<={1'b0,slv_reg5[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in3_7<=0;
	    end 
	  else if(slv_reg9==3'b101)
	    begin    
			data_in3_7<={1'b0,slv_reg6[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in3_8<=0;
	    end 
	  else if(slv_reg9==3'b101)
	    begin    
			data_in3_8<={1'b0,slv_reg7[(31-i1*8)-:8]}; 
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			sram_addr3<=0;
	    end
	  else if(slv_reg9==1'b1)
	    begin    
			sram_addr3<=j;
		end
	  else if(slv_reg9==3'b101)
	    begin    
			sram_addr3<=slv_reg8*4+i3;
		end
	  else
	    begin
			sram_addr3<=0;
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			we3<=0;
	    end 
	  else if(slv_reg9==3'b101)
	    begin    
			we3<=1;
		end
	  else
	    begin
			we3<=0;
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			i3<=0;
	    end
      else if(i3==3&&slv_reg9==3'b101)
	    begin    
			i3<=3;
		end		
	  else if(slv_reg9==3'b101)
	    begin    
			i3<=i3+1;
		end
	  else
	    begin
			i3<=0;
		end
	end
//-----------------------------------------------------------------------------------------------
//----------------------------------------------PHOTO4-------------------------------------------------
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in4_1<=0;
	    end 
	  else if(slv_reg9==3'b110)
	    begin    
			data_in4_1<={1'b0,slv_reg0[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in4_2<=0;
	    end 
	  else if(slv_reg9==3'b110)
	    begin    
			data_in4_2<={1'b0,slv_reg1[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in4_3<=0;
	    end 
	  else if(slv_reg9==3'b110)
	    begin   
			data_in4_3<={1'b0,slv_reg2[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in4_4<=0;
	    end 
	  else if(slv_reg9==3'b110)
	    begin    
 			data_in4_4<={1'b0,slv_reg3[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in4_5<=0;
	    end 
	  else if(slv_reg9==3'b110)
	    begin    
			data_in4_5<={1'b0,slv_reg4[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in4_6<=0;
	    end 
	  else if(slv_reg9==3'b110)
	    begin    
			data_in4_6<={1'b0,slv_reg5[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in4_7<=0;
	    end 
	  else if(slv_reg9==3'b110)
	    begin    
			data_in4_7<={1'b0,slv_reg6[(31-i1*8)-:8]};
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			data_in4_8<=0;
	    end 
	  else if(slv_reg9==3'b110)
	    begin    
			data_in4_8<={1'b0,slv_reg7[(31-i1*8)-:8]}; 
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			sram_addr4<=0;
	    end
	  else if(slv_reg9==1'b1)
	    begin    
			sram_addr4<=j;
		end
	  else if(slv_reg9==3'b110)
	    begin    
			sram_addr4<=slv_reg8*4+i4;
		end
	  else
	    begin
			sram_addr4<=0;
	    end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			we4<=0;
	    end 
	  else if(slv_reg9==3'b110)
	    begin    
			we4<=1;
		end
	  else
	    begin
			we4<=0;
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			i4<=0;
	    end
      else if(i4==3&&slv_reg9==3'b110)
	    begin    
			i4<=3;
		end		
	  else if(slv_reg9==3'b110)
	    begin    
			i4<=i4+1;
		end
	  else
	    begin
			i4<=0;
		end
	end
//-----------------------------------------------------------------------------------------------
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			j<=0;
	    end
	  else if(count==15)
	    begin
			j<=0;
		end
      else if(j==130 && slv_reg9==1'b1)
	    begin    
			j<=130;
		end		
	  else if(slv_reg9==1'b1)
	    begin    
			j<=j+1;
		end
	  else
	    begin
			j<=0;
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			face_select<=0;
	    end
	  else if(count==15)
	    begin
			face_select<=face_select+1;
		end
	  else if(slv_reg9==1'b1)
	    begin
			face_select<=face_select;
		end
	  else
	    begin
			face_select<=0;
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
			count<=0;
	    end
      else if(j==130)
	    begin    
			count<=count+1;
		end		
	  else
	    begin
			count<=0;
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if(j>1&&j<130&&face_select==0)
	    begin    
			diff[j-2]<=data_out_1-data_out1_1;
			diff[j+126]<=data_out_2-data_out1_2;
			diff[j+254]<=data_out_3-data_out1_3;
			diff[j+382]<=data_out_4-data_out1_4;
			diff[j+510]<=data_out_5-data_out1_5;
			diff[j+638]<=data_out_6-data_out1_6;
			diff[j+766]<=data_out_7-data_out1_7;
			diff[j+894]<=data_out_8-data_out1_8;
		end
	  else if(j>1&&j<130&&face_select==1)
	    begin    
			diff[j-2]<=data_out_1-data_out2_1;
			diff[j+126]<=data_out_2-data_out2_2;
			diff[j+254]<=data_out_3-data_out2_3;
			diff[j+382]<=data_out_4-data_out2_4;
			diff[j+510]<=data_out_5-data_out2_5;
			diff[j+638]<=data_out_6-data_out2_6;
			diff[j+766]<=data_out_7-data_out2_7;
			diff[j+894]<=data_out_8-data_out2_8;
		end
	  else if(j>1&&j<130&&face_select==2)
	    begin    
			diff[j-2]<=data_out_1-data_out3_1;
			diff[j+126]<=data_out_2-data_out3_2;
			diff[j+254]<=data_out_3-data_out3_3;
			diff[j+382]<=data_out_4-data_out3_4;
			diff[j+510]<=data_out_5-data_out3_5;
			diff[j+638]<=data_out_6-data_out3_6;
			diff[j+766]<=data_out_7-data_out3_7;
			diff[j+894]<=data_out_8-data_out3_8;
		end
	  else if(j>1&&j<130&&face_select==3)
	    begin    
			diff[j-2]<=data_out_1-data_out4_1;
			diff[j+126]<=data_out_2-data_out4_2;
			diff[j+254]<=data_out_3-data_out4_3;
			diff[j+382]<=data_out_4-data_out4_4;
			diff[j+510]<=data_out_5-data_out4_5;
			diff[j+638]<=data_out_6-data_out4_6;
			diff[j+766]<=data_out_7-data_out4_7;
			diff[j+894]<=data_out_8-data_out4_8;
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if(j==130)
	    begin    
			for(x=0;x<1024;x=x+1)
			  begin
			    abs_diff[x]<=(diff[x][8] == 1'b1)? -diff[x] : diff[x];
			  end
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if(j==130)
	    begin    
			for(x=0;x<512;x=x+1)
			  begin
			    partial_sum1[x]<=abs_diff[2*x]+abs_diff[2*x+1];
			  end
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if(j==130)
	    begin    
			for(x=0;x<256;x=x+1)
			  begin
			    partial_sum2[x]<=partial_sum1[2*x]+partial_sum1[2*x+1];
			  end
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if(j==130)
	    begin    
			for(x=0;x<128;x=x+1)
			  begin
			    partial_sum3[x]<=partial_sum2[2*x]+partial_sum2[2*x+1];
			  end
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if(j==130)
	    begin    
			for(x=0;x<64;x=x+1)
			  begin
			    partial_sum4[x]<=partial_sum3[2*x]+partial_sum3[2*x+1];
			  end
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if(j==130)
	    begin    
			for(x=0;x<32;x=x+1)
			  begin
			    partial_sum5[x]<=partial_sum4[2*x]+partial_sum4[2*x+1];
			  end
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if(j==130)
	    begin    
			for(x=0;x<16;x=x+1)
			  begin
			    partial_sum6[x]<=partial_sum5[2*x]+partial_sum5[2*x+1];
			  end
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if(j==130)
	    begin    
			for(x=0;x<8;x=x+1)
			  begin
			    partial_sum7[x]<=partial_sum6[2*x]+partial_sum6[2*x+1];
			  end
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if(j==130)
	    begin    
			for(x=0;x<4;x=x+1)
			  begin
			    partial_sum8[x]<=partial_sum7[2*x]+partial_sum7[2*x+1];
			  end
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if(j==130)
	    begin    
			for(x=0;x<2;x=x+1)
			  begin
			    partial_sum9[x]<=partial_sum8[2*x]+partial_sum8[2*x+1];
			  end
		end
	end
	
	always @( posedge S_AXI_ACLK )
	begin
	  if(j==130)
	    begin    
			result<=partial_sum9[0]+partial_sum9[1];
		end
	end
	// User logic ends

	endmodule
	
	module bram(
        input wire clk, // System clock
        input wire we, // When high RAM sets data in input lines to given address
        input wire en,
        input wire [8:0] data_in, // Data lines to write to memory
        input wire [10:0] sram_addr,
        output reg [8:0] data_out // Data out
	);

	reg [8:0] sram[0:130];

	always @(posedge clk) begin // Write data into the SRAM block
	if (en && we) begin
	sram[sram_addr] <= data_in;
	end
	end
	always @(posedge clk) begin // Read data from the SRAM block
	if (en && we) // If data is being written into SRAM,
	data_out <= data_in; // forward the data to the read port
	else if(sram_addr<0)
	data_out <= data_out;
	else
	data_out <= sram[sram_addr]; // Send data to the read port
	end
		
	endmodule
