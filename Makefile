MONTH=$(shell date +%Y-%m)

default:

new:
	[ -d $(MONTH) ] || mkdir $(MONTH)
