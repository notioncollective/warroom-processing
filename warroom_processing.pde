 // War Room @ eyebeam for #arthack Aug 2011

import java.text.SimpleDateFormat;

WRVoteData vote_data;
String HOUSE_TEST_DATA_PATH = "xml/house_2011-02.xml";
String SENATE_TEST_DATA_PATH = "xml/senate_2011-02.xml";
String API_KEY = "d79e05d7ab36d22f0b1ff14d30c48ae3:10:40476694";


void setup() {
	size(1024, 768);
	XMLElement house = new XMLElement(this, HOUSE_TEST_DATA_PATH);
	XMLElement senate = new XMLElement(this, SENATE_TEST_DATA_PATH);
	/*XMLElement[] house_votes = grabVotes(house);	*/
	/*XMLElement[] senate_votes = grabVotes(senate);*/
	// merge house and senate votes, then merge by date/time
	/*XMLElement[] votes = mergeArrays(house_votes, senate_votes);*/
	/*votes = sortByDate(votes);*/
	/*println(votes.length);*/
	
	vote_data = new WRVoteData(house, senate, API_KEY);
	
	votes = vote_data.votes;
	
	// print house votes
	for(int i=0; i < votes.length; i++) {
		String result = votes.get(i).result;
		// Make sure the vote didn't fail ( alternatives are "Passed" for bill and "Agreed to" for amendments)
		if(!result.equals("Failed")) {
			println(votes.get(i).description;
		}
	}
	
}

// grab votes from the root xmnl node
/*XMLElement[] grabVotes(XMLElement xml) {
	String path = "results/votes/vote";
	return xml.getChildren(path);
}*/

// sort merged votes
/*XMLElement[] sortByDate(XMLElement[] v) {
	XMLElement[] sorted = new XMLElement[0];
	for(int i=1; i < v.length; i++) {
		XMLElement current_vote = v[i];
		Date current_vote_date = grabDateTime(current_vote);
		// if the array is empty, add as first item
		if(sorted.length <= 0) {
			append(sorted, current_vote);
		} 
		Date first_sorted_date = grabDateTime(sorted[0]);
		
		// if this date is lower than first sorted date
		if (current_vote_date.before(first_sorted_date)) {
			XMLElement[] tmp_array = new XMLElement[1];
			tmp_array[0] = current_vote;
			// ads to the beginning of sorted
			sorted = mergeArrays(tmp_array, sorted);
			
		// otherwise, iterate up through sorted values until it finds a place for current date
		} else {
			for(int j=1; j < sorted.length; j++) {
				Date current_sorted_date = grabDateTime(sorted[j]);
				// if current vote date is greater than or equal to vote at index j
				if( current_vote_date.after(current_sorted_date) || current_vote_date.equals(current_sorted_date)) {
					// if there is another vote after this in the sorted array
					if(sorted.length > j) {
						// check to see if it's smaller than the next sorted date
						if( current_vote_date.before(grabDateTime(sorted[j+1]))) {
							// splice in between
							// splice(sorted, j, current_vote_date);
						}
					// otherwise we're at the end, append this vote
					} else {
						append(sorted, current_vote);
					}
				}
			}
		}
	}
	// ghetto error mgmt
	if(v.length != sorted.length) {
		println("ERROR! sortByDate() result array isn't same length as original");
	}
	return sorted;
}*/

// grab date & time from the XMLElement, return a date object
/*Date grabDateTime(XMLElement e) {
	String date = e.getChild("date").getContent();
	String time = e.getChild("time").getContent();
	String date_time =  date + " " + time;
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	Date parsed = new Date();
	// do it
	try{
		parsed = format.parse(date_time);
		println(parsed.toString());
	} catch(ParseException pe) {
		println("ERROR: Cannot parse \"" + date_time + "\"");
	}
	
	return parsed;
}*/

// merge the two arrays
// (oops, reinventing the wheel)
/*XMLElement[] mergeArrays(XMLElement[] a1, XMLElement[] a2) {
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
}*/