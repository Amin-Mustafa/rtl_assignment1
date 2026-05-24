# ----------------------------
# Project Name & Top Module
# ----------------------------
PROJECT_NAME := $(notdir $(subst \,/,$(CURDIR)))
# MUST MATCH your top-level Verilog module name!
TOP		:= M1

# ----------------------------
# Tang Nano 1K Hardware Config
# ----------------------------
BOARD	:= tangnano1k
FAMILY	:= GW1NZ-1
DEVICE	:= GW1NZ-LV1QN48C6/I5
CST		:= pins.cst

# ----------------------------
# Toolchains
# ----------------------------
# Simulation tools
CC		= iverilog
SIM		= vvp
VIEWER	= gtkwave
# Hardware tools
SYNTH	= yosys
PNR		= nextpnr-gowin
PACK	= gowin_pack
FLASHER	= openFPGALoader

# ----------------------------
# Directories & Flags
# ----------------------------
SRC_DIR		= .
BUILD_DIR	= build
CFLAGS		= -g2012 -Wall

# ----------------------------
# Sources (The Smart Filter)
# ----------------------------
# Find all .v and .sv files
ALL_SRCS := $(shell find $(SRC_DIR) -name '*.v' -o -name '*.sv')
# Hardware sources (Filters OUT anything starting with tb_)
HW_SRCS	 := $(filter-out $tb_%/(SRC_DIR), $(ALL_SRCS))

# ----------------------------
# Output Files
# ----------------------------
# Sim files
OUT_FILE	= $(BUILD_DIR)/$(PROJECT_NAME).out
VCD_FILE	= $(BUILD_DIR)/waves.vcd
# Hardware files
JSON_FILE	= $(BUILD_DIR)/$(PROJECT_NAME).json
PACK_FILE	= $(BUILD_DIR)/$(PROJECT_NAME).pack
FS_FILE		= $(BUILD_DIR)/$(PROJECT_NAME).fs

# ----------------------------
# Build Targets
# ----------------------------
.PHONY: all sim view clean help tags synth pnr bitstream flash

# Default target: compile simulation
all: $(OUT_FILE)

# --- SIMULATION TARGETS ---
$(OUT_FILE): $(ALL_SRCS) | $(BUILD_DIR)
	@echo "[COMPILE SIM] $(ALL_SRCS)"
	@$(CC) $(CFLAGS) -o $(OUT_FILE) $(ALL_SRCS)

sim: $(OUT_FILE)
	@echo "[SIMULATE] Running $(PROJECT_NAME)..."
	@$(SIM) $(OUT_FILE)

view: $(VCD_FILE)
	@echo "[VIEWER] Opening Waveforms..."
	@$(VIEWER) $(VCD_FILE) &

$(VCD_FILE): sim

# --- HARDWARE TARGETS ---
synth: $(JSON_FILE)
$(JSON_FILE): $(HW_SRCS) | $(BUILD_DIR)
	@echo "[SYNTHESIS] Compiling Hardware..."
	@$(SYNTH) -p "read_verilog $(HW_SRCS); synth_gowin -top $(TOP) -json $(JSON_FILE)"

pnr: $(PACK_FILE)
$(PACK_FILE): $(JSON_FILE) $(CST)
	@echo "[PLACE & ROUTE] Mapping to silicon..."
	@$(PNR) --json $(JSON_FILE) --write $(PACK_FILE) --family $(FAMILY) --device $(DEVICE) --cst $(CST)

bitstream: $(FS_FILE)
$(FS_FILE): $(PACK_FILE)
	@echo "[PACKING] Generating bitstream..."
	@$(PACK) -d $(FAMILY) -o $(FS_FILE) $(PACK_FILE)

flash: bitstream
	@echo "[FLASHING] Uploading to Tang Nano 1K..."
	@$(FLASHER) -b $(BOARD) $(FS_FILE)

# --- UTILITY TARGETS ---
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

clean:
	@echo "[CLEAN] Removing build artifacts..."
	@rm -rf $(BUILD_DIR)

tags:
	@echo "[CTAGS] Rebuilding navigation indexes..."
	@ctags -R --languages=Verilog --kinds-Verilog=+m --fields=+nKz .

help:
	@echo "----------------------------------------------------------------"
	@echo "Project: $(PROJECT_NAME) | Top Module: $(TOP)"
	@echo "----------------------------------------------------------------"
	@echo "--- Simulation ---"
	@echo "make sim      -> Compile and Run Simulation"
	@echo "make view     -> Run Simulation and Open GTKWave"
	@echo "--- Hardware ---"
	@echo "make bitstream-> Compile to FPGA bitstream (.fs)"
	@echo "make flash    -> Flash bitstream to Tang Nano 1K"
	@echo "--- Utilities ---"
	@echo "make clean    -> Remove build directory"
	@echo "make tags     -> Rebuild Go-To-Definition indexes"
	@echo "----------------------------------------------------------------"