import consumer from "./consumer"
import { AnswerTemplates } from '../templates/answer_templates'

consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
  connected() {
    this.perform('follow')
  },

  received(data) {
    const answerTemplates = new AnswerTemplates(data)

    $(".answers-list").append(data['rendered'])
    $('#answer-' + data['answer']['id'] + ' .actions').html(answerTemplates.answer_actions())
  }
});
