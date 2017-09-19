# Source, Executable, Includes, Library Defines
SRC  = src/main.cpp src/gtstools.cpp src/cpt.cpp src/export.cpp
OBJ  = $(SRC:.cpp=.o)
LIBS = `pkg-config --libs gts` `pkg-config --libs silo`
EXE  = debug/gts-cpt

# Compiler, Linker Defines
CPP      = g++
CPPFLAGS = -Wall -ansi -pedantic -g -O3 -funroll-loops -ftree-vectorize -pg -lc
LIBPATH += -L/usr/local/lib
INCLPATH = -I./include/ 
INCLPATH+= `pkg-config --cflags gts`
INCLPATH+= `pkg-config --cflags silo`
INCLPATH+= -I/usr/lib64/glib-2.0/include 
INCLPATH+= -I/usr/lib/glib-2.0/include 
INCLPATH+= -I/usr/local/include 
RM       = /bin/rm -f

# Compile and Assemble C Source Files into Object Files
%.o: %.cpp
	$(CPP) $(INCLPATH) $(CPPFLAGS) -c $< -o $@

# Link all Object Files with external Libraries into Binaries
$(EXE): $(OBJ)
	mkdir -p `dirname $(EXE)`
	$(CPP) -o $(EXE) $(OBJ) $(LIBPATH) $(LIBS)

# Objects depend on these Libraries
$(OBJ):

# Clean Up Objects, Exectuables, Dumps out of source directory
clean:
	$(RM) $(OBJ) $(EXE) src/*.o

