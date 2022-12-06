import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    this.perform('follow')
  },

  received(data) {
    const questionsList = $('.questions-list');
    questionsList.append(data)
  }
});
