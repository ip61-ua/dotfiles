CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++20 -Iinclude -Isrc
TEST_LDFLAGS = -lgtest -lgtest_main -pthread

TARGET = build/__PROJECT-NAME__
TEST_TARGET = build/test_runner

SRCS = $(shell find src -name '*.cpp')
TEST_SRCS = $(shell find tests -name '*.cpp')
SRCS_NO_MAIN = $(filter-out src/main.cpp, $(SRCS))

all: run

build: $(SRCS)
	@mkdir -p build
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(SRCS)

run: build
	./$(TARGET)

test: $(TEST_SRCS) $(SRCS_NO_MAIN)
	@mkdir -p build
	$(CXX) $(CXXFLAGS) -o $(TEST_TARGET) $(TEST_SRCS) $(SRCS_NO_MAIN) $(TEST_LDFLAGS)
	./$(TEST_TARGET)

clean:
	rm -rf build/*
