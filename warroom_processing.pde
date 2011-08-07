 // War Room @ eyebeam for #arthack Aug 2011
import processing.serial.*;

String game_title = "CAPITOL CONQUEST";

WRVoteData vote_data;
String HOUSE_TEST_DATA_PATH = "xml/house_2011-02.xml";
String SENATE_TEST_DATA_PATH = "xml/senate_2011-02.xml";
String API_KEY;

String game_date = "February 2011";

Serial port;
// for sending messages
public static final char HEADER = '|';
public static final char WIN = 'W';
public static final char DEM = 'D';
public static final char REP = 'R';

PFont title_font;
PFont score_font;
PFont bill_font;


WRVote current_vote;
int vote_count;
int dems_score;
int gop_score;

PImage map;
PImage flag_map;
PImage red_map;
PImage blue_map;
PImage title_image;

color white = color(255, 255, 255);
color blue = color(16, 11, 236);
color red = color(247, 1, 36);
color black = color(0, 0, 0);
color grey = color(200);

int screenXMid = screen.width/2;
int screenYMid = screen.height/2;

void setup() {	
	
	// display stuff
	//size(1024, 768);
        size(screen.width, screen.height);
	frameRate(30);
  
	title_font = loadFont("FFFGalaxyExtraBoldExtended-55.vlw");
	score_font = loadFont("VT323-90.vlw");
	bill_font = loadFont("VT323-40.vlw");
	
	vote_count = 0;
	dems_score = 0;
	gop_score = 0;
	
	map = loadImage("map.png");
	flag_map = loadImage("flag_map.png");
	red_map = loadImage("red_map.png");
	blue_map = loadImage("blue_map.png");
	title_image = loadImage("title.png");
	
	clearScreen();
	drawScore();

	String[] port_strings = loadStrings("port.txt");
	if(port_strings != null) {
		println("Port: "+port_strings[0]);
		port = new Serial(this, port_strings[0], 9600); 
	} else {
		port = new Serial(this, Serial.list()[0], 9600); 
	}
        
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
}


void draw() {
	if(vote_count < vote_data.votes.size()) {
		WRVote current_vote = (WRVote)vote_data.votes.get(vote_count);
		switch(current_vote.winner) {
			case WRVoteData.REPUBLICAN:
				gop_score++;
				break;
			case WRVoteData.DEMOCRAT:
				dems_score++;
				break;
			default:
				break;
		}
		clearScreen();
		drawScore();
		drawBill();
		shoot(current_vote.winner);
		vote_count++;
		delay(1000);
	} else {
		textFont(score_font);
		println("GAME OVER");
		clearScreen();
		delay(200);
		text("GAME OVER", 300, 300);
	}
}

void shoot(int winner) {
	switch(winner) {
		case WRVoteData.DEMOCRAT:
			sendMessage('W','D');
			break;
		case WRVoteData.REPUBLICAN:
			sendMessage('W','R');
			break;
	}
}

void mouseClicked() {
	exit();
}

void sendMessage(char tag, int value){
  port.write(HEADER);
  port.write(tag);
  port.write(value);
}

void clearScreen() {
	println("Clear screen");
	/*background(242, 19, 19);*/
	background(black);
	drawTitle();
	drawGameDate();
	drawMap();
}

void drawMap() {
    int mapXPos = screenXMid-red_map.width/2;
    int mapYPos = screenYMid-red_map.height/2;
	if(gop_score > dems_score) {
		image(red_map, mapXPos, mapYPos);
	} else if (gop_score < dems_score) {
		image(blue_map, mapXPos, mapYPos);		
	} else {
		image(flag_map, mapXPos, mapYPos);		
	}
}

void drawTitle() {
	textFont(title_font);
	fill(white);
	textAlign(CENTER);
	text(game_title, 0, 20, screen.width, 100);
	/*image(title_image, screenXMid-title_image.width/2, screenYMid-title_image.height/2);*/
}

void drawGameDate() {
	textFont(bill_font);
	fill(grey);
	textAlign(CENTER);
	text(game_date, 0, 100, screen.width, 40);
}

void drawScore() {
        int tbWidth = 200;
        int tbHeight = 200;
	textFont(score_font);
	String d = "D:"+str(dems_score);
	String r = "R:"+str(gop_score);
	fill(blue);
        textAlign(LEFT);
	text(d, 50, 90, tbWidth, tbHeight);
	fill(red);
        textAlign(RIGHT);
	text(r, screen.width-(tbWidth+50), 90, tbWidth, tbHeight);
	fill(white);
}

void drawBill() {
	WRVote current_vote = (WRVote)vote_data.votes.get(vote_count);
	String text = current_vote.bill_number + ": " + current_vote.date.toString();
	textFont(bill_font);
        textAlign(CENTER);
	text(text, screenXMid-400, 700, 800, 200);
}

