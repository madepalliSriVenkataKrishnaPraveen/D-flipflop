class read_monitor extends uvm_monitor;
    `uvm_component_utils(read_monitor)
    uvm_analysis_port #(packet) ana_read;
    virtual interface1.READ_MON_MP vif;  // interface connection
    read_agent_cfg cfg;

    packet pkt;

    function new(string name = "read_monitor",uvm_component parent = null);
        super.new(name,parent);
        ana_read=new("ana_read",this);  //creating analysis port
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(! uvm_config_db #(read_agent_cfg)::get(this,"","read_agent_cfg",cfg))
            `uvm_fatal(get_type_name,"unable to get the config db")

        pkt = packet::type_id::create("pkt");
        pkt.seq_name = get_type_name();
    endfunction


    task run_phase(uvm_phase phase);
        repeat(1) @(vif.read_mon_cb);
        $display("fwogvoiwmob ovwg read monitor %0t",$time);
        forever begin
             collect_data();
             `uvm_info(get_type_name,$sformatf("printing from the read monitor \n %s",pkt.sprint()),UVM_LOW)
             ana_read.write(pkt);
            // @(vif.read_mon_cb);
            end

    endtask

    task collect_data();
        repeat(2) @(vif.read_mon_cb);
        pkt.q = vif.read_mon_cb.q;
        pkt.q_bar = vif.read_mon_cb.q_bar;
    endtask

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = cfg.vif;
    endfunction

endclass