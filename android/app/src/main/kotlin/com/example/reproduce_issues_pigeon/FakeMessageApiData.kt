package com.example.reproduce_issues_pigeon

class FakeMessageApiData : Pigeon.MessageApi {

    private val messages = listOf(
        Pigeon.Message.Builder().setSubject("Subject 1").setBody("Hello 1")
            .setEmail("people1@gmail.com").build(),
        Pigeon.Message.Builder().setSubject("Subject 2").setBody("Helle 2")
            .setEmail("people2@gmail.com").build(),
        Pigeon.Message.Builder().setSubject("Subject 3").setBody("Hello 3")
            .setEmail("people3@gmail.com").build(),
    )

    override fun getMessages(email: String): MutableList<Pigeon.Message> {
        return messages.filter {
            it.email.contains(email)
        }.toMutableList()
    }
}