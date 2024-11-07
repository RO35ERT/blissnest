class Quote {
  final String quote;
  final String author;

  Quote({required this.quote, required this.author});

  // Factory method to create a Quote from JSON
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quote: json['q'],
      author: json['a'],
    );
  }
}
