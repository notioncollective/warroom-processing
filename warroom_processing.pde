 // War Room @ eyebeam for #arthack Aug 2011

XMLElement[] votes;
String HOUSE_TEST_DATA_PATH = "xml/house_2011-02.xml";
String SENATE_TEST_DATA_PATH = "xml/senate_2011-02.xml";

int d_score;
int r_score;


void setup() {
	size(1024, 768);
	XMLElement house = new XMLElement(this, HOUSE_TEST_DATA_PATH);
	XMLElement senate = new XMLElement(this, SENATE_TEST_DATA_PATH);
	XMLElement[] house_votes = grabVotes(house);	
	XMLElement[] senate_votes = grabVotes(senate);
	// merge house and senate votes, then merge by date/time
	/*votes = sortByDate(mergeArrays(house_votes, senate_votes));*/
	votes = mergeArrays(house_votes, senate_votes);
	println(votes.length);
	
	// print house votes
	for(int i=0; i < votes.length; i++) {
		String result = votes[i].getChild("result").getContent();
		// Make sure the vote didn't fail ( alternatives are "Passed" for bill and "Agreed to" for amendments)
		if(!result.equals("Failed")) {
			println(votes[i].getChild("description").getContent());			
		}
	}
	
}

// grab votes from the root xmnl node
XMLElement[] grabVotes(XMLElement xml) {
	String path = "results/votes/vote";
	return xml.getChildren(path);
}

// sort merged votes
XMLElement[] sortByDate(XMLElement[] v) {
	XMLElement[] sorted = new XMLElement[v.length];
	for(int i=1; i < v.length; i++) {
		// traverse all votes, add to sorted array in correct order
		
	}
	return sorted;
}

// merge the two arrays
XMLElement[] mergeArrays(XMLElement[] a1, XMLElement[] a2) {
	int new_length = a1.length + a2.length;
	XMLElement[] new_array = new XMLElement[new_length];
	
	int a1_i;
	int a2_i;
	
	// add first collection
	for(a1_i=0; a1_i < a1.length; a1_i++) {
		new_array[a1_i] = a1[a1_i];
	}
	
	// add second collection
	for(a2_i=0; a2_i < a2.length; a2_i++) {
		new_array[a1_i+a2_i] = a2[a2_i];
	}
	
	return new_array;
}