from math import isclose
from sage.all import *
import numpy as np
from typing import Optional

def almost_identical(val1, val2):
    M = FreeModule(SR, 3)
    exvec = M([1, 2, 3])
    if type(val1) == type(exvec) == type(val2):
        diff = val1 - val2
        norm_diff = diff.norm()
        return norm_diff < 10**(-10)
    return round(val1, 10) == round(val2, 10)

def vectors_almost_equal(v1, v2, tol=1e-10):
    # Konvertera SageMath-vektorer till numpy-arrayer av komplexa tal
    np_v1 = np.array([complex(element) for element in v1])
    np_v2 = np.array([complex(element) for element in v2])
    # Jämför vektorerna med en viss tolerans
    return np.allclose(np_v1, np_v2, atol=tol)

def are_close(num1, num2, tol=1e-10):
    return abs(num1 - num2) < tol

def are_matrices_almost_equal(M1, M2, tolerance=1e-10):
    # Kontrollera först om matriserna har samma storlek
    if M1.dimensions() != M2.dimensions():
        return False
    
    # Gå igenom varje element och jämför
    for i in range(M1.nrows()):
        for j in range(M1.ncols()):
            # Beräkna den numeriska skillnaden mellan motsvarande element
            diff = abs(M1[i,j] - M2[i,j]).n()
            # Om skillnaden är större än toleransen, är matriserna inte "nästan lika"
            if diff > tolerance:
                return False
    return True







class CustomSet:
    def __init__(self, set_ = None):
        self.set_ = set_

class CustomVectorSpace:
    def __init__(self, vector_space = None, set_ = None):
        self.vector_space = vector_space
        

class Subset(CustomSet):
    def __init__(self, set_ = None, part_of_set = None):
        self.set_ = set_
        self.part_of_set = part_of_set
#Tensorer
        
class Basis_to_VectorSpace(Subset):
    def __init__(self, basis_vectors = None, part_vector_space = None):
        self.basis_vectors = basis_vectors
        self.part_vector_space = part_vector_space
        #if part_vector_space == None:
            #for vect in basis_vectors:
                #print(vect.vec.base_ring())
            #part_vector_space = (basis_vectors[0].vec.base_ring()**len(basis_vectors)).span(basis_vectors)
        super().__init__(set_ = basis_vectors, part_of_set = part_vector_space)
        
    def __repr__(self):
        return f"Basisvectors: ({self.basis_vectors})"

class Orthogonal_Basis(Basis_to_VectorSpace):
    def __init__(self, basis_vectors = None, part_vector_space = None):
        super().__init__(basis_vectors = basis_vectors, part_vector_space = part_vector_space)
        
class Orthonormal_Basis(Orthogonal_Basis):
     def __init__(self, basis_vectors = None, part_vector_space = None):
        super().__init__(basis_vectors = basis_vectors, part_vector_space = part_vector_space)


class CustomTensor:
    def __init__(self, tensor=None):
        self.tensor = tensor


class CustomVector(CustomTensor):
    def __init__(self, vec=None, tensor = None):
        self.vec = vec
        
        #self.vec = vector(QQ, vec) if vec else vector(QQ, [])

    def __repr__(self):
        return f"Vector({self.vec})"

# Polynom
class Polynomial:
    def __init__(self, polynomial, field):
        self.polynomial = polynomial  # Lista av koefficienter
        self.field = field  # Det matematiska fältet för koefficienterna

    def __str__(self):
        return str(self.polynomial)


class Operator:
    def __init__(self, vector_space = None, operator_function = None):
        self.vector_space = vector_space
        self.operator_function = operator_function

    def get_matrix_representation(self):
        if self.vector_space != None and self.operator_function != None:
            basis = self.vector_space.basis()
            return Matrix([self.operator_function(b).list() for b in basis]).transpose()






















class Singular_Value_Decomposition:
    def __init__(self, matrixrepresentation = None, singular_values = None, left_singular_vectors = None, right_singular_vectors = None, Sigma = None, Y = None, X = None, left_basis = None, right_basis = None):
        self.matrixrepresentation = matrixrepresentation
        self.singular_values = singular_values
        self.left_singular_vectors = left_singular_vectors
        self.right_singular_vectors = right_singular_vectors
        self.Sigma = Sigma
        self.Y = Y
        self.X = X
        self.left_basis = left_basis
        self.right_basis = right_basis
        self.confirmed = None

    def get_singular_values(self):
        if self.matrixrepresentation is None:
            return "No matrix has been submitted."
        else:
            # Beräkna A^†A
            AdaggerA = self.matrixrepresentation.get_AdaggerA()
            # Använd QuadraticMatrix för att få egenvärdena
            eigenvaluesAda = AdaggerA.eigenvalues_list()
            # Beräkna singulärvärdena som kvadratroten ur de absoluta värdena av egenvärdena
            singular_values1 = [SingularValue(sqrt(abs(eigenvalue.value)), right_singular_vectors = eigenvalue.compute_eigenvectors(), multiplicitet=eigenvalue.algebraic_multiplicity) for eigenvalue in eigenvaluesAda]
            AAdagger = self.matrixrepresentation.get_AAdagger()
            eigenvaluesAAd = AAdagger.eigenvalues_list()
            singular_values2 = [SingularValue(sqrt(abs(eigenvalue.value)), left_singular_vectors = eigenvalue.compute_eigenvectors(), multiplicitet=eigenvalue.algebraic_multiplicity) for eigenvalue in eigenvaluesAAd]
            singular_values = []
            for sing_val1 in singular_values1:
                for sing_val2 in singular_values2:
                    if almost_identical(sing_val1.value, sing_val2.value):
                        singular_values.append(SingularValue(sing_val2.value, right_singular_vectors = [SingularVector(eigenvector = vect, side = 'Right') for vect in sing_val1.right_singular_vectors], left_singular_vectors = [SingularVector(eigenvector = vect, side = 'Left') for vect in sing_val2.left_singular_vectors], multiplicitet= sing_val2.multiplicitet))
            singular_values = sorted(singular_values, key=lambda obj: obj.value, reverse = True)
            self.singular_values = singular_values
            return self.singular_values

    def calculate_left_singular_vectors(self):
        if self.matrixrepresentation.matrix.nrows() < self.matrixrepresentation.matrix.ncols():
            self.get_singular_values()
            self.left_singular_vectors = []
            for svalue in self.singular_values:
                self.left_singular_vectors += svalue.left_singular_vectors
        else:
            self.calculate_right_singular_vectors()
            AdaggerA = self.matrixrepresentation.get_AdaggerA()
            self.left_singular_vectors = []
            for svalue in self.singular_values:
                for i, xvector in enumerate(svalue.right_singular_vectors):
                    xvec = vector(xvector.vec.list() + [0 for i in range(AdaggerA.matrix.nrows()-len(xvector.vec))])
                    if svalue.value == 0:
                        yvec = svalue.left_singular_vectors[i].vec
                    else:
                        yvec = (1/svalue.value) * self.matrixrepresentation.matrix * xvec
                    self.left_singular_vectors.append(SingularVector(vec = yvec, side = 'Left'))
        return self.left_singular_vectors

    def calculate_right_singular_vectors(self):
        if self.matrixrepresentation.matrix.nrows() >= self.matrixrepresentation.matrix.ncols():
            self.get_singular_values()
            self.right_singular_vectors = []
            for svalue in self.singular_values:
                self.right_singular_vectors += svalue.right_singular_vectors
            #print(f'1:{len(self.right_singular_vectors)=}')
        else:
            self.calculate_left_singular_vectors()
            AAdagger = self.matrixrepresentation.get_AAdagger()
            self.right_singular_vectors = []
            for svalue in self.singular_values:
                for i, yvector in enumerate(svalue.left_singular_vectors):
                    yvec = vector(yvector.vec.list() + [0 for i in range(AAdagger.matrix.nrows()-len(yvector.vec))])
                    if svalue.value == 0:
                        xvec = svalue.right_singular_vectors[i].vec
                    else:
                        xvec = 1/svalue.value * self.matrixrepresentation.get_hermitian_conjugate().matrix * yvec
                    self.right_singular_vectors.append(SingularVector(vec = xvec, side = 'Right'))
            #print(f'2:{len(self.right_singular_vectors)=}')
        
        return self.right_singular_vectors
    
    def get_orthogonal_left_basis(self):
        self.calculate_left_singular_vectors()
        self.left_basis = Orthonormal_Basis(self.left_singular_vectors)
        return self.left_basis
    
    def get_orthogonal_right_basis(self):
        self.calculate_right_singular_vectors()
        self.right_basis = Orthonormal_Basis(self.right_singular_vectors)
        return self.right_basis
    
    def calculate_all_singular_vectors(self):
        self.calculate_left_singular_vectors()
        self.calculate_right_singular_vectors()       
        return self.left_singular_vectors, self.right_singular_vectors
    



    def get_sigma(self):
        self.get_singular_values()
        #Sigma = Matrix(self.matrixrepresentation.matrix.nrows(), self.matrixrepresentation.matrix.ncols(),0)
        Sigma = Matrix(self.matrixrepresentation.field, self.matrixrepresentation.matrix.ncols(), self.matrixrepresentation.matrix.nrows(), 0)

        """
        Skapar en Sigma-matris för SVD baserat på en lista av singulärvärden och deras multiplicitet.
    
        Args:
        singular_values_with_multiplicity (list of tuples): En lista där varje element är en tuple med ett singulärvärde
                                                         och dess multiplicitet.
        m (int): Antalet rader i den ursprungliga matrisen.
        n (int): Antalet kolumner i den ursprungliga matrisen.
        Returns:
        Matrix: Sigma-matrisen som används i SVD.
        """    
    # Fyll diagonalen i Sigma med singulärvärdena enligt deras multiplicitet.
        current_index = 0
        for sing_val in self.singular_values:
            for _ in range(sing_val.multiplicitet):
                if current_index < min(self.matrixrepresentation.dim_rows, self.matrixrepresentation.dim_cols):
                    Sigma[current_index, current_index] = sing_val.value
                    current_index += 1
                else:
                    break
        self.Sigma = Sigma
        return self.Sigma
    
    # Hjälpfunktion
    def get_Y1(self):
        self.calculate_left_singular_vectors()
        column_vectors = [vecto.vec for vecto in self.left_singular_vectors]
        Y = Matrix(column_vectors).transpose()
        self.Y = Y
        return self.Y
    
    # Hjälpfunktion
    def get_X1(self):
        self.calculate_right_singular_vectors()
        column_vectors = [vecto.vec for vecto in self.right_singular_vectors]
        X = Matrix(column_vectors).transpose()
        self.X = X
        return self.X
    
    
    def test_decomposition(self):
        X = self.get_X1()
        Y = self.get_Y1()

        sigma = self.get_sigma()
        #print(f'{Y.dimensions()=}')
        #print(f'{sigma.dimensions()=}')
        #print(f'{X.conjugate().dimensions()=}')
        #print(f'{Y=}')
        #print(f'{sigma=}')
        #print(f'{X=}')
        #print(f'{X.conjugate_transpose()=}')
        n_x = X.ncols()
        n_y = Y.ncols()
        potentials = []
        for permx in Permutations(n_x):
            adjusted_permx = [x-1 for x in permx]
            X_perm = X.matrix_from_columns(adjusted_permx)
            X_perm_hermit = X_perm.conjugate_transpose()
            for permy in Permutations(n_y):
                adjusted_permy = [y-1 for y in permy]
                Y_perm = Y.matrix_from_columns(adjusted_permy)
                i = 0
                while Y_perm.ncols() != sigma.nrows():
                    i+= 1
                    if i == 4:
                        break
                    zero_column = Matrix(Y_perm.nrows(), 1, 0)
                    Y_perm = Y_perm.augment(zero_column)

                while X_perm_hermit.nrows() != sigma.ncols():
                    i+= 1
                    if i == 4:
                        break
                    zero_column = Matrix(1, X_perm_hermit.ncols(), 0)
                    X_perm_hermit = X_perm_hermit.stack(zero_column)

                A = Y_perm * (sigma * X_perm_hermit)
                A.simplify()
                potentials.append(A)
                if are_matrices_almost_equal(self.matrixrepresentation.matrix, A):
                    self.X = X_perm
                    self.Y = Y_perm
                    self.confirmed = True
                    return True
        self.confirmed = False

    def get_X(self):
        self.test_decomposition()
        return self.X

    def get_Y(self):
        self.test_decomposition()
        return self.Y


    def __repr__(self):
        self.test_decomposition()
        self.get_orthogonal_right_basis()
        self.get_orthogonal_left_basis()
        return f"Singular Value Decomposition:\n{self.matrixrepresentation}\n\n{self.singular_values}\n\n{self.left_singular_vectors}\n\n{self.right_singular_vectors}\n\nSigma-matrisen:\n{self.Sigma}\n\nY-matrisen:\n{self.Y}\n\nX-matrisen:\n{self.X}\n\n{self.left_basis}\n\n{self.right_basis}\n\nConfirmed: {self.confirmed}" 

class SingularVector(CustomVector):
    def __init__(self,vec=None, eigenvector = None, side = None):
        super().__init__(vec = vec)
        if eigenvector != None:
            super().__init__(vec = eigenvector.vec)
        self.side = side

    def __repr__(self):
        if self.side == None:
            return f"Singular Vector: ({self.vec})"
        else:
            return f"{self.side} Singular Vector: ({self.vec})"

class SingularValue:
    def __init__(self, value = None, right_singular_vectors = None, left_singular_vectors = None, multiplicitet = None):
        self.value = value
        self.right_singular_vectors = right_singular_vectors
        self.left_singular_vectors = left_singular_vectors
        self.multiplicitet = multiplicitet

    def __repr__(self):
        return f"Singular Value: {self.value}"

    def get_value(self):
        return self.value




class CharacteristicPolynomial(Polynomial):
    def __init__(self, polynomial, field):
        super().__init__(polynomial, field)
        # Här kan du lägga till specifik funktionalitet för karaktäristiska polynom om så önskas

class MinimalPolynomial(Polynomial):
    def __init__(self, polynomial, field):
        super().__init__(polynomial, field)


class EigenSpace(CustomVectorSpace):
    def __init__(self, vector_space = None):
        super().__init__(vector_space)

class Eigenvector(CustomVector):
    def __init__(self, vec=None):
        super().__init__(vec)  # Anropar CustomVector konstruktor med elements

class GeometricMultiplicy:
    def __init__(self):
        self.multiplicity = None

    def add_multiplicity(self, multiplicity):
        self.multiplicity = multiplicity
    

class EigenValue:
    def __init__(self, value  = None, algebraic_multiplicity  = None, matrix  = None, field  = None, eigenvectors = None, eigenspace = None, geometric_multiplicity = None):
        self.matrix = matrix
        self.value = value
        self.algebraic_multiplicity = algebraic_multiplicity
        self.field = field
        self.eigenvectors = eigenvectors
        self.eigenspace = eigenspace
        self.geometric_multiplicity = geometric_multiplicity

    def compute_eigenvectors(self):
        eigenvectors = []
        for val, vecs, _ in self.matrix.eigenvectors_right():
            if val == self.value:
                for vec in vecs:
                    if self.field is not None and self.field not in [FiniteField(2),QQ]:
                        eigenvectors.append(Eigenvector(vec /vec.norm()))
                    else:
                        eigenvectors.append(Eigenvector(vec ))
        self.eigenvectors = eigenvectors
        return self.eigenvectors

    def build_eigenspace_from_eigenvectors(self):
        eigenvectors = self.compute_eigenvectors()
    # Anta att 'eigenvectors' nu är en lista av 'Eigenvector' objekt
        V = VectorSpace(self.matrix.base_ring(), self.matrix.nrows())
        eigenvector_elements = [vect.vec.list() for vect in eigenvectors]# Konvertera tillbaka till listform för 'span'
        self.eigenspace = EigenSpace(vector_space = V.span(eigenvector_elements))
        return self.eigenspace
    

    def get_geometric_multiplicity(self):
        eigenspace = self.build_eigenspace_from_eigenvectors()
        if self.algebraic_multiplicity == 1:
            self.geometric_multiplicity = 1
            
        else:
            self.geometric_multiplicity = eigenspace.vector_space.dimension()
        return self.geometric_multiplicity

    def __repr__(self):
        self.compute_eigenvectors()
        return (f"Egenvärde: {self.value}, "
                f"Algebraisk multiplicitet: {self.algebraic_multiplicity}, "
                f"Geometrisk multiplicitet: {self.geometric_multiplicity}, "
                f"Egenvektorer: {', '.join(map(str, self.eigenvectors))}")

                



class Matrix_Representation:
    def __init__(self, matrix=None, field=None, dim_rows: Optional[int] = None, dim_cols: Optional[int] = None, singularvalues = None, AdaggerA = None, AAdagger = None, left_singular_vectors = None, right_singular_vectors = None, positive_matrix = None):
        self.field = field
        self.dim_rows = dim_rows
        self.dim_cols = dim_cols
        self.singularvalues = singularvalues
        self.matrix = matrix
        if type(self.matrix) == list:
            if self.field == None:
                self.field = SR
            self.matrix = Matrix(self.field, self.matrix)
        elif self.field == None:
            self.field = self.matrix.base_ring()
        elif self.field == CC:
            self.field = SR
            self.matrix = self.matrix.change_ring(SR)
        elif self.field == None and self.matrix == None:
            self.field = SR
        elif self.matrix is not None and self.field is not None:
            self.matrix = Matrix(field, matrix)
        else:
            self.matrix = None
        if self.matrix != None:
            self.dim_rows = self.matrix.nrows()
            self.dim_cols = self.matrix.ncols()
        self.AdaggerA = AdaggerA
        self.AAdagger = AAdagger
        self.left_singular_vectors = left_singular_vectors
        self.right_singular_vectors = right_singular_vectors
        self.positive_matrix = positive_matrix

    def get_hermitian_conjugate(self):
        return Matrix_Representation(matrix = self.matrix.conjugate_transpose(), field = self.field)
    
    def get_AdaggerA(self):
        AdaggerA = self.matrix.conjugate_transpose() * self.matrix
        self.AdaggerA = QuadraticMatrix(matrix=AdaggerA, field=self.field)
        return self.AdaggerA
    
    def get_AAdagger(self):
        AAdagger =  self.matrix * self.matrix.conjugate_transpose()
        self.AAdagger = QuadraticMatrix(matrix=AAdagger, field=self.field)
        return self.AAdagger
    # SINGULÄRVÄRDESUPPDELNING

    def get_singular_value_decomposition(self):
        self.svd = Singular_Value_Decomposition(matrixrepresentation = self)
        return self.svd

    def calculate_singular_values(self):
        decomposition = self.get_singular_value_decomposition()
        self.singularvalues = decomposition.get_singular_values()
        return self.singularvalues
    
    #ignore
    def test_decomposition(self):
        self.get_singular_value_decomposition()
        return self.svd.test_decomposition()

    def get_orthogonal_right_basis(self):
        self.get_singular_value_decomposition()
        self.right_orthonormal_singular_vector_basis =  self.svd.get_orthogonal_right_basis()
        return self.right_orthonormal_singular_vector_basis
    
    def get_orthogonal_left_basis(self):
        self.get_singular_value_decomposition()
        self.left_orthonormal_singular_vector_basis =  self.svd.get_orthogonal_left_basis()
        return self.left_orthonormal_singular_vector_basis
    
    def calculate_all_singular_vectors(self):
        decomposition = self.get_singular_value_decomposition()
        self.left_singular_vectors, self.right_singular_vectors  = decomposition.calculate_all_singular_vectors()
        return self.left_singular_vectors, self.right_singular_vectors
        
    def is_positive(self):
        if self.matrix is not None:
            self.positive_matrix = all(self.matrix[i][j] > 0 for i in range(self.matrix.nrows()) for j in range(self.matrix.ncols()))
            return self.positive_matrix
        
    def calculate_pseudoinverse(self):
        if self.matrix is None:
            return "Ingen matris har angivits."
        else:
            A_pseudoinverse_matrix = self.matrix.pseudoinverse()
            return Matrix_Representation(matrix=A_pseudoinverse_matrix, field=self.field)

    def __str__(self):
        if self.matrix is None:
            return "Ingen specifik matris definierad"
        else:
            return f"Matris i fältet {self.field}\n{self.matrix}"


class QuadraticMatrix(Matrix_Representation):
    def __init__(self, matrix=None, field=None, eigenvalues = None, characteristic_polynom: Optional[CharacteristicPolynomial] = None, minimal_polynom = None, is_diagonalisable = None, transformation_matrix_normalform = None, eigenvectors = None):
        super().__init__(matrix, field)
        self.eigenvalues = eigenvalues
        self.characteristic_polynom = characteristic_polynom
        self.minimal_polynom = minimal_polynom
        self.is_diagonalisable = is_diagonalisable
        self.transformation_matrix_normalform = transformation_matrix_normalform
        self.eigenvectors = eigenvectors

    def characteristic_polynomial(self):
        kar_poly = self.matrix.characteristic_polynomial()
        # Undvik faktorisering om kroppen är Symbolic Ring
        if self.field == SR:
            self.characteristic_polynom = CharacteristicPolynomial(kar_poly, self.field)
            return self.characteristic_polynom
        else:
            self.characteristic_polynom = CharacteristicPolynomial(kar_poly.change_ring(self.field).factor(), self.field)
            return self.characteristic_polynom

    def minimal_polynomial(self):
        min_poly = self.matrix.minimal_polynomial().factor()
        self.minimal_polynom = MinimalPolynomial(min_poly, self.field)
        return self.minimal_polynom

    def get_transformation_matrix(self):
        if self.matrix!=None and  self.field!=None:
            J, P = self.matrix.jordan_form(transformation=True)
            self.transformation_matrix_normalform = JordanBasisMatrix(P, self.field)
            self.jordanmatrix = JordanForm(J, self.field)
            return self.transformation_matrix_normalform

    def jordan_form(self):
        self.jordanmatrix = JordanForm(self.matrix.jordan_form(),self.field)
        return self.jordanmatrix

    def eigenvalues_list(self):
        if isinstance(self.field, sage.rings.number_field.number_field.NumberField_generic):
            char_poly = self.matrix.characteristic_polynomial()
            eigen_values_utkast = char_poly.roots()
        else:
            eigen_values_utkast = self.matrix.eigenvalues()
        eigenvalues = []
        for eig_utkast in list(set(eigen_values_utkast)):
            if eig_utkast in self.field:
                alg_multiplicity = eigen_values_utkast.count(eig_utkast)
                eigen_value = EigenValue(eig_utkast, alg_multiplicity, self.matrix, self.field)
                eigenvalues.append(eigen_value)   
        self.eigenvalues = sorted(eigenvalues, key=lambda obj: obj.value, reverse=True)
        return self.eigenvalues
    
    def is_diagonalizable(self):
        sum_algebraig_multiplicity = 0
        eigenvalues_info = self.eigenvalues_list()
        for eigenvalue_info in eigenvalues_info:
            if eigenvalue_info.algebraic_multiplicity != eigenvalue_info.geometric_multiplicity:
                self.is_diagonalisable = False
                return self.is_diagonalisable
            sum_algebraig_multiplicity += eigenvalue_info.algebraic_multiplicity
        if sum_algebraig_multiplicity == self.matrix.nrows():
            self.is_diagonalisable = True
            return self.is_diagonalisable
        else:
            self.is_diagonalisable = False
            return self.is_diagonalisable
        
    def get_all_eigenvectors(self):
        all_eigenvectors = []
        eigenvalues_info = self.eigenvalues_list()
        for eigenvalue_ in eigenvalues_info:
            all_eigenvectors += eigenvalue_.compute_eigenvectors()

        self.eigenvectors = all_eigenvectors
        return self.eigenvectors

class JordanBasisMatrix(QuadraticMatrix):
    def __init__(self, matrix = None, field = None):
        super().__init__(matrix, field)

class JordanForm(QuadraticMatrix):
    def __init__(self, matrix = None, field = None):
        super().__init__(matrix, field)

# Step 1: Instantiate the matrix object
matrix_L = QuadraticMatrix(matrix=[[1, 2], [0, 1]], field=CC)

# Step 2: Compute the Jordan normal form of the matrix
jordan_form_L = matrix_L.jordan_form()

# Step 3: Print the result
print(jordan_form_L)

