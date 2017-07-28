MONTH=$(shell date +%Y-%m)
DAY=$(shell date +%d)
LASTITLE=$(shell git log |grep -A 1 ^$$ | head -2 | tail -1)

.SILENT: default

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
	git add $$(readlink LATEST.md)
	git commit -m "$$(readlink LATEST.md) published"
	git push

test:
	git add $$(readlink LATEST.md)
	if echo "$(LASTITLE)" | grep "$$(readlink LATEST.md) published" ; then \
		EDITOR=/bin/true git commit --amend ;\
		git push --force ;\
	else \
		git commit -m "$$(readlink LATEST.md) published" ;\
	fi
		
