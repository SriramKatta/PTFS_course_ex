# Compiler
CC = icx

# Compiler flags
CFLAGS = -O3 -xHost -qopenmp

# Source files
SRC_DIR = ./src
RAYTRACER_SRC = $(SRC_DIR)/raytrace.c $(SRC_DIR)/timing.c
RAYTRACE_TASK_SRC = $(SRC_DIR)/raytrace_task.c $(SRC_DIR)/timing.c

# Header files
HEADERS = timing.h

# Output executables
RAYTRACER_TARGET = ./exe/raytrace
RAYTRACE_TASK_TARGET = ./exe/raytrace_task

# Default target
all: $(RAYTRACER_TARGET) $(RAYTRACE_TASK_TARGET)

# Build raytracer executable
$(RAYTRACER_TARGET): $(RAYTRACER_SRC)
	$(CC) $(CFLAGS) $(RAYTRACER_SRC) -o $(RAYTRACER_TARGET)

# Build raytrace_task executable
$(RAYTRACE_TASK_TARGET): $(RAYTRACE_TASK_SRC)
	$(CC) $(CFLAGS) $(RAYTRACE_TASK_SRC) -o $(RAYTRACE_TASK_TARGET)

# Clean up build files
clean:
	rm -f $(RAYTRACER_TARGET) $(RAYTRACE_TASK_TARGET)

# Phony targets
.PHONY: all clean