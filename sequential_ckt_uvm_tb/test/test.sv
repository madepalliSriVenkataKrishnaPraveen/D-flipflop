class test extends uvm_test;
`uvm_component_utils(test)
    environment envh;

    // configuration handles as we are configuring from the test class
    env_cfg m_cfg;

    //-----------------------------
    read_sequence1 read_seq1;
    write_sequence1 write_seq1;

    write_sequence2 write_seq2;
    write_sequence3 write_seq3;
    //-----------------------------
    // configuring the test bench hierarchy.
    bit has_write_agent = 1'b1;
    bit has_read_agent = 1'b1;
    bit has_sb = 1'b1;
    bit has_vseqr = 1'b1;
    int num_write_agent = 1;
    int num_read_agent = 1;

    function new(string name = "test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_cfg = env_cfg::type_id::create("m_cfg");  // obj for the env_cfg

        if(has_write_agent) begin
            m_cfg.m_wr_agent_cfg = new[num_write_agent];
            foreach(m_cfg.m_wr_agent_cfg[i]) begin
                m_cfg.m_wr_agent_cfg[i] = write_agent_cfg::type_id::create($sformatf("m_write_agent_cfg[%0d]",i));

                if(! uvm_config_db #(virtual interface1)::get(this,"","write_vif",m_cfg.m_wr_agent_cfg[i].vif))  // getting the config and setting it in the write agent configuration.
                    `uvm_fatal(get_type_name,"unable to get the config db, have you set it ?")

                
                m_cfg.m_wr_agent_cfg[i].is_active = UVM_ACTIVE;
            end

        end
        if(has_read_agent) begin
            m_cfg.m_rd_agent_cfg = new[num_read_agent];
            foreach(m_cfg.m_rd_agent_cfg[i]) begin
                m_cfg.m_rd_agent_cfg[i] = read_agent_cfg::type_id::create($sformatf("m_read_agent_cfg[%0d]", i));

                if(! uvm_config_db #(virtual interface1)::get(this,"","read_vif",m_cfg.m_rd_agent_cfg[i].vif))  // getting the config and setting it in the read agent configuration.
                    `uvm_fatal(get_type_name,"unable to get the config db, have you set it ?")

                m_cfg.m_rd_agent_cfg[i].is_active = UVM_PASSIVE;
            end

        end

        m_cfg.has_write_agent = has_write_agent;
        m_cfg.has_read_agent = has_read_agent;
        m_cfg.has_sb = has_sb;
        m_cfg.has_vseqr = has_vseqr;
        m_cfg.num_write_agent = num_write_agent;
        m_cfg.num_read_agent = num_read_agent;

        uvm_config_db #(env_cfg)::set(this,"*","env_cfg",m_cfg);   // setting the obj for the env_cfg
        envh = environment::type_id::create("envh",this);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

endclass

class demo_test extends test;
    `uvm_component_utils(demo_test)

   // demo_seq demo_seqh;

    function new(string name = "demo_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        fork 
          //  demo_seqh = demo_seq::type_id::create("demo_seqh");
            
           // demo_seqh.start(envh.vseqrh);
        if(m_cfg.m_wr_agent_cfg[0].is_active == UVM_ACTIVE) begin
            write_seq1 = write_sequence1::type_id::create("write_seq1");
            write_seq1.start(envh.wr_agt_top.agth[0].seqrh);
        end

        if(m_cfg.m_rd_agent_cfg[0].is_active == UVM_ACTIVE) begin
            read_seq1 = read_sequence1::type_id::create("read_seq1");
            read_seq1.start(envh.rd_agt_top.agth[0].seqrh);
        end   
    join
    #100;
        phase.drop_objection(this);
    endtask

endclass

class testcase1 extends test;
    `uvm_component_utils(testcase1)

    function new(string name = "testcase1", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        write_seq2 = write_sequence2::type_id::create("write_seq2");
        write_seq2.start(envh.wr_agt_top.agth[0].seqrh);
        #100;
        phase.drop_objection(this);
    endtask
endclass

class testcase2 extends test;
    `uvm_component_utils(testcase2)

    function new(string name = "testcase2", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        write_seq3 = write_sequence3::type_id::create("write_seq3");
        write_seq3.start(envh.wr_agt_top.agth[0].seqrh);
         #22;
        phase.drop_objection(this);
    endtask
endclass