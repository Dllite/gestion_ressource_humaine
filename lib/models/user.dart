class User {
  final String name;
  final String email;
  final String poste;
  final String image;
  User(this.name,  this.email, this.poste, this.image);
  
}

  List<User> users = [
    User("Alice Johnson", "alice.johnson@example.com", "Developer", "https://example.com/images/alice.jpg"),
    User("Bob Smith", "bob.smith@example.com", "Designer", "https://example.com/images/bob.jpg"),
    User("Charlie Brown", "charlie.brown@example.com", "Manager", "https://example.com/images/charlie.jpg"),
    User("Diana Prince", "diana.prince@example.com", "Product Owner", "https://example.com/images/diana.jpg"),
    User("Ethan Hunt", "ethan.hunt@example.com", "QA Engineer", "https://example.com/images/ethan.jpg"),
    User("Fiona Gallagher", "fiona.gallagher@example.com", "HR", "https://example.com/images/fiona.jpg"),
    User("George Clark", "george.clark@example.com", "Developer", "https://example.com/images/george.jpg"),
    User("Hannah Montana", "hannah.montana@example.com", "Marketing", "https://example.com/images/hannah.jpg"),
    User("Ian Somerhalder", "ian.somerhalder@example.com", "Support", "https://example.com/images/ian.jpg"),
    User("Jack Sparrow", "jack.sparrow@example.com", "Captain", "https://example.com/images/jack.jpg"),
  ];
