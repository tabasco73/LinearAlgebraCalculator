import subprocess

from utility.utility_files import read_prompt


input = """
a = var('a')
print(integral(sin(a), a))
# Felaktig SageMath-kod
#print(1/0)  # Dela med noll för att generera ett fel
"""

def sagemath_interpreter(input):
    root = read_prompt('backend/sage_execution/helpscript.txt')
    sage_code = root + input
    with open("backend/sage_execution/temp_sage_script.sage", "w") as file:
        file.write(sage_code)
    result = subprocess.run(["sage", "backend/sage_execution/temp_sage_script.sage"], capture_output=True, text=True)
    output = result.stdout
    errors = result.stderr
    return output, errors

if __name__ == '__main__':
    input = r"""A = Matrix(QQ, [[1, -2], [3, 5]])

# Definiera kroppen K
K = QuadraticField(2, 'b')

# Skapa en instans av MatrixOperations med matrisen A och kroppen K
matrix_operations = QuadraticMatrix(A, K)

# Kontrollera om matrisen A är diagonaliserbar över kroppen K
is_diagonalizable = matrix_operations.is_diagonalizable()

print(f"Matrisen A är {'diagonaliserbar' if is_diagonalizable else 'inte diagonaliserbar'} över kroppen K.")"""
    output, errors = sagemath_interpreter(input)
    print("Output from SageMath script:")
    print(output)
    if errors:
        print("Errors from SageMath script:")
        print(errors)