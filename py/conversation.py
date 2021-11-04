import json
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


@api.route('/append-conf', methods=['GET'])
def answer_conversation():
    # a quick dance to accept json through QUERY PARAMETER, GOD!!!
    obj = json.loads(request.args.get('text'))
    conversation.add_user_input(obj['text'])

    chat_response = conversational_pipeline(
        [conversation]).generated_responses
    print(chat_response)

    return ({'data': chat_response[-1]}), 201


if __name__ == '__main__':
    api.run()
