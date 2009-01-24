all: baseline_qa.xml observed_qa.xml

baseline_qa.xml: baseline_qa.csv server_qa.xml server2_qa.xml
	../bin/list2xml.sh baseline_qa.csv > baseline_qa.xml
observed_qa.xml: observed_qa.csv server_qa.xml server2_qa.xml
	../bin/list2xml.sh observed_qa.csv > observed_qa.xml
