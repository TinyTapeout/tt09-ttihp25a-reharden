TOP = top
MAIN_CPP = logo.cpp
EXEC_NAME = logo

DFLAGS = -DSIM
VFLAGS = -O3 --x-assign fast --x-initial fast --noassert
WFLAGS = -Wno-CASEINCOMPLETE -Wno-CASEX -Wno-CASEOVERLAP -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-PINMISSING
SDL_CFLAGS = `sdl2-config --cflags`
SDL_LDFLAGS = `sdl2-config --libs`

SRC_DIR = $(PWD)/../src
PROJECT_SOURCES += project.v hvsync_generator.v

a2600: V${TOP}.mk
	make -C ./obj_dir -f V${TOP}.mk
	cp ./obj_dir/${EXEC_NAME} .

V${TOP}.mk: ${MAIN_CPP}
	verilator ${VFLAGS} ${WFLAGS} -I${SRC_DIR} \
		-top $(TOP) -cc  ${TOP}.v ${PROJECT_SOURCES}  --exe $< -o ${EXEC_NAME} \
		${DFLAGS} -CFLAGS "${SDL_CFLAGS}" -LDFLAGS "${SDL_LDFLAGS}"

all:

clean:
	rm -rf ./obj_dir
	rm -f  ./${EXEC_NAME}

.PHONY: all clean

