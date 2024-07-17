# Linear Algebra Calculator for Matrix Properties

## Installation Guide

### Step 1: Download SageMath

Ensure you have SageMath installed. You can download it from the following link:
[SageMath Download for Windows](https://www.sagemath.org/download-windows.html)

*Note: This guide assumes you are using SageMath version 10.3.*

### Step 2: Install Necessary Node Packages

You need to install the following Node.js packages:
```sh
npm install openai
npm install axios
npm install cors
```

### Step 3: Set Up Python Virtual Environment

1. Create a virtual environment:
    ```sh
    python3 -m venv venv
    ```

2. Activate the virtual environment:
    ```sh
    source venv/bin/activate
    ```

3. Install the required Python dependencies:
    ```sh
    pip3 install -r requirements.txt -U
    ```


### Step 4: Verifying the Code

To ensure the backend is working correctly, executing the following steps and getting a response can be helpful:

Run the SageMath agent script:
    ```sh
    python3 backend/sagemath_agents.py
    ```


### Step 5: Running the Code

1. Start the backend server:
    ```sh
    python3 backend/server.py
    ```

2. In a new terminal, start the HTTP server:
    ```sh
    python -m http.server 8080
    ```

3. Open your browser and navigate to:
    [http://localhost:8080/templates/](http://localhost:8080/templates/)


## Example Questions

Here are some example questions you can ask the calculator:

1. **Matrix Diagonalization:**
    ```plaintext
    Let \( A \) be the following matrix:
    \[
    A = \begin{pmatrix}
    1 & -1 & 1 & 0 \\
    -1 & 0 & -1 & 0 \\
    0 & 1 & 0 & 0 \\
    1 & 1 & 1 & 1
    \end{pmatrix}
    \]
    Is the matrix diagonalisable?
    ```

2. **Characteristic Polynomial and Jordan Normal Form:**
    ```plaintext
    Let \( A \) be the following matrix with elements in the field \( \mathbb{F}_{2} = \mathbb{Z} / 2 \mathbb{Z} = \{0,1\} \):
    \[
    A = \begin{pmatrix}
    0 & 1 & 1 & 1 \\
    0 & 1 & 0 & 1 \\
    0 & 1 & 1 & 1 \\
    0 & 1 & 0 & 1
    \end{pmatrix}
    \]
    Determine the characteristic polynomial \( p_{A}(x) \), the minimal polynomial \( q_{A}(x) \), and the Jordan normal form of \( A \).
    ```

3. **Jordan Normal Form for a Linear Operator:**
    ```plaintext
    Let $A$ be the following real matrix.
$$
A=\left[\begin{array}{cccc}
1 & -1 & 1 & 0 \\
-1 & 0 & -1 & 0 \\
0 & 1 & 0 & 0 \\
1 & 1 & 1 & 1
\end{array}\right]
$$
Determine the characteristic polynomial $p_{A}(t)$ and the minimal polynomial $q_{A}(t)$.
    ```

Feel free to experiment with these example questions to explore the capabilities of the calculator.