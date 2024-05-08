class write_monitor extends uvm_monitor;  // write_monitor 
    `uvm_component_utils(write_monitor)
    uvm_analysis_port #(packet) ana_write;   // To send data to scoreboard
    write_agent_cfg cfg;

    packet pkt;

   virtual interface1.WRITE_MON_MP vif;

    function new(string name = "write_monitor", uvm_component parent = null);
        super.new(name,parent);
        ana_write=new("ana_write",this);  // use ana_write.write(xtn); for sending the data to the scoreboard.
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(! uvm_config_db #(write_agent_cfg)::get(this,"","write_agent_cfg",cfg))
        `uvm_fatal("TF","cannot get the config")  // here the config db is for future use.
        pkt = packet::type_id::create("pkt");
        pkt.seq_name = get_type_name();
    endfunction


    task run_phase(uvm_phase phase);
         @(vif.write_mon_cb);
         $display("fwogvoiwmob ovwg write monitor%0t",$time);
        // @(vif.write_mon_cb);
        forever begin
             collect();
             `uvm_info(get_type_name,$sformatf("printing from the write monitor \n %s",pkt.sprint()),UVM_LOW)
             ana_write.write(pkt);
            //  @(vif.write_mon_cb);
        end

    endtask

    task collect();
        repeat(2) @(vif.write_mon_cb);
        pkt.din = vif.write_mon_cb.din;
        pkt.rst = vif.write_mon_cb.rst;
    endtask

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = cfg.vif;  // interface connection
    endfunction

endclass