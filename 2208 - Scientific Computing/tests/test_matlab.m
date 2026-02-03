% Unit tests for Complex Numbers Lab - MATLAB
% Run with: runtests('test_matlab.m') or execute this file

% Add directory to path to find student's solution
lab_dir = fileparts(mfilename('fullpath'));
parent_dir = fileparts(lab_dir);
solutions_dir = fullfile(parent_dir, 'solutions');

% Check for my_solution.m in parent directory (lab root)
if exist(fullfile(parent_dir, 'my_solution.m'), 'file')
    addpath(parent_dir);
    fprintf('Testing student solution: my_solution.m\n');
else
    % Fallback to solutions directory
    if exist(fullfile(solutions_dir, 'matlab_solution.m'), 'file')
        addpath(solutions_dir);
        fprintf('Notice: ''my_solution.m'' not found. Testing reference solution.\n');
        % Note: The reference solution might need to be renamed or its functions accessible
        % Typically in MATLAB, functions must be in separate files or a single file with main function
        % Here we assume the solution file adds functions to the path or scripts
    else
        fprintf('Error: Could not find my_solution.m or reference solution.\n');
    end
end

% Test suite
fprintf('============================================================\n');
fprintf('Complex Numbers Lab - MATLAB Unit Tests\n');
fprintf('============================================================\n');

test_count = 0;
pass_count = 0;

% ============================================================================
% Topic 1: Basic Operations
% ============================================================================

fprintf('\n--- Topic 1: Basic Operations ---\n');

% Test Exercise 1.2: Complex Arithmetic
fprintf('Testing Exercise 1.2: Complex Arithmetic...\n');
z1 = 3 + 4i;
z2 = 1 + 2i;

% Test addition
test_count = test_count + 1;
result = complex_add(z1, z2);
expected = z1 + z2;
if abs(result - expected) < 1e-10
    fprintf('  ✓ Addition test passed\n');
    pass_count = pass_count + 1;
else
    fprintf('  ✗ Addition test failed\n');
end

% Test subtraction
test_count = test_count + 1;
result = complex_subtract(z1, z2);
expected = z1 - z2;
if abs(result - expected) < 1e-10
    fprintf('  ✓ Subtraction test passed\n');
    pass_count = pass_count + 1;
else
    fprintf('  ✗ Subtraction test failed\n');
end

% Test multiplication
test_count = test_count + 1;
result = complex_multiply(z1, z2);
expected = z1 * z2;
if abs(result - expected) < 1e-10
    fprintf('  ✓ Multiplication test passed\n');
    pass_count = pass_count + 1;
else
    fprintf('  ✗ Multiplication test failed\n');
end

% Test Exercise 1.3: Conjugate and Modulus
fprintf('Testing Exercise 1.3: Conjugate and Modulus...\n');
z = 3 + 4i;

% Test conjugate
test_count = test_count + 1;
result = complex_conjugate(z);
expected = conj(z);
if abs(result - expected) < 1e-10
    fprintf('  ✓ Conjugate test passed\n');
    pass_count = pass_count + 1;
else
    fprintf('  ✗ Conjugate test failed\n');
end

% Test modulus
test_count = test_count + 1;
result = complex_modulus(z);
expected = abs(z);
if abs(result - expected) < 1e-10
    fprintf('  ✓ Modulus test passed\n');
    pass_count = pass_count + 1;
else
    fprintf('  ✗ Modulus test failed\n');
end

% Test relationship: z * z* = |z|^2
test_count = test_count + 1;
z_conj = complex_conjugate(z);
z_mod = complex_modulus(z);
if abs(real(z * z_conj) - z_mod^2) < 1e-10
    fprintf('  ✓ Conjugate-modulus relationship test passed\n');
    pass_count = pass_count + 1;
else
    fprintf('  ✗ Conjugate-modulus relationship test failed\n');
end

% ============================================================================
% Topic 2: Polar Coordinates
% ============================================================================

fprintf('\n--- Topic 2: Polar Coordinates ---\n');

% Test Exercise 2.1: Rectangular to Polar
fprintf('Testing Exercise 2.1: Rectangular to Polar...\n');
test_cases = [3 + 4i, 5.0, 0.927; -3 + 4i, 5.0, 2.214; -3 - 4i, 5.0, -2.214; 3 - 4i, 5.0, -0.927];

for i = 1:size(test_cases, 1)
    z = test_cases(i, 1);
    expected_r = test_cases(i, 2);
    expected_phi = test_cases(i, 3);
    
    test_count = test_count + 1;
    [r, phi] = rectangular_to_polar(z);
    if abs(r - expected_r) < 0.01 && abs(phi - expected_phi) < 0.01
        fprintf('  ✓ Test case %d passed\n', i);
        pass_count = pass_count + 1;
    else
        fprintf('  ✗ Test case %d failed\n', i);
    end
end

% Test Exercise 2.2: Polar to Rectangular
fprintf('Testing Exercise 2.2: Polar to Rectangular...\n');
test_cases_polar = [5.0, pi/4; 2.0, pi/3; 3.0, 2*pi/3];

for i = 1:size(test_cases_polar, 1)
    r = test_cases_polar(i, 1);
    phi = test_cases_polar(i, 2);
    
    test_count = test_count + 1;
    z = polar_to_rectangular(r, phi);
    if abs(abs(z) - r) < 1e-10
        fprintf('  ✓ Test case %d passed\n', i);
        pass_count = pass_count + 1;
    else
        fprintf('  ✗ Test case %d failed\n', i);
    end
end

% Test inverse operations
test_count = test_count + 1;
z_original = 3 + 4i;
[r, phi] = rectangular_to_polar(z_original);
z_reconstructed = polar_to_rectangular(r, phi);
if abs(z_original - z_reconstructed) < 1e-10
    fprintf('  ✓ Inverse operations test passed\n');
    pass_count = pass_count + 1;
else
    fprintf('  ✗ Inverse operations test failed\n');
end

% Test Exercise 2.3: Euler's Formula
fprintf('Testing Exercise 2.3: Euler''s Formula...\n');
phi = linspace(0, 2*pi, 100);
euler_form = cos(phi) + 1i * sin(phi);
exp_form = exp(1i * phi);
max_diff = max(abs(euler_form - exp_form));

test_count = test_count + 1;
if max_diff < 1e-10
    fprintf('  ✓ Euler''s formula test passed\n');
    pass_count = pass_count + 1;
else
    fprintf('  ✗ Euler''s formula test failed\n');
end

% Test Euler's identity
test_count = test_count + 1;
euler_identity = exp(1i * pi) + 1;
if abs(euler_identity) < 1e-10
    fprintf('  ✓ Euler''s identity test passed\n');
    pass_count = pass_count + 1;
else
    fprintf('  ✗ Euler''s identity test failed\n');
end

% ============================================================================
% Topic 3: Complex Operations
% ============================================================================

fprintf('\n--- Topic 3: Complex Operations ---\n');

% Test Exercise 3.1: Complex Division
fprintf('Testing Exercise 3.1: Complex Division...\n');
test_cases = [3 + 4i, 1 + 2i; 5 - 3i, 2 + 1i];

for i = 1:size(test_cases, 1)
    z1 = test_cases(i, 1);
    z2 = test_cases(i, 2);
    
    test_count = test_count + 1;
    result = complex_divide(z1, z2);
    expected = z1 / z2;
    if abs(result - expected) < 1e-10
        fprintf('  ✓ Test case %d passed\n', i);
        pass_count = pass_count + 1;
    else
        fprintf('  ✗ Test case %d failed\n', i);
    end
end

% Test Exercise 3.2: Powers using de Moivre
fprintf('Testing Exercise 3.2: Powers using de Moivre...\n');
test_cases = [1 + 1i, 4; 1 + sqrt(3)*1i, 3; 2 + 2i, 5];

for i = 1:size(test_cases, 1)
    z = test_cases(i, 1);
    n = test_cases(i, 2);
    
    test_count = test_count + 1;
    result = complex_power_de_moivre(z, n);
    expected = z^n;
    if abs(result - expected) < 1e-10
        fprintf('  ✓ Test case %d passed\n', i);
        pass_count = pass_count + 1;
    else
        fprintf('  ✗ Test case %d failed\n', i);
    end
end

% Test Exercise 3.3: Roots of Unity
fprintf('Testing Exercise 3.3: Roots of Unity...\n');
for n = [4, 6, 8]
    roots = roots_of_unity(n);
    
    test_count = test_count + 1;
    if length(roots) == n
        fprintf('  ✓ %d-th roots count test passed\n', n);
        pass_count = pass_count + 1;
    else
        fprintf('  ✗ %d-th roots count test failed\n', n);
    end
    
    % Verify each root raised to n-th power equals 1
    all_valid = true;
    for k = 1:n
        if abs(roots(k)^n - 1) >= 1e-10
            all_valid = false;
            break;
        end
    end
    
    test_count = test_count + 1;
    if all_valid
        fprintf('  ✓ %d-th roots validation test passed\n', n);
        pass_count = pass_count + 1;
    else
        fprintf('  ✗ %d-th roots validation test failed\n', n);
    end
    
    % Verify sum equals 0 (for n > 1)
    if n > 1
        test_count = test_count + 1;
        root_sum = sum(roots);
        if abs(root_sum) < 1e-10
            fprintf('  ✓ %d-th roots sum test passed\n', n);
            pass_count = pass_count + 1;
        else
            fprintf('  ✗ %d-th roots sum test failed\n', n);
        end
    end
end

% ============================================================================
% Topic 5: Applications
% ============================================================================

fprintf('\n--- Topic 5: Applications ---\n');

% Test Exercise 5.1: Sinusoid to Phasor
fprintf('Testing Exercise 5.1: Sinusoid to Phasor...\n');
test_cases = [5.0, pi/4; 3.0, pi/6; 4.0, -pi/3];

for i = 1:size(test_cases, 1)
    A = test_cases(i, 1);
    phi = test_cases(i, 2);
    
    test_count = test_count + 1;
    phasor = sinusoid_to_phasor(A, phi);
    if abs(abs(phasor) - A) < 1e-10
        fprintf('  ✓ Test case %d passed\n', i);
        pass_count = pass_count + 1;
    else
        fprintf('  ✗ Test case %d failed\n', i);
    end
end

% Test Exercise 5.2: Add Sinusoids using Phasors
fprintf('Testing Exercise 5.2: Add Sinusoids using Phasors...\n');
A1 = 3.0; phi1 = pi/6;  % 30 degrees
A2 = 4.0; phi2 = pi/3;  % 60 degrees
omega = 2*pi;
t = linspace(0, 2, 1000);

[sum_phasor, A3, phi3] = add_sinusoids_phasor(A1, phi1, A2, phi2, omega, t);

% Verify by direct addition
a_t = A1 * cos(omega * t + phi1);
b_t = A2 * cos(omega * t + phi2);
direct_sum = a_t + b_t;

test_count = test_count + 1;
max_diff = max(abs(sum_phasor - direct_sum));
if max_diff < 1e-10
    fprintf('  ✓ Phasor addition test passed\n');
    pass_count = pass_count + 1;
else
    fprintf('  ✗ Phasor addition test failed\n');
end

% ============================================================================
% Summary
% ============================================================================

fprintf('\n============================================================\n');
fprintf('Test Summary: %d/%d tests passed (%.1f%%)\n', ...
        pass_count, test_count, 100*pass_count/test_count);
fprintf('============================================================\n');

if pass_count == test_count
    fprintf('All tests passed! ✓\n');
else
    fprintf('Some tests failed. Please review your implementation.\n');
end
