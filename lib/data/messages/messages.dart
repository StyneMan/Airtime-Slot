class Messages {
  late String title;
  late String description;
  late String createdAt;
  String? image;
  late String summary;

  Messages({
    required this.createdAt,
    required this.description,
    required this.image,
    required this.summary,
    required this.title,
  });
}

List<Messages> messagesList = [
  Messages(
    createdAt: "2023-04-02 07:08:49",
    description:
        "Welcome to our platform. Feel free to ask questions for clarity",
    image: "",
    summary: "Welcome to our platform.",
    title: "New user",
  ),
  Messages(
    createdAt: "2023-04-02 07:08:49",
    description:
        "To this class, make you a dependency on cupertino_icons in your file. This that the CupertinoIcons font is in your application. This font is used to",
    image: "assets/images/placeholder.png",
    summary: "Welcome to our platform. Dummy text",
    title: "Dummy Information Text",
  ),
  Messages(
    createdAt: "2023-04-02 07:08:49",
    description:
        "Welcome to our platform. Feel free to ask questions for clarity",
    image: "assets/images/placeholder.png",
    summary: "Welcome to our platform.",
    title: "New user",
  ),
];
