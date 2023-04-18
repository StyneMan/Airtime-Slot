class OnboardingModel {
  late String title;
  late String description;
  late String image;

  OnboardingModel({
    required this.description,
    required this.image,
    required this.title,
  });
}

List<OnboardingModel> onboardingList = [
  OnboardingModel(
    description:
        "Top up phone airtime or internet data. Pay electricity bills; renew TV subscriptions. Buy quality insurance covers, pay education bills, transfer funds and do more.",
    image: "assets/images/mslide1.png",
    title: "Mobile payments made easy",
  ), 
  OnboardingModel(
    description:
        "An online bill payement platform that allows users to remotely pay for value added services online. A platform for all your Telecom needs. Use more, Pay less.",
    image: "assets/images/mslide2.png",
    title: "Enjoy flexible bills payment",
  ),
  OnboardingModel(
    description:
        "Do you have any questions or do you want to make enquiries on our services? We are eager to hear from you. Reach un our contact emails and phone numbers. Thank you for choosing our platform. We promise to serve you better.",
    image: "assets/images/mslide3.jpg",
    title: "Contact us for more information",
  ),
];
