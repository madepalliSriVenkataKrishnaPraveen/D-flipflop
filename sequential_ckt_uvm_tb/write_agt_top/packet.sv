class packet extends uvm_sequence_item;
    `uvm_object_utils(packet)
    
    rand bit din,rst;
    bit q,q_bar;
    
    constraint c1 {rst dist {0:=8, 1:=2};}
    
    string seq_name;
    static int tag;

    function new(string name = "packet");
        super.new(name);
    endfunction

    function void do_print(uvm_printer printer);
        super.do_print(printer);
        //             string_name   bit_stream  size  radix for printing
        //printer.print_field_int("data_in" , this.din,  $bits(din) ,UVM_DEC); //--------?
        printer.print_field("din",this.din,1,UVM_BIN);
        printer.print_field("q", this.q, 1 ,UVM_BIN);
        printer.print_field("q_bar", this.q_bar, 1 ,UVM_BIN);
        printer.print_field("rst"  , this.rst,1 ,UVM_BIN);
        printer.print_string("seq_name",seq_name);
        printer.print_field("tag",this.tag,32,UVM_DEC);
      //  printer.print_object()

    endfunction

endclass