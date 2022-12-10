import sys
import pytest


print(f"Running test on >>>>>>>>> {sys.argv[2]}")
pytest.main(['-v',sys.argv[1]])

