"""
# pony-primes

Prime functionalities library, it may become a proposal for the pony standard library once it becomes more feature-complete
"""

primitive Prime
  fun is_prime[A: (Integer[A] val & Unsigned) = USize](num: A): Bool =>
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

  fun next_prime[A: (Integer[A] val & Unsigned) = USize](num: A): A =>
    PrimeIterator[A].start_at(num).next()

  fun prime_factors[A: (Integer[A] val & Unsigned) = USize](num: A): Array[A] ref =>
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
  var _last: A

  new create() =>
    _last = 1

  new start_at(last: A = 1) =>
    _last = if (last % 2) == 0 then last - 1 else last end

  fun has_next(): Bool => (_last + 1) < A.max_value()

  fun ref next(): A =>
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
