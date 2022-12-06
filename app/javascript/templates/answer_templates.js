export class AnswerTemplates {
    constructor(data) {
        this.answer = data['answer']
        this.author_id = this.answer['author_id']
        this.answer_id = this.answer['id']
        this.question_author_id = data['question_author_id']
    }

    answer_actions() {
        let answer_actions_html = ""

        if (this.author_id === gon.user_id) {
            answer_actions_html =
                "<a class='btn btn-outline-dark fw-bold me-3' data-confirm='Are you sure?'" +
                " data-remote='true' rel='nofollow' data-method='delete' href='/answers/" +
                this.answer_id +
                "'>Delete</a>" +
                "<a class='ml-1 btn btn-outline-dark fw-bold me-3 edit-answer-link' data-answer-id='" +
                + this.answer_id + "' href='#'>Edit</a>"
        }

        if (this.question_author_id === gon.user_id && !this.answer["best"]) {
            answer_actions_html = answer_actions_html +
              "<a class='ml-1 btn btn-outline-dark fw-bold' data-answer-id=" +
              this.answer_id +
              "data-remote='true' rel='nofollow' data-method='patch" +
              "href='/answers/" + this.answer_id + "/best'>Best</a>"
        }

        return answer_actions_html
    }
}
