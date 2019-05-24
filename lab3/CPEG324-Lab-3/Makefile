GHDL = ghdl-0.33-x86_64-linux/bin/ghdl
COMP = -a
EXE = -e
RUN = -r

calculator:
	$(GHDL) $(COMP) RegisterFile.vhdl
	$(GHDL) $(COMP) ALU.vhdl
	$(GHDL) $(COMP) ClockFilter.vhdl
	$(GHDL) $(COMP) Calculator.vhdl
	$(GHDL) $(COMP) Testbench.vhdl
	$(GHDL) $(EXE) Testbench

run-calculator: calculator
	$(GHDL) $(RUN) Testbench

dump-calculator: calculator
	$(GHDL) $(RUN) Testbench

clean:
	rm -f *.o *.cf *.out *.vcd
