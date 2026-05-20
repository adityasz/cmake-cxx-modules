BUILD_BASE_DIR    := build

BUILD_TYPE        ?= release
BUILD_DIR         := $(BUILD_BASE_DIR)/$(BUILD_TYPE)
OBJ_DIR           := $(BUILD_DIR)/obj
BIN_DIR           := $(BUILD_DIR)/bin
GCM_DIR           := $(BUILD_DIR)/gcm.cache
DIR_STAMP         := $(BUILD_DIR)/.dirs
MODULE_MAPPER     := $(BUILD_DIR)/module.mapper

APP               := $(BIN_DIR)/example

CXX               ?= g++
CXX_STANDARD      ?= 26
STD_MODULE_SRC    ?= /usr/include/c++/15/bits/std.cc

CXXFLAGS          ?= -Wall -Wpedantic -Wextra -march=native
CXXFLAGS          += -std=c++$(CXX_STANDARD) -fmodules
MODULE_FLAGS      := -fmodule-mapper=$(MODULE_MAPPER)
CXXFLAGS_RELEASE  ?= -O3 -flto=auto
CXXFLAGS_DEBUG    ?= -g3
CXXFLAGS_RDBG     ?= -O3 -g3 -flto=auto

ifeq ($(BUILD_TYPE),debug)
  CXXFLAGS += $(CXXFLAGS_DEBUG)
else ifeq ($(BUILD_TYPE),rdbg)
  CXXFLAGS += $(CXXFLAGS_RDBG)
else
  CXXFLAGS += $(CXXFLAGS_RELEASE)
endif

LDFLAGS           ?= -fuse-ld=mold
LDLIBS            ?=

STD_BMI           := $(GCM_DIR)/std.gcm

EXAMPLE_A_ONE_BMI := $(GCM_DIR)/example.a.one.gcm
EXAMPLE_A_TWO_BMI := $(GCM_DIR)/example.a.two.gcm
EXAMPLE_A_BMI     := $(GCM_DIR)/example.a.gcm

EXAMPLE_B_ONE_BMI := $(GCM_DIR)/example.b.one.gcm
EXAMPLE_B_TWO_BMI := $(GCM_DIR)/example.b.two.gcm
EXAMPLE_B_BMI     := $(GCM_DIR)/example.b.gcm

EXAMPLE_C_ONE_BMI := $(GCM_DIR)/example.c.one.gcm
EXAMPLE_C_TWO_BMI := $(GCM_DIR)/example.c.two.gcm
EXAMPLE_C_BMI     := $(GCM_DIR)/example.c.gcm

EXAMPLE_D_ONE_BMI := $(GCM_DIR)/example.d.one.gcm
EXAMPLE_D_TWO_BMI := $(GCM_DIR)/example.d.two.gcm
EXAMPLE_D_BMI     := $(GCM_DIR)/example.d.gcm

EXAMPLE_BMI       := $(GCM_DIR)/example.gcm

MODULE_IFACE_OBJS := \
  $(OBJ_DIR)/modules/example.o \
  $(OBJ_DIR)/modules/example/A/a.o \
  $(OBJ_DIR)/modules/example/A/one.o \
  $(OBJ_DIR)/modules/example/A/two.o \
  $(OBJ_DIR)/modules/example/B/b.o \
  $(OBJ_DIR)/modules/example/B/one.o \
  $(OBJ_DIR)/modules/example/B/two.o \
  $(OBJ_DIR)/modules/example/C/c.o \
  $(OBJ_DIR)/modules/example/C/one.o \
  $(OBJ_DIR)/modules/example/C/two.o \
  $(OBJ_DIR)/modules/example/D/d.o \
  $(OBJ_DIR)/modules/example/D/one.o \
  $(OBJ_DIR)/modules/example/D/two.o

LIB_OBJS          := \
  $(OBJ_DIR)/lib/A/one.o \
  $(OBJ_DIR)/lib/A/two.o \
  $(OBJ_DIR)/lib/B/one.o \
  $(OBJ_DIR)/lib/B/two.o \
  $(OBJ_DIR)/lib/C/one.o \
  $(OBJ_DIR)/lib/C/two.o \
  $(OBJ_DIR)/lib/D/one.o \
  $(OBJ_DIR)/lib/D/two.o

CLI_OBJ           := $(OBJ_DIR)/cli/main.o
OBJS              := $(MODULE_IFACE_OBJS) $(LIB_OBJS) $(CLI_OBJ)
BUILD_DIRS        := $(BIN_DIR) $(GCM_DIR) $(sort $(dir $(OBJS)))

.DEFAULT_GOAL := all

.PHONY: all clean run
all: $(APP)

run: $(APP)
	$(APP)

clean:
	$(RM) -r $(BUILD_DIR)

$(APP): $(OBJS) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(STD_BMI): $(STD_MODULE_SRC) $(MODULE_MAPPER) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -fmodule-only -c $<

$(OBJ_DIR)/modules/example/A/one.o $(EXAMPLE_A_ONE_BMI) &: modules/example/A/one.ixx $(MODULE_MAPPER) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -x c++ -c $< -o $(OBJ_DIR)/modules/example/A/one.o

$(OBJ_DIR)/modules/example/A/two.o $(EXAMPLE_A_TWO_BMI) &: modules/example/A/two.ixx $(MODULE_MAPPER) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -x c++ -c $< -o $(OBJ_DIR)/modules/example/A/two.o

$(OBJ_DIR)/modules/example/B/one.o $(EXAMPLE_B_ONE_BMI) &: modules/example/B/one.ixx $(MODULE_MAPPER) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -x c++ -c $< -o $(OBJ_DIR)/modules/example/B/one.o

$(OBJ_DIR)/modules/example/B/two.o $(EXAMPLE_B_TWO_BMI) &: modules/example/B/two.ixx $(MODULE_MAPPER) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -x c++ -c $< -o $(OBJ_DIR)/modules/example/B/two.o

$(OBJ_DIR)/modules/example/C/one.o $(EXAMPLE_C_ONE_BMI) &: modules/example/C/one.ixx $(MODULE_MAPPER) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -x c++ -c $< -o $(OBJ_DIR)/modules/example/C/one.o

$(OBJ_DIR)/modules/example/C/two.o $(EXAMPLE_C_TWO_BMI) &: modules/example/C/two.ixx $(MODULE_MAPPER) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -x c++ -c $< -o $(OBJ_DIR)/modules/example/C/two.o

$(OBJ_DIR)/modules/example/D/one.o $(EXAMPLE_D_ONE_BMI) &: modules/example/D/one.ixx $(MODULE_MAPPER) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -x c++ -c $< -o $(OBJ_DIR)/modules/example/D/one.o

$(OBJ_DIR)/modules/example/D/two.o $(EXAMPLE_D_TWO_BMI) &: modules/example/D/two.ixx $(MODULE_MAPPER) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -x c++ -c $< -o $(OBJ_DIR)/modules/example/D/two.o

$(OBJ_DIR)/modules/example/A/a.o $(EXAMPLE_A_BMI) &: modules/example/A/a.ixx $(MODULE_MAPPER) $(EXAMPLE_A_ONE_BMI) $(EXAMPLE_A_TWO_BMI) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -x c++ -c $< -o $(OBJ_DIR)/modules/example/A/a.o

$(OBJ_DIR)/modules/example/B/b.o $(EXAMPLE_B_BMI) &: modules/example/B/b.ixx $(MODULE_MAPPER) $(EXAMPLE_B_ONE_BMI) $(EXAMPLE_B_TWO_BMI) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -x c++ -c $< -o $(OBJ_DIR)/modules/example/B/b.o

$(OBJ_DIR)/modules/example/C/c.o $(EXAMPLE_C_BMI) &: modules/example/C/c.ixx $(MODULE_MAPPER) $(EXAMPLE_C_ONE_BMI) $(EXAMPLE_C_TWO_BMI) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -x c++ -c $< -o $(OBJ_DIR)/modules/example/C/c.o

$(OBJ_DIR)/modules/example/D/d.o $(EXAMPLE_D_BMI) &: modules/example/D/d.ixx $(MODULE_MAPPER) $(EXAMPLE_D_ONE_BMI) $(EXAMPLE_D_TWO_BMI) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -x c++ -c $< -o $(OBJ_DIR)/modules/example/D/d.o

$(OBJ_DIR)/modules/example.o $(EXAMPLE_BMI) &: modules/example.ixx $(MODULE_MAPPER) $(EXAMPLE_A_BMI) $(EXAMPLE_B_BMI) $(EXAMPLE_C_BMI) $(EXAMPLE_D_BMI) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -x c++ -c $< -o $(OBJ_DIR)/modules/example.o

$(OBJ_DIR)/lib/A/one.o: lib/A/one.cpp $(MODULE_MAPPER) $(EXAMPLE_A_ONE_BMI) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -c $< -o $@

$(OBJ_DIR)/lib/A/two.o: lib/A/two.cpp $(MODULE_MAPPER) $(EXAMPLE_A_TWO_BMI) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -c $< -o $@

$(OBJ_DIR)/lib/B/one.o: lib/B/one.cpp $(MODULE_MAPPER) $(EXAMPLE_B_ONE_BMI) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -c $< -o $@

$(OBJ_DIR)/lib/B/two.o: lib/B/two.cpp $(MODULE_MAPPER) $(EXAMPLE_B_TWO_BMI) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -c $< -o $@

$(OBJ_DIR)/lib/C/one.o: lib/C/one.cpp $(MODULE_MAPPER) $(EXAMPLE_C_ONE_BMI) $(EXAMPLE_B_BMI) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -c $< -o $@

$(OBJ_DIR)/lib/C/two.o: lib/C/two.cpp $(MODULE_MAPPER) $(EXAMPLE_C_TWO_BMI) $(EXAMPLE_B_BMI) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -c $< -o $@

$(OBJ_DIR)/lib/D/one.o: lib/D/one.cpp $(MODULE_MAPPER) $(EXAMPLE_D_ONE_BMI) $(EXAMPLE_A_BMI) $(EXAMPLE_B_BMI) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -c $< -o $@

$(OBJ_DIR)/lib/D/two.o: lib/D/two.cpp $(MODULE_MAPPER) $(EXAMPLE_D_TWO_BMI) $(EXAMPLE_A_BMI) $(EXAMPLE_B_BMI) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -c $< -o $@

$(OBJ_DIR)/cli/main.o: cli/main.cpp $(MODULE_MAPPER) $(STD_BMI) $(EXAMPLE_BMI) | $(DIR_STAMP)
	$(CXX) $(CXXFLAGS) $(MODULE_FLAGS) -c $< -o $@

$(MODULE_MAPPER): Makefile | $(DIR_STAMP)
	printf '%s\n' \
	  '$$root $(GCM_DIR)' \
	  'std std.gcm' \
	  'example example.gcm' \
	  'example.a example.a.gcm' \
	  'example.a.one example.a.one.gcm' \
	  'example.a.two example.a.two.gcm' \
	  'example.b example.b.gcm' \
	  'example.b.one example.b.one.gcm' \
	  'example.b.two example.b.two.gcm' \
	  'example.c example.c.gcm' \
	  'example.c.one example.c.one.gcm' \
	  'example.c.two example.c.two.gcm' \
	  'example.d example.d.gcm' \
	  'example.d.one example.d.one.gcm' \
	  'example.d.two example.d.two.gcm' \
	  > $@

$(DIR_STAMP):
	mkdir -p $(BUILD_DIRS)
	touch $@
