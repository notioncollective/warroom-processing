 // War Room @ eyebeam for #arthack Aug 2011
/*import processing.serial.*;*/

/*Serial port;*/
// for sending messages
/*public static final char HEADER = '|';
public static final char WIN = 'W';
public static final char DEM = 'D';
public static final char REP = 'R';*/

WRVoteData vote_data;
String HOUSE_TEST_DATA_PATH = "xml/house_2011-02.xml";
String SENATE_TEST_DATA_PATH = "xml/senate_2011-02.xml";
String API_KEY;

void setup() {	
	size(1024, 768);

  /*port = new Serial(this, Serial.list()[0], 9600); */
        
	XMLElement house = new XMLElement(this, HOUSE_TEST_DATA_PATH);
	XMLElement senate = new XMLElement(this, SENATE_TEST_DATA_PATH);
	
	// load api key
	String[] api_strings = loadStrings("api_key.txt");
	if(api_strings != null) {
		API_KEY = api_strings[0];
		println("API key: "+API_KEY);
	} else {
		println("You should add a file called 'api_key.txt' to your project dir and drop your API key in there.");
		exit();
		return;
	}
	
	vote_data = new WRVoteData(house, senate, API_KEY);
	
  // serial output should either be DEM or REP?
  /*char serialOutput = DEM;
	println(serialOutput);
	sendMessage(WIN, serialOutput);*/
	
	ArrayList votes = vote_data.votes;
	
	// print house votes
	for(int i=0; i < votes.size(); i++) {
		WRVote vote = (WRVote)votes.get(i);
		String result = vote.result;
		// Make sure the vote didn't fail ( alternatives are "Passed" for bill and "Agreed to" for amendments)
		
	        println(vote.date);
		
	}
	
}

void draw() {}


/*void sendMessage(char tag, int value){
  port.write(HEADER);
  port.write(tag);
  port.write(value);
}*/