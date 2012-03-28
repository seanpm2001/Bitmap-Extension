ifeq ($(origin JAVA_HOME), undefined)
  JAVA_HOME=/usr
endif

ifeq ($(origin NETLOGO), undefined)
  NETLOGO=../..
endif

ifneq (,$(findstring CYGWIN,$(shell uname -s)))
  COLON=\;
  JAVA_HOME := `cygpath -up "$(JAVA_HOME)"`
else
  COLON=:
endif

JAVAC=$(JAVA_HOME)/bin/javac
SRCS=$(wildcard src/*.java)

bitmap.jar bitmap.jar.pack.gz: $(SRCS) manifest.txt Makefile
	mkdir -p classes
	$(JAVAC) -g -deprecation -Xlint:all -Xlint:-serial -Xlint:-path -encoding us-ascii -source 1.5 -target 1.5 -classpath $(NETLOGO)/NetLogoLite.jar -d classes $(SRCS)
	jar cmf manifest.txt bitmap.jar -C classes .
	pack200 --modification-time=latest --effort=9 --strip-debug --no-keep-file-order --unknown-attribute=strip bitmap.jar.pack.gz bitmap.jar

bitmap.zip: bitmap.jar
	rm -rf bitmap
	mkdir bitmap
	cp -rp bitmap.jar bitmap.jar.pack.gz README.md Makefile src manifest.txt bitmap
	zip -rv bitmap.zip bitmap
	rm -rf bitmap
