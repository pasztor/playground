# playground
playground repo, to test how things work

My idea is to write my blog into a repo here, and add links, like:
* [LATEST](LATEST.md)
* [x.month list](month.md)

and with a good makefile, I can cover the following usecases:
* add a new entry
* publish a new entry

When I add a new entry, the following should be considered:
* update the LATEST.md symlink to the new file
* enlist the real file, in the monthly list
* need some "helper function" to find out about a .md file, in which month was it published. eg. git log or git blame, or sg. could be processed in order to achieve this.

And finally: The list of months, when I published a blog entry
* 2017-07/INDEX.md
