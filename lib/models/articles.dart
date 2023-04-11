class Article {
    final String title;
    final String subtitle;
    final String imageUrl;
    final String tag;

    Article({
      required this.imageUrl, 
      required this.subtitle, 
      required this.title, 
      required this.tag});

    factory Article.fromJson(Map<String, dynamic> json) {
      return Article(
        imageUrl: json['image'], 
        subtitle: json['subtitle'], 
        title: json['title'],
        tag: json['tag']);
    }
}