class write_driver extends uvm_driver #(packet);  // write_driver 
    `uvm_component_utils(write_driver)
   virtual interface1.WRITE_DRV_MP vif;  // interface connection
    write_agent_cfg cfg;

    function new(string name = "write_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(! uvm_config_db #(write_agent_cfg)::get(this,"","write_agent_cfg",cfg))
        `uvm_fatal("TF","cannot get the config")  // here the config db is for future use.

    endfunction


    task run_phase(uvm_phase phase);  
        vif.wr_drv_cb.din <= 0;
        vif.wr_drv_cb.rst <= 0;
        repeat(1) @(vif.wr_drv_cb); 
        $display("fwogvoiwmob ovwg driver %0t",$time);
       // vif.wr_drv_cb.rst <= 0;

        forever begin
            seq_item_port.get_next_item(req);
                `uvm_info("DRIVER",$sformatf("Printing from the driver \n %s",req.sprint()),UVM_LOW)
                drive(req);   // task 
            seq_item_port.item_done();
        end
    endtask
    task drive(packet pkt);
        //repeat(1) @(vif.wr_drv_cb);
         vif.wr_drv_cb.din <= pkt.din;
         vif.wr_drv_cb.rst <= pkt.rst;
        repeat(2) @(vif.wr_drv_cb);
        
    endtask


    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = cfg.vif;  // configuration connection
    endfunction

endclass