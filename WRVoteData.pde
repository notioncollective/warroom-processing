

public class WRVoteData {
	
	public static final int SENATE = 0;
	public static final int HOUSE = 1;
	public static final int DEMOCRAT = 2;
	public static final int REPUBLICAN = 3;
	
	public static String API_KEY;
	
	
	public ArrayList senate_votes;
	public ArrayList house_votes;
	public ArrayList votes;
	
	public Date start_date;
	public Date end_date;
	
	
	public WRVoteData(XMLElement house_xml, XMLElement senate_xml, String api_key ) {
		WRVoteData.API_KEY = api_key;
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



/**
 *  WRApiObject is a generic object to wrap API calls. Meant to be extended 
 *	and overridden.
 *
 *	@author Andrew Dayton
 *	@since  06.08.2011
 */
public class WRApiObject {
	public String obj_uri; // the api endpoint for this obj
	public XMLElement obj_uri_response; // xml for entire response
	public XMLElement obj_xml_element; // xml for individual object
	private String api_key; // api_key
	
	public WRApiObject(String obj_uri, String api_key) {
		this.obj_uri = obj_uri;
		this.api_key = api_key;
		this.obj_uri_response = this.apiCall();
		this.obj_xml_element = isolateObjectXml(this.obj_uri_response);
	}
	
	public String get(Stirng element_name) { this.getChildElement(element_name); }
	public String getChildElement(String element_name) {
		return obj_xml_element.getChildElement(element_name);
	}
	
	// this will need to be overridden
	private XMLElement isolateObjectXml(XMLElement xmlResponse) {
		return xmlResponse.getChild('results');
	}
	
	private XMLElement apiCall() {
		String path = this.obj_uri + "&api-key=" + this.api_key;
		XMLElement xmlResponse = new XMLElement(xmlResponse);
		return xmlResponse;
	}
	
	private String loadUri(String path) {
		String lines[] = loadStrings(path);
		if(lines == null) { prinln "API read error: "+path; return null; }
		String response = join(lines, "\n");
		
		return response;
	}
	
}

/**
 *  WRMember is a wrapper for the NYT Congress API member method
 *	http://developer.nytimes.com/docs/read/congress_api#h3-member-roles
 *
 *	@author Andrew Dayton
 *	@since  06.08.2011
 */
public class WRMember extends WRApiObject {
	public WRMember(String member_uri, String api_key) {
		super(member_uri, api_key);
	} 
	private XMLElement isolateObjectXml(XMLElement xmlResponse) {
		return xmlResponse.getChild('results/member');
	}
}

/**
 *  WRBill is a wrapper for the NYT Congress API Bill Details method
 *	http://developer.nytimes.com/docs/read/congress_api#h3-bill-details
 *
 *	@author Andrew Dayton
 *	@since  06.08.2011
 */
public class WRBill extends WRApiObject {
		
	public WRBill(String member_uri, String api_key) {
		super(member_uri, api_key);
	}
	
	public WRBill(String bill_id, int congress, String api_key) {
		super(getEndpoint(bill_id, congress), api_key);
	}
	
	private getEndpoint(String bill_id, int congress) {
		String uri = "http://api.nytimes.com/svc/politics/v3/us/legislative/congress/"+ congress+"/bills/" + WRBill.cleanBillNumber(bill_id) + ".xml?api-key=" + api-key;
		return uri;
	}
	
	public static String cleanBillNumber(String bill_number) {
		String clean_bill_number = bill_number;
		String[] rm_chars = { ' ','.'	}
		for(int i=1; i<rm_chars.length; i++) {
			String[] split = split(clean_bill_number, rm_chars[i]);
			clean_bill_number = join(split);
		}
		return clean_bill_number;
	}}


/**
 *  WRVote is (sort of) a wrapper for a NYT Congress API vote
 *	http://developer.nytimes.com/docs/read/congress_api#h2-votes
 *
 *	@author Andrew Dayton
 *	@since  06.08.2011
 */
public class WRVote {
	
	public WRBill bill;
	public int chamber;
	public Date date;
	public int congress;
	public int session;
	public String bill_number;
	public String result;
	public String description;
	public int party_affiliation;
		
	public WRVote(XMLElement vote_xml, int chamber) {
		this.bill = new WRBill(this.bill_number, this.congress, WRVoteData.API_KEY);
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
		println(bill.get("title"));
		
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