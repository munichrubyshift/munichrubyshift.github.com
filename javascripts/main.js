function init() {
    var next_meetup = meetups.shift();
    var past_meetups = createMeetups(meetups);
    $('#past_meetups').replaceWith(past_meetups);
    var next_talks = createTalks(next_meetup.talks);
    $('#next_talks').replaceWith(next_talks);

    $(".talk").click(function(data) {
      var sd = $(this).find(".shortdesc");
      sd.toggle("slow");
    });

    $(".speaker").click(function(data){
      var sd = $(this).find(".shortdesc");
      var person_id = $(sd).attr("person");
      if (person_id != "" && person_id != null){
        //sd.html($("#" + person_id).html());
        sd.html(speakers[person_id]);
        sd.toggle("slow");
      }
    });
}

function createMeetups(meetups) {
	var result = "";
	for (var index in meetups) {
		result += createMeetup(meetups[index]);
	}
	return result;
}

function createMeetup(meetup) {
  	return  "<div class='span9 meeting dotted-white-up'>\n" +
          	"   <div class='span9 meeting-header'>" + meetup.date + "</div>\n" +
          	createTalks(meetup.talks, "white") + 
          	"</div>\n";
};

function createTalks(talks, cssclass) {
  	var result = "";
  	for (var index in talks) {
    	result += createTalk(talks[index], cssclass) + "\n";
  	}
  	return result;
};

function createTalk(talk, cssclass) {
	cssclass = cssclass ? cssclass : "grey";
  	return	'   <div class="span12 talk-entry">\n' +
          	'       <div class="span3 speaker">\n' +
          	'           <span>' + createName(talk.speaker) + '</span>\n' +
          	'           <div class="shortdesc ' + cssclass + '" person="' + talk.speaker + '"></div>\n' +
          	'       </div>\n' +
          	'       <div class="span9 talk">\n' +
          	'           <span>' + talk.title + '</span>\n' +
          	'           <div class="shortdesc ' + cssclass + '">' + talk.desc + '</div>\n' +
          	'       </div>\n' +
          	'	</div>\n';
}

function createName(name) {
  var parts = name.split("_");
  return capitalize(parts[0]) + " " + capitalize(parts[1]);
}

function capitalize(name) {
  return name.charAt(0).toUpperCase() + name.slice(1);
}