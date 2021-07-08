EXECUTABLE=out

SOURCE=main.s
INCLUDES=DemoStartup.S debug.s
HD=~/Dropbox/archive/amiga/hard-drives/build
UAE=~/Dropbox/archive/amiga/Configurations/A1200build.fs-uae

GENERATED=gen/hello.raw gen/hello-copper.s


DEPENDENCIES=$(SOURCE) $(INCLUDES) $(GENERATED) Makefile

VASM_OPTIONS=-phxass -showcrit -showopt -Fhunkexe -nosym -L $(EXECUTABLE).lst -Lnf

$(EXECUTABLE) : $(DEPENDENCIES)
	vasmm68k_mot $(VASM_OPTIONS) -DDEBUG -o $@ $(SOURCE)
	cp $(EXECUTABLE) $(HD)/build.exe
	chmod 755 $(HD)/build.exe

$(EXECUTABLE)-nodebug : $(DEPENDENCIES)
	vasmm68k_mot  -o $@ $(SOURCE)

gen/hello.raw gen/hello-copper.s: assets/hello.png bitplanify.py
	python2 bitplanify.py $< --copper=gen/hello-copper.s gen/hello.raw


run:	$(EXECUTABLE)
	fs-uae $(UAE)
	
warp:	$(EXECUTABLE)
	fs-uae $(UAE) --warp-mode --fullscreen
	
clean:
	rm -rf gen/*
	rm -f $(EXECUTABLE)

.PHONY: clean
