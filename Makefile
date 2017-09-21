BIN  = $(HOME)/bin
SRC  = src/main.cpp src/gtstools.cpp src/cpt.cpp src/export.cpp
OBJ  = $(SRC:.cpp=.o)
LIBS = `pkg-config --libs gts` `pkg-config --libs silo`
EXE  = debug/gts-cpt

# wrapper
WRP  = scripts/cpt

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

%.o: %.cpp
	$(CPP) $(INCLPATH) $(CPPFLAGS) -c $< -o $@

$(EXE): $(OBJ)
	mkdir -p `dirname $(EXE)`
	$(CPP) -o $(EXE) $(OBJ) $(LIBPATH) $(LIBS)

clean:
	$(RM) $(OBJ) $(EXE) src/*.o

install: $(EXE)
	cp $(EXE) $(WRP) $(BIN)/

.PHONY: clean install
