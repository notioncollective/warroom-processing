 // War Room @ eyebeam for #arthack Aug 2011

XMLElement[] house_votes;
XMLElement[] senate_votes;
String HOUSE_TEST_DATA_PATH = "xml/house_2011-02.xml";
String SENATE_TEST_DATA_PATH = "xml/senate_2011-02.xml";


void setup() {
	size(1024, 768);
	XMLElement house = new XMLElement(this, HOUSE_TEST_DATA_PATH);
	XMLElement senate = new XMLElement(this, SENATE_TEST_DATA_PATH);
	house_votes = grabVotes(house);
	println(house_votes.length);
	
	senate_votes = grabVotes(senate);
	
	// print house votes
	for(int i=0; i < house_votes.length; i++) {
		String description = house_votes[i].getChild("description").getContent();
		println(description);
	}
	
}

XMLElement[] grabVotes(XMLElement xml) {
	String path = "results/votes/vote";
	return xml.getChildren(path);
}