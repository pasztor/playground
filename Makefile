MONTH=$(shell date +%Y-%m)
DAY=$(shell date +%d)

default:

new:
	[ -d $(MONTH) ] || mkdir $(MONTH)
	touch $(MONTH)/D$(DAY).md
	ln -fsn $(MONTH)/D$(DAY).md LATEST.md
	git add LATEST.md
	grep $(MONTH) README.md || ( echo "* $(MONTH)/INDEX.md" >>README.md ; git add README.md)
	[ -f $(MONTH)/INDEX.md ] || cp skeleton.md $(MONTH)/INDEX.md
	grep D$(DAY).md $(MONTH)/INDEX.md || (echo "* D$(DAY).md" >>$(MONTH)/INDEX.md ; git add $(MONTH)/INDEX.md)

publish:
	git add $$(readlink LATEST.md)
	git commit -m "$$(readlink LATEST.md) published"
	git push
