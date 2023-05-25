require "openai"

class Cpbvt::Validations::Aws2023
  def self.run
    client = OpenAI::Client.new

    response = client.chat(
        parameters: {
            model: "gpt-3.5-turbo", # Required.
            messages: [{ role: "user", content: content}],
            temperature: 0.7,
        })
    puts response.dig("choices", 0, "message", "content")
  end # self.run
end # class