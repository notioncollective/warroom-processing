

public class WRVoteData {
	
	public static final int SENATE = 0;
	public static final int HOUSE = 1;
	public static final int DEMOCRAT = 2;
	public static final int REPUBLICAN = 3;
        public static final int TIE = 4;
	
	private String api_key;
	
	public ArrayList senate_votes;
	public ArrayList house_votes;
	public ArrayList votes;
	
	public Date start_date;
	public Date end_date;
	
	public HashMap bill_cache;
	
	public WRVoteData(XMLElement house_xml, XMLElement senate_xml, String api_key ) {
		this.bill_cache = new HashMap();
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
		
		println(vote_elements.length);
		
		for(int i=0; i<vote_elements.length; i++) {
			if(filterVote(vote_elements[i])) {
				WRVote vote = new WRVote(vote_elements[i], chamber, this.api_key);
				println(vote.bill_number);
				al.add(vote);
//				if(!bill_cache.containsKey(vote.getCleanBillNumber())) {
//					bill_cache.put(vote.getCleanBillNumber(), vote.bill);
//				}
//				try {
//					Thread.sleep(200);
//				} catch(InterruptedException e) {
//					println("ERROR! Throw that shit.");
//				}
			}
		}
		return al;
	}
	
	private boolean filterVote(XMLElement vote) {
				
		// check to see if there is a value for bill_number
		if(vote.getChild("bill_number").getContent() == null) {
			return false;
		}
		
		// check to make sure it's a house/senate bill (not a nomination)
		String bill_number_first_char = vote.getChild("bill_number").getContent().substring(0,1);
		if(!(bill_number_first_char.equals("H") || bill_number_first_char.equals("S"))) {
			return false;
		}
		
		// check to make sure it's not a motion
		if(match(vote.getChild("result").getContent(),"Motion") != null) { return false; }		
		
		// guess it's ok?
		return true;
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
	
	public String get(String element_name) { 
		return this.getChildElement(element_name);
	}
	
	public String getChildElement(String element_name) {
		return obj_xml_element.getChild(element_name).getContent();
	}
	
	// this will need to be overridden
	private XMLElement isolateObjectXml(XMLElement xmlResponse) {
		return xmlResponse.getChild("results");
	}
	
	private XMLElement apiCall() {
		String path = this.obj_uri + "?api-key=" + this.api_key;
		XMLElement xmlResponse = new XMLElement(loadUri(path));
		return xmlResponse;
	}
	
	private String loadUri(String path) {
		println("Load url: "+path);
		String lines[] = loadStrings(path);
		/*if(lines == null) { println("API read error: "+path); return null; }*/
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
		return xmlResponse.getChild("results/member");
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
	
}


/**
 *  WRVote is (sort of) a wrapper for a NYT Congress API vote
 *	http://developer.nytimes.com/docs/read/congress_api#h2-votes
 *
 *	@author Andrew Dayton
 *	@since  06.08.2011
 */
public class WRVote {
	
	private String api_key;
	
//	public WRBill bill;
	public int chamber;
	public Date date;
	public int congress;
	public int session;
	public String bill_number;
	public String result;
	public String description;
	public int party_affiliation;
        public int winner;
		
	public WRVote(XMLElement vote_xml, int chamber, String api_key) {
		
		this.api_key = api_key;
		
		this.date = this.formatDate(vote_xml);
		this.chamber = chamber;
		this.congress = Integer.parseInt(vote_xml.getChild("congress").getContent());
		this.session = Integer.parseInt(vote_xml.getChild("session").getContent());
		this.bill_number = vote_xml.getChild("bill_number").getContent();
		this.result = vote_xml.getChild("result").getContent();
		this.description = vote_xml.getChild("description").getContent();
		this.party_affiliation = this.getPartyAffiliation(vote_xml);
		
                this.winner = this.getWinner(vote_xml);
                
                
		// get the bill
//		// check the bill cache
//		if(bill_cache.containsKey(this.cleanBillNumber(this.bill_number))) {
//			this.bill = (WRBill)bill_cache.get(this.cleanBillNumber(this.bill_number));
//		} else {
//			String bill_uri = this.buildBillUri(this.congress, this.bill_number, api_key);
//			this.bill = new WRBill(bill_uri, this.api_key);
//		}
	}

        private int getWinner(XMLElement vote_xml) {
          // @TODO check if bill passed (regex pending from Andy)
          int billPassed = 1;
          
          // check dem majority pos
          String demPosStr = vote_xml.getChild("democratic").getChild("majority_position").getContent();
          println("Dem Position: "+demPosStr);
          int demPosInt = 0;
          if(demPosStr.equals("Yes")) { 
            demPosInt = 1;
          }
          
          // check dem majority pos
          String repPosStr = vote_xml.getChild("republican").getChild("majority_position").getContent();
          println("Rep Position: "+repPosStr);
          int repPosInt = 0;
          if(repPosStr.equals("Yes")) { 
            repPosInt = 1;
          }
          
          // TIE
          if(repPosInt == demPosInt) {
            return 4;
          }
          
          // DEM WIN
          if(demPosInt == billPassed && repPosInt != billPassed) {
            return 2;
          }
          
          // REP WIN
          if(repPosInt == billPassed && demPosInt != billPassed) {
            return 3;
          }
          
          return 4;
        }

		
	private int getPartyAffiliation(XMLElement vote_xml) {
		/*println(this.bill.get("title"));*/
		
		return WRVoteData.DEMOCRAT;
	}
	
//	public String buildBillUri(int congress, String bill_id, String api_key) {
//		String uri = "http://api.nytimes.com/svc/politics/v3/us/legislative/congress/"+ congress+"/bills/" + this.cleanBillNumber(bill_id) + ".xml";
//		return uri;
//	}
	
	public String getCleanBillNumber() {
		return this.cleanBillNumber(this.bill_number);
	}
	
	public String cleanBillNumber(String bill_number) {
		String clean_bill_number = bill_number;
		char[] rm_chars = { ' ','.'	};
		for(int i=0; i<rm_chars.length; i++) {
			String[] splitted = split(clean_bill_number, rm_chars[i]);
			clean_bill_number = join(splitted, "");
		}
		return clean_bill_number;
	}
	
	public boolean interpretResult(String result) {
		Pattern passPattern = Pattern.compile("pass|agree|confirm", Pattern.CASE_INSENSITIVE);
		Pattern failPattern = Pattern.compile("fail|reject", Pattern.CASE_INSENSITIVE);
		if(match(result, passPattern)) {
			return true;
		} else if(match(result, failPattern)) {
			return false;
		} else { return null; }
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
