JAVA ?= java
JAVAC ?= javac

#ARGS='--help'
BUILD_DIR := build

src := $(wildcard src/main/java/gnu/getopt/*.java)
objects := $(patsubst src/main/java/%.java,$(BUILD_DIR)/%.class,$(src))

demo_src := $(wildcard src/main/java/*.java)
demo := $(patsubst src/main/java/%.java,$(BUILD_DIR)/%.class,$(demo_src))

res_src := $(wildcard src/main/resources/*.properties)
res := $(patsubst src/main/resources/%,$(BUILD_DIR)/gnu/getopt/%,$(res_src))


demo:

.PHONY: jar
jar: java-getopt.jar

java-getopt.jar: all
	@[ ! -e $(demo) ] || rm $(demo)
	jar cf $@ -C $(BUILD_DIR) .

.PHONY: all
all: $(objects) $(res)


$(objects): $(BUILD_DIR)/%.class: src/main/java/%.java
	@[ -d build/resources/gnu/getopt ] || mkdir -p build/resources/gnu/getopt
	$(JAVAC) -d build $(src)


$(res): $(BUILD_DIR)/gnu/getopt/%: src/main/resources/%
	cp $< $@


.PHONY: demo
demo: $(demo)
	@[ -n "$(ARGS)" ] || echo -e "****************\ntype make demo ARGS='--your --args --here' to test arguments\n****************"
	java -cp build:build/resources:. GetoptDemo $(ARGS)


$(demo): $(BUILD_DIR)/%.class: src/main/java/%.java
	$(JAVAC) -d build/ -cp build $<

.PHONY: docs
docs: $(src)
	@[ -d docs ] || mkdir docs
	javadoc -d docs -package -use -version -author $^
