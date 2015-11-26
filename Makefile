# Source, Executable, Includes, Library Defines
SRC  = src/main.cpp src/gtstools.cpp src/cpt.cpp src/export.cpp
OBJ  = $(SRC:.cpp=.o)
LIBS = -lgts -lglib-2.0 -lsilo -lm -ldl `pkg-config --libs gts`
EXE  = debug/gts-cpt

# Compiler, Linker Defines
CPP      = /usr/bin/g++
CPPFLAGS = -Wall -ansi -pedantic -g -O3 -funroll-loops -ftree-vectorize -pg -lc

LIBPATH += -L/usr/local/lib

INCLPATH = -I./include/ 
INCLPATH+= `pkg-config --cflags gts`
INCLPATH+= -I/usr/lib64/glib-2.0/include 
INCLPATH+= -I/usr/lib/glib-2.0/include 
INCLPATH+= -I/usr/local/include 
INCLPATH+= -I../silo/include
INCLPATH+= -I../visit2.2.2/src/sim/V1/lib/

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

