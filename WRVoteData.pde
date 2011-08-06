

public class WRVoteData {
	
	public static final int SENATE = 0;
	public static final int HOUSE = 1;
	public static final int DEMOCRAT = 2;
	public static final int REPUBLICAN = 3;
	
	public ArrayList senate_votes;
	public ArrayList house_votes;
	public ArrayList votes;
	
	public Date start_date;
	public Date end_date;
	
	public String api_key;
	
	public WRVoteData(XMLElement house_xml, XMLElement senate_xml, String api_key ) {
		this.api_key = api_key;
		this.senate_votes = getWRVoteArrayList(senate_xml, WRVoteData.SENATE);
		this.house_votes = getWRVoteArrayList(house_xml, WRVoteData.HOUSE);
		
		this.votes = new ArrayList();
		votes.addAll(senate_votes);
		votes.addAll(house_votes);		
	}
	
	
	
	private ArrayList getWRVoteArrayList(XMLElement xml, int chamber) {
		XMLElement[] vote_elements = xml.getChildren("results/votes/vote");
		ArrayList al = new ArrayList();	
		
		for(int i=0; i<vote_elements.length; i++) {
			WRVote vote = new WRVote(vote_elements[i], chamber);
			al.add(vote);
		}

		return al;
	}
}

public class WRVoteTimeline {}

public class WRVote {
	
	public int chamber;
	public Date date;
	public int congress;
	public int session;
	public String bill_number;
	public String result;
	public String description;
	public int party_affiliation;
		
	public WRVote(XMLElement vote_xml, int chamber) {
		this.date = this.formatDate(vote_xml);
		this.chamber = chamber;
		this.congress = Integer.parseInt(vote_xml.getChild("congress").getContent());
		this.congress = Integer.parseInt(vote_xml.getChild("session").getContent());
		this.bill_number = vote_xml.getChild("bill_number").getContent();
		this.result = vote_xml.getChild("result").getContent();
		this.description = vote_xml.getChild("description").getContent();
		this.party_affiliation = this.getPartyAffiliation(vote_xml);
	}
		
	private int getPartyAffiliation(XMLElement vote_xml) {
		return WRVoteData.DEMOCRAT;
	}
	
	// grab date & time from the XMLElement, return a date object
	private Date formatDate(XMLElement e) {
		String date = e.getChild("date").getContent();
		String time = e.getChild("time").getContent();
		String date_time =  date + " " + time;
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date parsed = new Date();
		// do it
		try{
			parsed = format.parse(date_time);
		} catch(ParseException pe) {
			println("ERROR: Cannot parse \"" + date_time + "\"");
		}

		return parsed;
	}
}