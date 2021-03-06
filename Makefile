MONTH=$(shell date +%Y-%m)
DAY=$(shell date +%d)
LASTITLE=$(shell git log |grep -A 1 ^$$ | head -2 | tail -1)
LATEST=$(shell readlink LATEST.md)
LASTMONTH=$(shell x=$(LATEST) ; x=$${x%/*}; echo $$x )

.SILENT: default test

default:
	printf "Usage:\n"
	printf "make new\n\t-> creates a new entry\n"
	printf "make publish\n\t-> publish your latest change\n"
	printf "vi LATEST.md\n\t-> Edit your latest entry\n"

new:
	[ -d $(MONTH) ] || mkdir $(MONTH)
	touch $(MONTH)/D$(DAY).md
	ln -fsn $(MONTH)/D$(DAY).md LATEST.md
	git add LATEST.md
	printf '/LATEST\ns/\\].*/]($(MONTH)\\/D$(DAY).md)/\nw\n' | ed README.md
	git add README.md
	grep $(MONTH)/INDEX.md README.md || ( echo "* [$(MONTH)]($(MONTH)/INDEX.md)" >>README.md ; git add README.md)
	[ -f $(MONTH)/INDEX.md ] || m4 -DMONTH=$(MONTH) skeleton.m4 >$(MONTH)/INDEX.md
	grep D$(DAY).md $(MONTH)/INDEX.md || (echo "* [$(MONTH)-$(DAY)](D$(DAY).md)" >>$(MONTH)/INDEX.md ; git add $(MONTH)/INDEX.md)

publish:
	@echo First we test if $(LATEST) has changed:
	git status $(LATEST) | grep -q modified
	git add $(LATEST)
	if echo "$(LASTITLE)" | grep "$(LATEST) published" ; then \
		EDITOR=/bin/true git commit --amend ;\
		git push --force ;\
	else \
		git commit -m "$(LATEST) published" ;\
		git push ;\
	fi

test:
	echo MONTH: $(MONTH)
	echo DAY: $(DAY)
	echo LASTITLE: $(LASTITLE)
	echo LATEST: $(LATEST)
	echo LASTMONTH: "[$(LASTMONTH)]"
