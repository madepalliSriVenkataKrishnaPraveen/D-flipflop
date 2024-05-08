module top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import pkg::*;
bit clk;
initial
forever begin : CLOCK
    #5 clk = ~clk;
end : CLOCK

interface1 write_vif(clk);
interface1 read_vif(clk);

// dut instantiation
//mod10 DUV(.clk(vif.clk),.resetn(vif.resetn),.mode(vif.mode),.d_in(vif.d_in),.d_out(vif.d_out));
 dff DUV(.clk(clk), .rst(write_vif.rst), .din(write_vif.din), .q(read_vif.q), .q_bar(read_vif.q_bar));

initial begin
    uvm_config_db #(virtual interface1)::set(null,"*","write_vif",write_vif);
    uvm_config_db #(virtual interface1)::set(null,"*","read_vif",read_vif);
    run_test();
end

endmodule