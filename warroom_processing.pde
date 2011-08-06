 // War Room @ eyebeam for #arthack Aug 2011

XMLElement[] house_votes;
XMLElement[] senate_votes;
String HOUSE_TEST_DATA_PATH = "xml/house_2011-02.xml";
String SENATE_TEST_DATA_PATH = "xml/senate_2011-02.xml";

int d_score;
int r_score;


void setup() {
	size(1024, 768);
	XMLElement house = new XMLElement(this, HOUSE_TEST_DATA_PATH);
	XMLElement senate = new XMLElement(this, SENATE_TEST_DATA_PATH);
	house_votes = grabVotes(house);	
	senate_votes = grabVotes(senate);
	
	// print house votes
	for(int i=0; i < house_votes.length; i++) {
		String result = house_votes[i].getChild("result").getContent();
		// Make sure the vote didn't fail ( alternatives are "Passed" for bill and "Agreed to" for amendments)
		if(!result.equals("Failed")) {
			println(house_votes[i].getChild("description").getContent());			
		}
	}
	
}

// grab votes from the root xmnl node
XMLElement[] grabVotes(XMLElement xml) {
	String path = "results/votes/vote";
	return xml.getChildren(path);
}