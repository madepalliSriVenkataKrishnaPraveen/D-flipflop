class read_sequencer extends uvm_sequencer #(packet);
    `uvm_component_utils(read_sequencer)

    function new(string name = "read_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction


endclass