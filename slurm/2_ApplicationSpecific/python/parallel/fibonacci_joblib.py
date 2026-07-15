import time
from joblib import Parallel, delayed
def fib(n: int) -> int:
    a, b = 0, 1
    count = 0
    while count < n:
        a, b = b, a + b
        count += 1
    return a

if __name__ == "__main__":

    my_values = list(range(5000, 10000))

    start = time.time()
    serial_test = list(map(fib, my_values))
    end = time.time()
    print("Serial execution time:", end-start)

    print("Parallel using joblib:")
    for n_jobs in [1,2,4,8,16,32]:
        start = time.time()
        results = Parallel(n_jobs=n_jobs)(delayed(fib)(n) for n in my_values)
        end = time.time()

        print(f"Joblib execution time with n_jobs = {n_jobs}: {end-start}")
