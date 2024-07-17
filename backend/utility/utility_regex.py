import re

import regex

def split_sections_updated(text):
    # Define a pattern for sections
    pattern = r"(\\section\{.*?\}(.*?))(?=\\section\{|$)"
    # Use regex to find all sections
    sections = re.findall(pattern, text, re.DOTALL)
    # Clean sections and remove leading/trailing whitespaces
    cleaned_sections = [section[0].strip() for section in sections]
    #print(text)
    return cleaned_sections

def get_uvis(text, typer = 0):
    sections = split_sections_updated(text)
    uppgift = sections[0]
    if typer == 0:
        verktyg = sections[1]
    else:
        verktyg = sections[1:-2]
    slutsats = sections[-2]
    infob = sections[-1]
    return uppgift, verktyg, slutsats, infob

def get_tool_info(s):
    initial_match = regex.search(r'\\section\{Verktyg (\d+):\s*', s)
    start_index = initial_match.end() if initial_match else None
    recursive_pattern = r'((?:[^{}]+|\{(?1)\})*)'
    if start_index is not None:
        tool_number = initial_match.group(1)
        remaining_string = s[start_index:]
        recursive_match = regex.match(recursive_pattern, remaining_string)
        tool_name = recursive_match.group() if recursive_match else "No match found"
    else:
        return "No match found for tool name.", "No match found for tool number."
    return tool_name, tool_number    


def split_subsections(text):
    pattern = r"(\\subsection\{.*?\}(.*?))(?=\\subsection\{|$)"
    sections = re.findall(pattern, text, re.DOTALL)
    cleaned_sections = [section[0].strip() for section in sections]
    return cleaned_sections

def split_subsubsections(text):
    pattern = r"(\\subsubsection\{.*?\}(.*?))(?=\\subsubsection\{|$)"
    sections = re.findall(pattern, text, re.DOTALL)
    cleaned_sections = [section[0].strip() for section in sections]
    return cleaned_sections

def extract_python_code(input_string, language = 'python'):
    """
    Extracts Python code enclosed in triple backticks from a given string.

    Parameters:
    input_string (str): The string containing the Python code.

    Returns:
    str: The extracted Python code, or a message indicating no code was found.
    """
    code_pattern = r"```" + language + r"\n(.*?)```"
    matches = re.findall(code_pattern, input_string, re.DOTALL)
    return matches if matches else []