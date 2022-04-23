class ReplyMailbox < ApplicationMailbox
  MATCHER = /^conversation-(\d+)@/i

  # This runs in a job
  def process
    conversation.posts.create!(
      author: author,
      body: body,
      message_id: mail.message_id,
    )
  end

  def author
    (user = User.find_by(email: from.address)) ? user : contact
  end

  def conversation
    Conversation.find(conversation_id)
  end
  def conversation_id
    mail.recipients.find { |r| MATCHER.match?(r) }[MATCHER, 1]
  end
end
