"""
Pytest configuration for 2-Transforms lab tests.
Provides pytest_report_header so the implementation summary is always visible (even without -s).
"""

import os
import sys
import importlib.util

parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
if parent_dir not in sys.path:
    sys.path.insert(0, parent_dir)

my_solution_path = os.path.join(parent_dir, 'my_solution.py')
ref_solution_path = os.path.join(parent_dir, 'solutions', 'python_solution.py')

REQUIRED_NAMES = [
    'inner_product', 'fourier_basis', 'fourier_coefficient',
    'dft_manual', 'idft_manual', 'dft_matrix', 'fftshift_manual'
]


def _load_module(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        return None
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def _get_sol():
    """Load solution module (my_solution or reference) for header summary."""
    if os.path.isfile(my_solution_path):
        return _load_module(my_solution_path, 'lab_solution')
    if os.path.isfile(ref_solution_path):
        return _load_module(ref_solution_path, 'ref_solution')
    return None


def pytest_report_header(config):
    """Always show implementation summary in the pytest header (visible without -s)."""
    sol = _get_sol()
    if sol is None:
        return "Solution module not found (create my_solution.py or check paths)."
    implemented = [n for n in REQUIRED_NAMES if getattr(sol, n, None) is not None]
    not_impl = [n for n in REQUIRED_NAMES if getattr(sol, n, None) is None]
    line1 = f"Implemented: {', '.join(implemented) if implemented else '(none)'}"
    line2 = f"Not implemented: {', '.join(not_impl)}" if not_impl else ""
    return line1 + ("\n" + line2 if line2 else "")
