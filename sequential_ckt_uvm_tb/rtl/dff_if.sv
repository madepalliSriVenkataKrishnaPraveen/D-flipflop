interface interface1(input bit clk);
// properties
logic rst,din,q,q_bar;

clocking wr_drv_cb@(posedge clk);
    default input #1 output #1;
    output din;
    output rst;
endclocking

clocking write_mon_cb@(posedge clk);
    default input #1 output #1;
    input din;
    input rst;
endclocking


clocking rd_drv_cb@(posedge clk);
    default input #1 output #1;
    
endclocking

clocking read_mon_cb@(posedge clk);
    default input #1 output #1;
    input q;
    input q_bar;
endclocking


modport WRITE_DRV_MP(clocking wr_drv_cb);
modport WRITE_MON_MP(clocking write_mon_cb);

modport READ_DRV_MP(clocking rd_drv_cb);
modport READ_MON_MP(clocking read_mon_cb);

endinterface : interface1