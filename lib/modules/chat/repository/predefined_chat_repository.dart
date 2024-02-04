class PredefinedChatRepository {
  List<PredefinedModel> questionsAnswersList = [
    PredefinedModel(id: 1, question: 'What is JOIN?', answer: 'The JOIN (Jump Over Individual Negativity) program is a comprehensive self-help and motivational system designed to foster personal growth, emotional well-being, and success. Centered around a cyclical routine of end-of-day review, next-day planning, and morning adjustment, the program encourages continuous reflection, goal-setting, and adaptability. This structured yet adaptable approach minimizes negativity, enhances self-awareness, boosts motivation and productivity, promotes adaptability, and provides a daily sense of achievement, empowering individuals to take control of their lives and achieve their desired outcomes.'),
    PredefinedModel(id: 2, question: 'How can JOIN help me?', answer: 'The JOIN (Jump Over Individual Negativity) program offers a holistic approach to improving both your personal and professional life. In your personal life, it enhances self-awareness through daily reflection, fosters emotional well-being by helping you manage negative emotions, supports personal development with goal-setting, and improves relationships by boosting emotional intelligence. Professionally, JOIN increases productivity by encouraging daily goal-setting and reflection, aids in career progression through self-assessment and targeted objectives, enhances leadership skills by emphasizing self-awareness and adaptability, and helps achieve a balanced work-life through mindful planning. Overall, JOIN equips you with the tools for personal growth, emotional well-being, and professional success, leading to a more fulfilled and balanced life'),
    PredefinedModel(id: 3, question: 'How do I fill out the JOIN Journal?', answer: 'To fill out the JOIN Journal, start with an "End-of-day Review" where you jot down your accomplishments for the day. Next, list "Things I Can Improve Upon," noting any obstacles that affected your schedule. Add "Positive Affirmations" for making improvements like "I am amazing at filling out my JOIN form" to boost your mindset. Plan "List Hourly Tasks for Tomorrow" to set a roadmap for your day ahead. In the morning, complete the "Morning Refinement" section to review your schedule and make any necessary adjustments to meet your goals. Finally, confirm that your "Daily Goal" is still in alignment with your broader objectives.'),
  ];

  PredefinedModel getAnswer(int id) {
    return questionsAnswersList.firstWhere((element) => element.id == id);
  }


}

class PredefinedModel {
  final int id;
  final String question;
  final String answer;

  PredefinedModel({required this.id, required this.question, required this.answer});
}
