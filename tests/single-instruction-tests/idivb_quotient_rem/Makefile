TESTS=$(shell find . -maxdepth 1   -name "*.s" | sort -V)

OUTDIR=Output
KSTATES=$(patsubst %.s, ${OUTDIR}/%.kstate, $(TESTS))
XSTATES=$(patsubst %.s, ${OUTDIR}/%.xstate, $(TESTS))
CSTATES=$(patsubst %.s, ${OUTDIR}/%.cstate, $(TESTS))

Mkdir=@mkdir -p $(@D)
RUN_SH=../../../scripts/run.pl



all:	collect kompile cleankstate kstate cleanxstate xstate compare

collect: ${TESTS}
kstate: ${KSTATES}
xstate: ${XSTATES}
compare:${CSTATES}

${OUTDIR}/%.kstate: %.s
	@echo ""
	@echo  "Generate: $@ "
	@mkdir -p ${OUTDIR}
	${RUN_SH} --file $< --krun --output $@

${OUTDIR}/%.xstate: %.s
	@echo ""
	@echo  "Generate: $@ "
	@mkdir -p ${OUTDIR}
	${RUN_SH} --file $< --xrun --output $@

${OUTDIR}/%.cstate: ${OUTDIR}/%.kstate ${OUTDIR}/%.xstate
	@echo ""
	@echo  "Compare: ${OUTDIR}/$@ "
	${RUN_SH} --file $< --compare 1>$@ 2>&1

allclean:
	@echo "All Cleaning"
	rm -rf ${OUTDIR}

clean:
	@echo "Cleaning .exe & .o"
	rm -rf ${OUTDIR}/*.exec
	rm -rf ${OUTDIR}/*.o

cleankstate:
	@echo "K Cleaning"
	rm -rf ${OUTDIR}/*.kstate

cleanxstate:
	@echo "X Cleaning"
	rm -rf ${OUTDIR}/*.xstate

cleancstate:
	@echo "X Cleaning"
	rm -rf ${OUTDIR}/*.cstate

collect:
	@echo "Collect instruction semantics"
	@../../../scripts/collect_instructions_semantics.pl --file test.s

kompile:
	@echo "Kompile instruction semantics"
	@../../../scripts/kompile.pl --backend java

test:
	@echo "T Cleaning"
