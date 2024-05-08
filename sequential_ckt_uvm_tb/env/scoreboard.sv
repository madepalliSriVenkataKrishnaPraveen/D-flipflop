class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    uvm_tlm_analysis_fifo #(packet) fifo_write[];
    uvm_tlm_analysis_fifo #(packet) fifo_read[];

    env_cfg m_env_cfg;

    packet read_pkt,write_pkt;

    function new(string name = "scoreboard",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(! uvm_config_db #(env_cfg)::get(this,"","env_cfg",m_env_cfg))
            `uvm_fatal("CONFIG","cannot get the env_cfg")

        fifo_read = new[m_env_cfg.num_read_agent];
        fifo_write = new[m_env_cfg.num_write_agent];

        // create the tlm analysis fifo
        foreach(fifo_read[i]) 
                fifo_read[i] = new($sformatf("fifo_read[%0d]",i),this);
        foreach(fifo_write[i])
                fifo_write[i] = new($sformatf("fifo_write[%0d]",i),this);
    endfunction


        task run_phase(uvm_phase phase);
            forever begin
                foreach(fifo_write[i]) begin
                    fifo_write[i].get(write_pkt);
                    write_pkt.seq_name = "write_seq_sb_pkt";
                end
                foreach(fifo_read[i]) begin
                    fifo_read[i].get(read_pkt);
                    read_pkt.seq_name = "read_seq_sb_pkt";
                end

                compare();
            end
        endtask

        task compare();
          // `uvm_info(get_type_name,$sformatf("printing from the scoreboard write monitor \n %s",write_pkt.sprint()),UVM_LOW)
          // `uvm_info(get_type_name,$sformatf("printing from the scoreboard read monitor \n %s",read_pkt.sprint()),UVM_LOW)

            if(!write_pkt.rst) begin
                if((read_pkt.q == write_pkt.din) && (read_pkt.q != read_pkt.q_bar))
                `uvm_info(get_type_name,"COMPARSION SUCCESSFUL",UVM_NONE)
                else
                    `uvm_error(get_type_name,"COMPARSION FAILED-------------!")
            end
            else // if rst == 1
                begin
                    if(read_pkt.q == 1'b0 && read_pkt.q != read_pkt.q_bar)
                    `uvm_info(get_type_name,"COMPARSION SUCCESSFUL",UVM_NONE)
                    else
                        `uvm_error(get_type_name,"COMPARSION FAILED-------------!") 
                end

        endtask
        
        function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
            
    endfunction 
endclass