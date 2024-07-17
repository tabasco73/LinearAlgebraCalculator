from abc import ABC, abstractmethod

from openai_request import query_openai_with_serialmess
from utility.utility_openai import message_builder
from utility.utility_files import read_prompt
from utility.utility_regex import extract_python_code
from sage_execution.sage_testpy import sagemath_interpreter


def systemprompt():
    return r'''You are a linear algebra request maker. You will receive questions on matrixes in linear algebra that you will answer in a 3 step process.
    1. First you will instantiate objects representing the matrixes in the question - Make sure to include important argument such as the actual matrix and the field over which it is defined in a correct Sagemath python syntax.
    2. Second you will use the appropriate method based on the question and store the results in a variable.
    3. Third you will print the results.
All of this 
```sagemath
<The code that performs the 3-step process>
```
Here are two classes with all the methods that are available.
Every method returns a variable representing the concept you want to retrieve and can be readily printed out using print(). Include all the given information that fits into a parameter for the matrix when instantiating the object, all given methods can always be used for correctly instantiated objects and require no input.
''' + r"""

class Matrix_Representation:
    # Parameters to the constructor for the class
    def __init__(self, matrix=None, field=None, dim_rows: Optional[int] = None, dim_cols: Optional[int] = None, singularvalues = None, AdaggerA = None, AAdagger = None, left_singular_vectors = None, right_singular_vectors = None, positive_matrix = None):

    # Returns the Hermitian conjugate of the matrix
    get_hermitian_conjugate(self)

    # Returns the calculated \( A^{\dagger}A \) (we call our matrix A)
    get_AdaggerA(self)
    
    # Returns the calculated \( A A^{\dagger}\)
    get_AAdagger(self)

    # Returns the pseudoinvers of the matrix
    calculate_pseudoinverse(self)

    # SINGULÄRVÄRDESUPPDELNING:
    # Returns an overview of the singular value decomposition (If what you're looking for in the svdis not is specifically )
    get_singular_value_decomposition(self)

    # Returns the singular values
    calculate_singular_values(self)

    # Returns the right orthonormal basis in the singular value decomposition 
    get_orthogonal_right_basis(self)
    
    # Returns the left orthonormal basis in the singular value decomposition 
    get_orthogonal_left_basis(self)
    
    # Returns all the singular_vectors
    calculate_all_singular_vectors(self)    

class QuadraticMatrix(Matrix_Representation):
    # Parameters to the constructor for the class
    def __init__(self, matrix=None, field=None, eigenvalues = None, characteristic_polynom: Optional[CharacteristicPolynomial] = None, minimal_polynom = None, is_diagonalisable = None, transformation_matrix_normalform = None, eigenvectors = None):

    # DIAGONALISATION:
    # Returns the characteristic polynomial
    characteristic_polynomial(self)

    # Returns the minimal polynomial
    minimal_polynomial(self)

    # Returns the tranformation matrix that can be used to obtain the Jordan normalform for the matrix
    get_transformation_matrix(self)

    # Returns the normalform (Diagonal matrix if diagonalisable)
    jordan_form(self)

    # Returns the eigenvalues
    eigenvalues_list(self)
    
    # Returns True/False if matrix is diagonalizable
    is_diagonalizable(self)
    
    # Returns the eigenvectors
    get_all_eigenvectors(self)
"""


class Matlab_Agent(ABC):
    def __init__(self):
        pass

    def build_syst(self):
        pass

    def build_prompt(self):
        pass

    def perform_action(self):
        pass

    def make_request(self, messages):
        return  query_openai_with_serialmess(messages, model_choice = 'gpt-4-turbo')

class Matlab_Agent_First(Matlab_Agent):
    def __init__(self, question):
        self.question = question

    def build_syst(self):
        return systemprompt()

    def build_prompt(self):
        return r"""
This is your question:
***
""" + self.question + '\n***'
    
    def perform_action(self, action):
        code = extract_python_code(action, 'sagemath')    
        code_str = ''
        for c in code:
            code_str += c +'\n'
        print(code_str)
        output, error_message = sagemath_interpreter(code_str)
        print(output)
        print(error_message)
        if error_message:
            output += error_message
        return output

    def first_act(self):
        syst = self.build_syst()
        prompt = self.build_prompt()
        messages = message_builder(syst, [], prompt)
        action = self.make_request(messages)
        output = self.perform_action(action)
        log_run = [{'run': 1, 'attempt': action, 'output': output, 'promptp': prompt}]
        return log_run


class Matlab_Agent_Re(Matlab_Agent):
    def __init__(self, question, previous_attempts_runs):
        self.question = question
        self.previous_attempts_runs = previous_attempts_runs

    def build_syst(self):
        return systemprompt() + r'''If you have received a printed answer you should format it in the following way:
```answer
<the answer>
``` where it should be clearly presented what has been answered. At this stage, you can remove unneccesary numerical precision to make the answer more presentable. Use Latex to display the mathematical notation clearly. You should either present the answer or if a problem has arised in the code you should rewrite the code to be run. You will never need to verify any information that is printed out, it is already verified.
You need to answer in the given format for the question to be considered answered. 
'''

    def build_prompt(self):
        return 'Fix the code if any error has occured. If you have already obtained the desired result, present it in the given format, i.e. ```answer\n<the answer>\n```' 

    def build_old_interactions(self):
        gamla_grejer = []
        for run in self.previous_attempts_runs:
            attempt = run['attempt']
            output = run['output']
            promptp = run['promptp']
            if output != '':
                assistm = attempt + '\nOutput från kod:\n' + output
            else:
                assistm = attempt
            gamla_grejer.append((promptp,assistm))
        return gamla_grejer, attempt

    def extract_action(self, res, last_attempt):
        if 'Error' not in last_attempt:
            code_extr = last_attempt + res
        else:
            code_extr = res
        code = extract_python_code(code_extr, 'sagemath')
        answer = extract_python_code(res, 'answer')
        return code, answer

    def perform_action(self, answer, code):
        if answer != []:
            print('answer: ')
            print(answer)
            answ = ''
            for a in answer:
                answ += a + '\n'
            return False, answ
        code_str = ''
        for c in code:
            code_str += c +'\n'
        output, error_message = sagemath_interpreter(code_str)
        if error_message != None:
            output += error_message
        return True, output

    def matlabaction_re(self, iter):
        gamla_grejer, last_attempt = self.build_old_interactions()
        syst = self.build_syst()
        prompt = self.build_prompt()
        messages = message_builder(syst, gamla_grejer, prompt)
        res = self.make_request(messages)
        code, answer = self.extract_action(res, last_attempt)
        verdict, response =  self.perform_action(answer, code)
        if verdict:
            return verdict, response
        else:
            self.previous_attempts_runs.append({'run': iter, 'attempt': res, 'output': response, 'promptp': prompt})
            return verdict, response
    
    def long_while_loop(self):
        maxIter = 2
        contin = True
        while contin and maxIter <= 9:
            contin, answ = self.matlabaction_re(maxIter)
            maxIter += 1
        return answ

def sagemath_act(question):
    magent = Matlab_Agent_First(question)
    log_run = magent.first_act()
    magent = Matlab_Agent_Re(question, log_run)
    answer = magent.long_while_loop()
    return answer




if __name__ == '__main__':
    question = read_prompt(f'Testdata/uppgift{2}.txt')
    answ = sagemath_act(question)
    print(f'{answ=}')

    # Send in terminal

    #question = input('Enter question: ')
    #answ = sagemath_act(question)
    #print(f'{answ=}')
    