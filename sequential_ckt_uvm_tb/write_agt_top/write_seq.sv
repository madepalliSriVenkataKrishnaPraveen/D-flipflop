class write_base_seq extends uvm_sequence #(packet);
    `uvm_object_utils(write_base_seq)

    function new(string name = "write_base_seq");
        super.new(name);
    endfunction

    task body();
        req = packet::type_id::create("req");    
    endtask
endclass

class write_sequence1 extends write_base_seq;
    `uvm_object_utils(write_sequence1)

    function new(string name = "write_sequence1");
        super.new(name);
    endfunction

    task body();
        super.body();
        start_item(req);
        assert(req.randomize());
        req.seq_name = get_type_name();
       // `uvm_info("write_seq",$sformatf("printing from sequence \n %s",req.sprint()),UVM_LOW)
        finish_item(req);
    endtask
endclass

class write_sequence2 extends write_base_seq;
    `uvm_object_utils(write_sequence2)

    function new(string name = "write_sequence2");
        super.new(name);
    endfunction

    task body();
        super.body();
        repeat(10) begin
        start_item(req);
        assert(req.randomize());
        req.seq_name = get_type_name();
       // `uvm_info("write_seq",$sformatf("printing from sequence \n %s",req.sprint()),UVM_LOW)
        finish_item(req);
        end
    endtask
endclass

class write_sequence3 extends write_base_seq;
    `uvm_object_utils(write_sequence3)

    function new(string name = "write_sequence3");
        super.new(name);
    endfunction

    task body();
        super.body();
        repeat(5) begin
        start_item(req);
        assert(req.randomize() with {rst dist {1:= 3, 0:=7}; din dist {1:=9, 0:= 1};});
        req.seq_name = get_type_name();
        req.tag++;
        `uvm_info("write_seq",$sformatf("printing from sequence \n %s",req.sprint()),UVM_LOW)
        finish_item(req);
        end
    endtask
endclass