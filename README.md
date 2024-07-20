# Linear Algebra Calculator for Matrix Properties

## Introduction

This a calculator for matrix properties in linear algebra. The purpose of this is to demonstrate how using an object oriented programming paradigm and giving an LLM access to the classes can be used as a way to perform calculations, like it would through an API. The advantages of this is that it can build onto the codebase and perhaps create more complex programs around the classes.

The important stuff is in the backend where sagemath code is executed, premade code and agents are.

The calculator can determine properties related to singular value decomposition and pseudoinverses on the one hand and diagonalization on the other hand.
### Examples: Singular Value Decomposition and Pseudoinverses

- **Singular Value Decomposition (SVD)**
- **Pseudoinverse**
- **Singular Values**
- **Singular Vectors**
- **Orthonormal Basis**
- **Sigma Matrix**
- **Y Matrix**
- **X Matrix**
- **Hermitian Conjugate**
- **AA<sup>†</sup>, A<sup>†</sup>A**

### Examples: Diagonalization

- **Characteristic Polynomial**
- **Eigenspaces**
- **Minimal Polynomial**
- **Eigenvalues**
- **Eigenvectors**
- **Geometric Multiplicity (Eigenvalues)**
- **Algebraic Multiplicity (Eigenvalues)**
- **Jordan Basis**
- **Jordan Form**
- **Jordan Transformation Matrix**
- **Diagonalizability**

The calculator should work if you don't give it a too crazy field or too large matrix. I have not yet seen any false positives for these examples, i.e. giving a wrong answer instead of failing. If you get it, contact me ASAP ;)- rasmus.bjersing@gmail.com . You could use it for other math questions, but it is not its intended use. Since I am using Sagemath and letting an agent iterate on responses it could be better than other math agents in some regards but the prompt engineering is steered towards operating as a calculator for the examples above and using the existing codebase rather than solving stuff on its own.

Latex compiling is in progress!

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
    python3 main.py
    ```


3. Open your browser and navigate to:
    [http://localhost:8080/frontend/templates/](http://localhost:8080/frontend/templates/)


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

3. **Jordan Normalform:**
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
Determine the Jordan normal.
    ```

4. **Singular Values:**
    ```plaintext
    Consider the complex matrix \(A=\left[\begin{array}{cc}1 & 1 \\ -i & i \\ i & i\end{array}\right]\).
Determine the singular values of \(A\).
    ```

Feel free to experiment with these example questions to explore the capabilities of the calculator.