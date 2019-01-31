import 'package:q_and_a/model/json/AnswersUsers.dart';

class QuestionsAndAnswers {
  final int userId;
  final String userName;
  final int questionId;
  final String questionContent;
  final List<AnswersUsers> answersUser;

  QuestionsAndAnswers(this.userId, this.userName, this.questionId,
      this.questionContent, this.answersUser);
}
