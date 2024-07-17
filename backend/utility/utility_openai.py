import tiktoken
from .utility_files import read_json

def count_tokens(string_inp):
    encc = tiktoken.encoding_for_model("gpt-4")
    encoded_str = encc.encode(string_inp)
    return len(encoded_str)

def count_all_tokens(prompt_list, systemmess):
    count = 0
    for i in prompt_list:
        count += count_tokens(i)
    count += count_tokens(systemmess) * len(prompt_list)
    return count

def function_call_fill(json_namn):
    multi_quiz_info_func = {"type": 'function',
                "function":read_json(json_namn)}
    functions = [multi_quiz_info_func]
    return functions

def function_call_choice_fill(name):
    multi_quiz_info_func = {"type": 'function',
                "function":{"name":name}}
    return multi_quiz_info_func


def message_builder(syst, user_assistlist, prompt):
    usaslist = [({"role": "assistant", "content": user_assistlist[i][1]},) for i in range(len(user_assistlist)) if i != len(user_assistlist)-1]
    usaslist += [({"role": "user", "content": user_assistlist[i][0]},{"role": "assistant", "content": user_assistlist[i][1]}) for i in range(len(user_assistlist)) if i == len(user_assistlist)-1]
    usaslist = [a for b in usaslist for a in b ]
    messages = [{"role": "system", "content": syst}] + usaslist + [{"role": "user", "content": prompt}]
    return messages