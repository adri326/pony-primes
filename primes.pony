"""
# pony-primes

Prime functionalities library, it may become a proposal for the pony standard library once it becomes more feature-complete
"""

primitive Prime
  """
  Primitive for regular prime operations: primality test, coprimality test, GCD and LCM, next prime and prime factorization
  """

  fun is_prime[A: (Integer[A] val & Unsigned) = USize](num: A): Bool =>
    """
    Basic primality test, returns true if the given number is indeed prime.

    **Usage:**
    ```pony
      if Prime.is_prime[U128](232862364312348451) then
        env.out.print("We got ourselves quite a big prime!")
      else
        env.out.print("Not a prime number :C")
      end
    ```
    """
    if (num == 2) or (num == 3) then
      return true
    end
    if (num <= 1) or ((num % 2) == 0) or ((num % 3) == 0) then
      return false
    end
    var current: A = 6
    while ((current - 1) * (current - 1)) <= num do
      if ((num % (current - 1)) == 0) or ((num % (current + 1)) == 0) then
        return false
      end
      current = current + 6
    end
    true

  fun is_coprime[A: (Integer[A] val & Unsigned) = USize](a: A, b: A): Bool =>
    """
    Coprimality test: returns true if the only common divisor between `a` and `b` is `1`

    **Usage:**
    ```pony
      env.out.print(Prime.is_coprime(32, 33).string()) // should be 'true'
    ```
    """
    gcd[A](a, b) == 1

  fun gcd[A: (Integer[A] val & Unsigned) = USize](a: A, b: A): A =>
    """
    Returns the greatest common divisor between `a` and `b`, that is, the product of all the shared prime factors of `a` and `b`.
    For example, `gcd(3, 4)` would be `1`, as they do not share any prime factor, while `gcd(12, 15)` would be `3`, as both are multiples of `3`.

    **Usage:**
    ```pony
      env.out.print(Prime.gcd(24, 78).string()) // should be 6
    ```
    """
    var big: A = a.max(b)
    var small: A = a.min(b)
    var temp: A = small
    while small != 0 do
      temp = small
      small = big % small
      big = temp // ol' small
    end
    temp

  fun lcm[A: (Integer[A] val & Unsigned) = USize](a: A, b: A): A =>
    """
    Returns the least common multiplier; this is the operation one would use when doing an addition of two fractions.
    This function returns the smallest number which is a multiplier of both `a` and `b`.

    For instance, `lcm(3, 4)` would be `12`, while `lcm(6, 8)` would be `24`, as `6*4 = 24` and `8*3 = 24`.

    **Usage:**
    ```pony
      env.out.print(Prime.lcm(24, 78).string()) // 312
    ```
    """
    (a * b) / gcd[A](a, b) // too lazy to implement an *actual* thing for this, shhht!

  fun next_prime[A: (Integer[A] val & Unsigned) = USize](num: A): A =>
    """
    Returns the prime which follows `num`.
    """
    PrimeIterator[A].start_at(num).next()

  fun prime_factors[A: (Integer[A] val & Unsigned) = USize](num: A): Array[A] ref =>
    """
    Returns an array of prime numbers representing all the prime factors of `num`.
    Prime factorization consists of splitting up a number into a series of prime numbers which all multiplied together give you that number.
    There only exists one prime factorization for every number (this is a property of the prime numbers).

    **Note:** `24 = 2^3 * 3` - in the case of a prime number occuring several times, they will simply be listed this amount of times in the result array: `[2; 2; 2; 3]`.
    """
    if Prime.is_prime[A](num) then return [num] end
    var num' = num
    let iterator = PrimeIterator[A]
    var res = Array[A]
    for divisor in iterator do
      while (num' % divisor) == 0 do
        num' = num' / divisor
        res.push(divisor)
      end
      if (num' == 0) or (divisor > num') then break end
    end
    res

class PrimeIterator[A: (Integer[A] val & Unsigned) = USize] is Iterator[A]
  """
  The prime iterator class; it will return every primes up to a number (by default the maximum value of the type).
  Note that it will return the prime following the limit value.

  **Usage:**
  ```pony
    let iterator = PrimeIterator[U32](100)
    for prime in iterator do
      env.out.print(prime.string())
    end
    // will print: 2, 3, 5, 7, ..., 101
  ```
  """

  var _last: A
  let _limit: A

  new create(limit: A = A.max_value()) =>
    _last = 1
    _limit = limit

  new start_at(last: A = 1, limit: A = A.max_value()) =>
    """
    Begin at a particular value, allowing for calculation of primes up from a number

    ```pony
      let iterator = PrimeIterator.start_at(10000)
      env.out.print(iterator.next().string()) // 10007
    ```
    """
    _last = if (last % 2) == 0 then last - 1 else last end
    _limit = limit

  fun has_next(): Bool => _last < _limit

  fun ref next(): A =>
    """
    Returns your crunchy prime!
    """
    if _last <= 1 then
      _last = 2
      return 2
    elseif _last == 2 then
      _last = 3
      return 3
    end
    _last = _last + 2
    while not Prime.is_prime[A](_last) do
      _last = _last + 2
    end
    _last
