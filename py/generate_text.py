## Common

import warnings
import sys

warnings.filterwarnings("ignore")


# FIRST

from transformers import logging, pipeline, set_seed, Conversation

generator = pipeline(task='text-generation', model='gpt2')

text = sys.argv[1]
length = sys.argv[2]

set_seed(42)

print(
    generator(
        text, 
        max_length=int(length), 
        num_return_sequences=1
    )[0]['generated_text'])

# THIRD

# from transformers import logging, pipeline, set_seed

# predictor = pipeline("zero-shot-classification", model="valhalla/distilbart-mnli-12-9")
# result = predictor(
#     sequences=[
#         "This is just a text that doesn't really claim anything",
#         "I believe this hypothesis because I like it",
#         "I should have seen this coming",
#         "My family thinks this way",
#         "I'm good and everyone else is bad",
#         "Had a class on speaking in public. I continue to be amazed at how big a deal is attitude when it comes to learning. Education is right here, it lies right in front of you, then why feel bored or frightened?",
#     ],
#     candidate_labels=[
#         "general neutral",
#         "confirmation bias",
#         "hindsight bias",
#         "cultural bias",
#         "self-serving bias",
#     ],
# )

# for a in result:
#     print(a["sequence"])
#     print(a["labels"])
#     print(a["scores"])
#     print()

