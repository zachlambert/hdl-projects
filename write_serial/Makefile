
SRC = src
YS = build/yosys_script.ys
PCF = icewerx.pcf

NEXTPNR_OPTS = --hx8k --package cb132

PROJ = serial
TARGET = bin/$(PROJ)
BUILD = build/$(PROJ)

SOURCES = $(wildcard $(SRC)/*.v)

target : $(TARGET).bin

$(BUILD).blif $(BUILD).json : $(SOURCES)
	-echo synth_ice40 -blif $(BUILD).blif > $(YS)
	-echo write_json $(BUILD).json >> $(YS)
	yosys -q -s $(YS) $(SOURCES)

$(BUILD).asc : $(BUILD).blif $(BUILD).json
	nextpnr-ice40 $(NEXTPNR_OPTS) --json $(BUILD).json --pcf $(PCF) --asc $(BUILD).asc > /dev/null 2>&1

$(TARGET).bin : $(BUILD).asc
	icepack $(BUILD).asc $(TARGET).bin

clean:
	rm build/*
	rm bin/*

prog:
	iceFUNprog $(TARGET).bin
