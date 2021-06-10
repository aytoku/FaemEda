class FAQData{

  List<FAQ> faqList;

  FAQData( {
    this.faqList,
  });

  factory FAQData.fromJson(List<dynamic> parsedJson){
    List<FAQ> list = null;
    if(parsedJson != null){
      list = parsedJson.map((i) => FAQ.fromJson(i)).toList();
    }

    return FAQData(
      faqList:list,
    );
  }
}

class FAQ {
  FAQ({
    this.id,
    this.application,
    this.question,
    this.answer,
    this.createdAt,
  });

  final int id;
  final String application;
  final String question;
  final String answer;
  final DateTime createdAt;

  factory FAQ.fromJson(Map<String, dynamic> json) => FAQ(
    id: json["id"] == null ? null : json["id"],
    application: json["application"] == null ? null : json["application"],
    question: json["question"] == null ? null : json["question"],
    answer: json["answer"] == null ? null : json["answer"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "application": application == null ? null : application,
    "question": question == null ? null : question,
    "answer": answer == null ? null : answer,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
  };
}
