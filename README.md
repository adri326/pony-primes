# pony-primes

Prime functionalities library, it may become a proposal for the pony standard library once it becomes more feature-complete

## Installation & Usage

Grab the package from github:

```sh
git clone https://github.com/adri326/pony-primes.git primes
```

And import it in your pony code:

```pony
use "primes"

actor Main
  new create(env: Env) =>
    let n: USize = 65535
    let iterator = PrimeIterator.start_at(n)
    env.out.print("Hello there! 🐺")
    env.out.print("The next prime after " + n.string() + " is " + iterator.next().string())
```

A more thorough usage example can be found in the `test/` directory.
