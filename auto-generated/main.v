`timescale	1ps / 1ps
////////////////////////////////////////////////////////////////////////////////
//
// Filename:	../auto-generated/main.v
//
// Project:	AutoFPGA basic peripheral demonstration project
//
// DO NOT EDIT THIS FILE!
// Computer Generated: This file is computer generated by AUTOFPGA. DO NOT EDIT.
// DO NOT EDIT THIS FILE!
//
// CmdLine:	/home/dan/work/rnd/opencores/autofpga/trunk/sw/autofpga /home/dan/work/rnd/opencores/autofpga/trunk/sw/autofpga -d autofpga.dbg -o ../auto-generated global.txt bkram.txt buserr.txt clock.txt hexbus.txt fixdata.txt pwrcount.txt rawreg.txt simhalt.txt version.txt spio.txt
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2017, Gisselquist Technology, LLC
//
// This file is part of the AutoFPGA peripheral demonstration project.
//
// The AutoFPGA peripheral demonstration project is free software (firmware):
// you can redistribute it and/or modify it under the terms of the GNU Lesser
// General Public License as published by the Free Software Foundation, either
// version 3 of the License, or (at your option) any later version.
//
// The AutoFPGA peripheral demonstration project is distributed in the hope
// that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTIBILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  (It's in the $(ROOT)/doc directory.  Run make
// with no target there if the PDF file isn't present.)  If not, see
// <http://www.gnu.org/licenses/> for a copy.
//
// License:	LGPL, v3, as defined and found on www.gnu.org,
//		http://www.gnu.org/licenses/lgpl.html
//
//
////////////////////////////////////////////////////////////////////////////////
//
//
`default_nettype	none
//
//
// Here is a list of defines which may be used, post auto-design
// (not post-build), to turn particular peripherals (and bus masters)
// on and off.  In particular, to turn off support for a particular
// design component, just comment out its respective `define below.
//
// These lines are taken from the respective @ACCESS tags for each of our
// components.  If a component doesn't have an @ACCESS tag, it will not
// be listed here.
//
// First, the independent access fields for any bus masters
// And then for the independent peripherals
`define	SPIO_ACCESS
`define	BKRAM_ACCESS
//
// End of dependency list
//
//
//
//
// Finally, we define our main module itself.  We start with the list of
// I/O ports, or wires, passed into (or out of) the main function.
//
// These fields are copied verbatim from the respective I/O port lists,
// from the fields given by @MAIN.PORTLIST
//
module	main(i_clk, i_reset,
		// SPIO interface
		i_sw, i_btnc, i_btnd, i_btnl, i_btnr, i_btnu, o_led,
		o_simhalt,
 		// UART/host to wishbone interface
 		i_host_uart_rx, o_host_uart_tx);
//
// Any parameter definitions
//
// These are drawn from anything with a MAIN.PARAM definition.
// As they aren't connected to the toplevel at all, it would
// be best to use localparam over parameter, but here we don't
// check
	// SPIO interface
	localparam	NBTN=5,
			NLEDS=8,
			NSW=8;
//
// The next step is to declare all of the various ports that were just
// listed above.  
//
// The following declarations are taken from the values of the various
// @MAIN.IODECL keys.
//
	input	wire		i_clk;
// verilator lint_off UNUSED
	input	wire		i_reset;
	// verilator lint_on UNUSED
	input	wire	[(NSW-1):0]	i_sw;
	input	wire		i_btnc, i_btnd, i_btnl, i_btnr, i_btnu;
	output	wire	[(NLEDS-1):0]	o_led;
	output	reg	o_simhalt;
	input	wire		i_host_uart_rx;
	output	wire		o_host_uart_tx;
	// Make Verilator happy ... defining bus wires for lots of components
	// often ends up with unused wires lying around.  We'll turn off
	// Verilator's lint warning here that checks for unused wires.
	// verilator lint_off UNUSED



	//
	// Declaring interrupt lines
	//
	// These declarations come from the various components values
	// given under the @INT.<interrupt name>.WIRE key.
	//
	wire	spio_int;	// spio.INT.SPIO.WIRE


	//
	// Component declarations
	//
	// These declarations come from the @MAIN.DEFNS keys found in the
	// various components comprising the design.
	//
// Looking for string: MAIN.DEFNS
	wire	[(NBTN-1):0]	w_btn;
`include "builddate.v"
	reg	[19-1:0]	r_buserr_addr;
	reg	[31:0]	r_pwrcount_data;
	reg	[31:0]	r_rawreg_data;
	//
	//
	// UART interface
	//
	//
	localparam [23:0] BUSUART = 24'h64;	// 1000000 baud
	//
	wire	w_ck_uart, w_uart_tx;
	wire		rx_host_stb;
	wire	[7:0]	rx_host_data;
	wire		tx_host_stb;
	wire	[7:0]	tx_host_data;
	wire		tx_host_busy;


	//
	// Declaring interrupt vector wires
	//
	// These declarations come from the various components having
	// PIC and PIC.MAX keys.
	//
	//
	//
	// Define bus wires
	//
	//

	// Bus wb
	// Wishbone master wire definitions for bus: wb
	wire		wb_cyc, wb_stb, wb_we, wb_stall, wb_err,
			wb_none_sel;
	reg		wb_many_ack;
	wire	[18:0]	wb_addr;
	wire	[31:0]	wb_data;
	reg	[31:0]	wb_idata;
	wire	[3:0]	wb_sel;
	reg		wb_ack;

	// Wishbone slave definitions for bus wb(SIO), slave buserr
	wire		buserr_sel, buserr_ack, buserr_stall;
	wire	[31:0]	buserr_data;

	// Wishbone slave definitions for bus wb(SIO), slave fixdata
	wire		fixdata_sel, fixdata_ack, fixdata_stall;
	wire	[31:0]	fixdata_data;

	// Wishbone slave definitions for bus wb(SIO), slave pwrcount
	wire		pwrcount_sel, pwrcount_ack, pwrcount_stall;
	wire	[31:0]	pwrcount_data;

	// Wishbone slave definitions for bus wb(SIO), slave rawreg
	wire		rawreg_sel, rawreg_ack, rawreg_stall;
	wire	[31:0]	rawreg_data;

	// Wishbone slave definitions for bus wb(SIO), slave simhalt
	wire		simhalt_sel, simhalt_ack, simhalt_stall;
	wire	[31:0]	simhalt_data;

	// Wishbone slave definitions for bus wb(SIO), slave spio
	wire		spio_sel, spio_ack, spio_stall;
	wire	[31:0]	spio_data;

	// Wishbone slave definitions for bus wb(SIO), slave version
	wire		version_sel, version_ack, version_stall;
	wire	[31:0]	version_data;

	// Wishbone slave definitions for bus wb, slave wb_sio
	wire		wb_sio_sel, wb_sio_ack, wb_sio_stall;
	wire	[31:0]	wb_sio_data;

	// Wishbone slave definitions for bus wb, slave bkram
	wire		bkram_sel, bkram_ack, bkram_stall;
	wire	[31:0]	bkram_data;


	//
	// Peripheral address decoding
	//
	//
	//
	//
	// Select lines for bus: wb
	//
	// Address width: 19
	// Data width:    32
	//
	//
	
	assign	      buserr_sel = ((wb_sio_sel)&&(wb_addr[ 2: 0] ==  3'h0));
	assign	     fixdata_sel = ((wb_sio_sel)&&(wb_addr[ 2: 0] ==  3'h1));
	assign	    pwrcount_sel = ((wb_sio_sel)&&(wb_addr[ 2: 0] ==  3'h2));
	assign	      rawreg_sel = ((wb_sio_sel)&&(wb_addr[ 2: 0] ==  3'h3));
	assign	     simhalt_sel = ((wb_sio_sel)&&(wb_addr[ 2: 0] ==  3'h4));
	assign	        spio_sel = ((wb_sio_sel)&&(wb_addr[ 2: 0] ==  3'h5));
	assign	     version_sel = ((wb_sio_sel)&&(wb_addr[ 2: 0] ==  3'h6));
	assign	      wb_sio_sel = ((wb_addr[18:17] &  2'h3) ==  2'h1);
//x2	Was a master bus as well
	assign	       bkram_sel = ((wb_addr[18:17] &  2'h2) ==  2'h2);
	//

	//
	// BUS-LOGIC for wb
	//
	assign	wb_none_sel = (wb_stb)&&({
				wb_sio_sel,
				bkram_sel} == 0);

	//
	// many_ack
	//
	// It is also a violation of the bus protocol to produce multiple
	// acks at once and on the same clock.  In that case, the bus
	// can't decide which result to return.  Worse, if someone is waiting
	// for a return value, that value will never come since another ack
	// masked it.
	//
	// The other error that isn't tested for here, no would I necessarily
	// know how to test for it, is when peripherals return values out of
	// order.  Instead, I propose keeping that from happening by
	// guaranteeing, in software, that two peripherals are not accessed
	// immediately one after the other.
	//
	always @(posedge i_clk)
		case({		wb_sio_ack,
				bkram_ack})
			2'b00: wb_many_ack <= 1'b0;
			2'b10: wb_many_ack <= 1'b0;
			2'b01: wb_many_ack <= 1'b0;
			default: wb_many_ack <= (wb_cyc);
		endcase

	assign	wb_sio_stall = 1'b0;
	initial r_wb_sio_ack = 1'b0;
	always	@(posedge i_clk)
		r_wb_sio_ack <= (wb_stb)&&(wb_sio_sel);
	assign	wb_sio_ack = r_wb_sio_ack;
	reg	r_wb_sio_ack;
	reg	[31:0]	r_wb_sio_data;
	always	@(posedge i_clk)
		// mask        = 00000007
		// lgdw        = 2
		// unused_lsbs = 0
		casez( wb_addr[2:0] )
			3'h0: r_wb_sio_data <= buserr_data;
			3'h1: r_wb_sio_data <= fixdata_data;
			3'h2: r_wb_sio_data <= pwrcount_data;
			3'h3: r_wb_sio_data <= rawreg_data;
			3'h4: r_wb_sio_data <= simhalt_data;
			3'h5: r_wb_sio_data <= spio_data;
			default: r_wb_sio_data <= version_data;
		endcase
	assign	wb_sio_data = r_wb_sio_data;

	//
	// Finally, determine what the response is from the wb bus
	// bus
	//
	//
	//
	// wb_ack
	//
	// The returning wishbone ack is equal to the OR of every component that
	// might possibly produce an acknowledgement, gated by the CYC line.
	//
	// To return an ack here, a component must have a @SLAVE.TYPE tag.
	// Acks from any @SLAVE.TYPE of SINGLE and DOUBLE components have been
	// collected together (above) into wb_sio_ack and wb_dio_ack
	// respectively, which will appear ahead of any other device acks.
	//
	always @(posedge i_clk)
		wb_ack <= (wb_cyc)&&(|{ wb_sio_ack,
				bkram_ack });
	//
	// wb_idata
	//
	// This is the data returned on the bus.  Here, we select between a
	// series of bus sources to select what data to return.  The basic
	// logic is simply this: the data we return is the data for which the
	// ACK line is high.
	//
	// The last item on the list is chosen by default if no other ACK's are
	// true.  Although we might choose to return zeros in that case, by
	// returning something we can skimp a touch on the logic.
	//
	// Any peripheral component with a @SLAVE.TYPE value will be listed
	// here.
	//
	always @(posedge i_clk)
		if (wb_sio_ack)
			wb_idata <= wb_sio_data;
		else
			wb_idata <= bkram_data;
	assign	wb_stall =	((wb_sio_sel)&&(wb_sio_stall))
				||((bkram_sel)&&(bkram_stall));

	assign wb_err = ((wb_stb)&&(wb_none_sel))||(wb_many_ack);
	//
	// Declare the interrupt busses
	//
	// Interrupt busses are defined by anything with a @PIC tag.
	// The @PIC.BUS tag defines the name of the wire bus below,
	// while the @PIC.MAX tag determines the size of the bus width.
	//
	// For your peripheral to be assigned to this bus, it must have an
	// @INT.NAME.WIRE= tag to define the wire name of the interrupt line,
	// and an @INT.NAME.PIC= tag matching the @PIC.BUS tag of the bus
	// your interrupt will be assigned to.  If an @INT.NAME.ID tag also
	// exists, then your interrupt will be assigned to the position given
	// by the ID# in that tag.
	//


	//
	//
	// Now we turn to defining all of the parts and pieces of what
	// each of the various peripherals does, and what logic it needs.
	//
	// This information comes from the @MAIN.INSERT and @MAIN.ALT tags.
	// If an @ACCESS tag is available, an ifdef is created to handle
	// having the access and not.  If the @ACCESS tag is `defined above
	// then the @MAIN.INSERT code is executed.  If not, the @MAIN.ALT
	// code is exeucted, together with any other cleanup settings that
	// might need to take place--such as returning zeros to the bus,
	// or making sure all of the various interrupt wires are set to
	// zero if the component is not included.
	//
`ifdef	SPIO_ACCESS
	assign	w_btn = { i_btnc, i_btnd, i_btnl, i_btnr, i_btnu };

	spio #(.NBTN(NBTN), .NLEDS(NLEDS), .NSW(NSW)) spioi(i_clk,
		wb_cyc, (wb_stb)&&(spio_sel), wb_we, wb_data, wb_sel,
			spio_ack, spio_stall, spio_data,
		i_sw, w_btn, o_led, spio_int);
`else	// SPIO_ACCESS
	assign	w_btn    = 0;
	assign	o_led    = 0;

	// In the case that there is no spio peripheral responding on the wb bus
	reg	r_spio_ack;
	initial	r_spio_ack = 1'b0;
	always @(posedge i_clk)	r_spio_ack <= (wb_stb)&&(spio_sel);
	assign	spio_ack   = r_spio_ack;
	assign	spio_stall = 0;
	assign	spio_data  = 0;

	assign	spio_int = 1'b0;	// spio.INT.SPIO.WIRE
`endif	// SPIO_ACCESS

	assign	version_data = `DATESTAMP;
	always @(posedge i_clk)
		if (wb_err)
			r_buserr_addr <= wb_addr;
	assign	buserr_data = { {(32-2-19){1'b0}},
			r_buserr_addr, 2'b00 };
	initial	r_pwrcount_data = 32'h0;
	always @(posedge i_clk)
	if (r_pwrcount_data[31])
		r_pwrcount_data[30:0] <= r_pwrcount_data[30:0] + 1'b1;
	else
		r_pwrcount_data[31:0] <= r_pwrcount_data[31:0] + 1'b1;
	assign	pwrcount_data = r_pwrcount_data;
	initial	o_simhalt=1'b0;
	always @(posedge i_clk)
		if ((wb_stb)&&(wb_we)&&(simhalt_sel))
			o_simhalt <= wb_data[0];
	assign	simhalt_data = 32'h0;
	assign	fixdata_data = 32'h20170926;
`ifdef	BKRAM_ACCESS
	memdev #(.LGMEMSZ(20), .EXTRACLOCK(1))
		bkrami(i_clk,
			(wb_cyc), (wb_stb)&&(bkram_sel), wb_we,
				wb_addr[(20-3):0], wb_data, wb_sel,
				bkram_ack, bkram_stall, bkram_data);
`else	// BKRAM_ACCESS

	// In the case that there is no bkram peripheral responding on the wb bus
	reg	r_bkram_ack;
	initial	r_bkram_ack = 1'b0;
	always @(posedge i_clk)	r_bkram_ack <= (wb_stb)&&(bkram_sel);
	assign	bkram_ack   = r_bkram_ack;
	assign	bkram_stall = 0;
	assign	bkram_data  = 0;

`endif	// BKRAM_ACCESS

	initial	r_rawreg_data = 32'h0;
	always @(posedge i_clk)
		if ((wb_stb)&&(wb_we)&&(rawreg_sel))
			r_rawreg_data <= wb_data;
	assign	rawreg_data = r_rawreg_data;
	// The Host USB interface, to be used by the WB-UART bus
	rxuartlite	#(BUSUART) rcv(i_clk, i_host_uart_rx,
				rx_host_stb, rx_host_data);
	txuartlite	#(BUSUART) txv(i_clk, tx_host_stb, tx_host_data,
				o_host_uart_tx, tx_host_busy);

`ifndef	BUSPIC_ACCESS
	wire	w_bus_int;
	assign	w_bus_int = 1'b0;
`endif
	wire	[29:0]	wb_tmp_addr;
	hbbus	genbus(i_clk,
			rx_host_stb, rx_host_data,
			wb_cyc, wb_stb, wb_we, wb_tmp_addr, wb_data, wb_sel,
				wb_ack, wb_stall, wb_err, wb_idata,
			w_bus_int,
			tx_host_stb, tx_host_data, tx_host_busy);
	assign	wb_addr = wb_tmp_addr[(19-1):0];
	//
	//
	//


endmodule // main.v
