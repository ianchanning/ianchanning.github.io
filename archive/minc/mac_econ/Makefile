.SUFFIXES: .java .class

# Tools 
JAVAC=javac
JAVADOC=javadoc
RM=rm

#Set properties of window
WINDOWTITLE='AMS ESDC - INAdvance(TM)'
BOTTOM='Copyright (c) AMS Management Systems Portugal'
HEADER='CCM server'
FOOTER='CCM server'

#Compilers options 
JAVAC_FLAGS=

APPLET_SOURCES=applet/*.java
GRAPH_SOURCES=graph/*.java
MODEL_SOURCES=model/*.java
FUNCTION_SOURCES=function/*.java
VALIDATION_SOURCES=validation/*.java

CURRENT_SOURCES=$(APPLET_SOURCES)

SOURCES=applet/*.java \
	graph/*.java \
	model/*.java \
	function/*.java \
	validation/*.java

PACKAGES=mac_econ.applet \
        mac_econ.function \
        mac_econ.validation \
        mac_econ.model \
        mac_econ.model.model1 \
        mac_econ.model.model2 \
        mac_econ.model.model3 \
        mac_econ.model.model4 \
        mac_econ.model.model6 \


current: 

	@echo Generating Current mac_econ classes...
	$(JAVAC) $(CURRENT_SOURCES) 
	@echo "Done..."


all:	
	@echo Generating mac_econ classes...
	$(JAVAC) $(SOURCES)
	@echo "Done..."


doc:
	@echo Generating CCM documentation...
	-mkdir -p $(JAVADOC_DIR)
	$(JAVADOC) $(JAVADOC_FLAGS) $(PACKAGES)

clean:
	@echo Removing all .class and .html files...
	@$(RM) -rf $(INA_JAVA_BIN)/com/amsinc/inadvance/ccm/*.class
	@$(RM) -rf $(INA_JAVA_BIN)/com/amsinc/inadvance/domain/*.class
	@$(RM) -rf $(INA_JAVA_BIN)/com/amsinc/inadvance/utils/*.class
