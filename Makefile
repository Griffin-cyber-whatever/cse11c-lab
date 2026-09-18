# Each .s file in this directory is a lab. Its executable is created here too.
SOURCES := $(wildcard *.s)
LABS := $(basename $(SOURCES))
RUN_TARGETS := $(addprefix run-,$(LABS))

CC := gcc
CFLAGS := -Wall -Wextra
# The assembly labs use absolute addresses, which are incompatible with PIE.
LDFLAGS := -no-pie

.DEFAULT_GOAL := all
.PHONY: all clean list $(RUN_TARGETS)

# Compile every assembly lab.
all: $(LABS)

# Show available lab names.
list:
	@printf '%s\n' $(LABS)

# Compile one lab: make Powers
%: %.s
	$(CC) $(CFLAGS) $< $(LDFLAGS) -o $@

# Compile and run one lab: make run-Powers
$(RUN_TARGETS): run-%: %
	./$*

# Delete executables produced from all current .s labs.
clean:
	rm -f $(LABS)
