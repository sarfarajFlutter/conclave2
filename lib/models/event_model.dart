class EventModel {
  List<EventDetails>? eventDetails;


  EventModel({this.eventDetails});

  EventModel.fromJson(Map<String, dynamic> json) {
    if (json['event details'] != null) {
      eventDetails = <EventDetails>[];
      json['event details'].forEach((v) {
        eventDetails!.add(new EventDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.eventDetails != null) {
      data['event details'] = this.eventDetails!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class EventDetails {
  String? image;
  String? speakername;
  String? description;
  String? day;

  EventDetails({this.image, this.speakername, this.description,this.day});

  EventDetails.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    speakername = json['speakername'];
    description = json['description'];
    day=json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['speakername'] = this.speakername;
    data['description'] = this.description;
    data['day']=this.day;
    return data;
  }
}
