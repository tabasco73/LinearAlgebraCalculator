import time
import openai
from openai import OpenAI
import json
from dotenv import load_dotenv
import os
from utility.utility_openai import function_call_choice_fill, function_call_fill

load_dotenv()
openai.api_key = os.getenv('OPENAI_API_KEY')
client = OpenAI()

# Serial-messaging

def retry_wrapper(func, *args, **kwargs):
    for attempt in range(3):  # Attempt up to 3 times
        try:
            return func(*args, **kwargs)  # Try to execute the function
        except Exception as e:
            print(f"Attempt {attempt + 1} failed: {e}")
            if attempt < 2:  # If this is not the last attempt, wait before retrying
                time.sleep(1)  # Optional: wait for 1 second before retrying
    raise Exception("Operation failed after 3 attempts")


def call_openai_chat_completion(model, messages, temperature = 0):
    return client.chat.completions.create(model=model, messages=messages, temperature = temperature)


def gpt_caller_pure(messages, model="gpt-4"):
    try:
        response = retry_wrapper(call_openai_chat_completion, model, messages, 0)
        message_content = response.choices[0].message.content
        return message_content
    except Exception as e:
        print("Final failure:", e)

def query_openai_with_serialmess(messages, model_choice="gpt-4"):
    """Main method for sending multiple messages in OpenAI's GPT-4 API."""
    resp = gpt_caller_pure(messages, model_choice)
    if resp:
        return resp
    else:
        return "No response received from OpenAI API."

# Function calling

def gpt_caller_fc(messages, tools, tool_choice, model = "gpt-4-turbo"):
    response = client.chat.completions.create(
        model=model,
        messages=messages,
        tools=tools,
        tool_choice=tool_choice,
        temperature = 0
    )
    return response

def query_openai_with_function_calling(system_prompt: str, user_prompt: str, functions, function_call = 'auto', model_choice = "gpt-4-turbo"):
    """Main method for function calling in OpenAI's GPT-4 API."""
    messages = [{"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt}]
    resp = gpt_caller_fc(messages, functions, function_call, model_choice)
    extracted_json_string = resp.choices[0].message.tool_calls[0].function.arguments
    return json.loads(extracted_json_string)


def fc_test():
    #query_openai_with_function_calling(system_prompt: str, user_prompt: str, functions, function_call = 'auto', model_choice = "gpt-4-1106-preview")
    fc_schema = function_call_fill('Functioncalls/test.json')
    fc_choice = function_call_choice_fill("get_current_weather")
    syst =  "You are a weather expert"
    prompt =  "What's the weather like in San Francisco, Tokyo, and Paris?"
    answer = query_openai_with_function_calling(syst, prompt, fc_schema, fc_choice, "gpt-4o")
    print(f'{answer=}')



def series_test():
    system_prompt = 'Du är en trevlig person'
    user_prompt = 'Rimma på Rasmus.'
    messages = [{"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt},
                {"role": "assistant", "content": r"""Här är några ord som rimmar på Rasmus:

1. Kasmus (ett påhittat ord eller namn, inte standard)
2. Asmus (en variant av namnet Asmus)
3. Trasmus (ett påhittat ord eller namn, inte standard)

Det är svårt att hitta exakta rim på namnet Rasmus eftersom det är ganska unikt. Ofta när man skapar rim till namn kan man behöva vara kreativ och använda sig av ljudlikheter eller delar av ord som låter liknande."""},
                {"role": "user", "content": 'Toppen men jag skulle vilja ha riktiga ord.'}
               ]

    response = query_openai_with_serialmess(messages, model_choice="gpt-4")
    print(f'{response=}')


if __name__ == '__main__':
    fc_test()
    series_test()