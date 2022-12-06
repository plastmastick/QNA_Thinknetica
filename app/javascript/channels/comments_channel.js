import consumer from "./consumer"

consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id || null }, {
  connected() {
    this.perform('follow')
  },

  received(data) {
    $('#' + data['resource'] + "-" + data['id'] + ' .comments-list').append(data['rendered'])
  }
});
