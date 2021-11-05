
from transformers import pipeline, Conversation

from flask import Flask, request
import warnings

warnings.filterwarnings("ignore")


api = Flask(__name__)

conversational_pipeline = pipeline(
    "conversational", model="facebook/blenderbot-1B-distill")
conversation = Conversation()


@api.route('/ping', methods=['GET'])
def ping():
    return "pong", 200


@api.route('/append-conf', methods=['POST'])
def answer_conversation():
    data = request.json

    conversation.add_user_input(data['text'])

    chat_response = conversational_pipeline(
        [conversation]).generated_responses
    print("Responding with: ", chat_response)

    return ({'text': chat_response[-1]}), 201


if __name__ == '__main__':
    api.run()
