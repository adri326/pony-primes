"""
# pony-primes

Prime functionalities library, it may become a proposal for the pony standard library once it becomes more feature-complete
"""

primitive Prime
  fun is_prime[A: (Integer[A] val & Unsigned) = USize](num: A): Bool =>
    if num == 2 then
      return true
    end
    if (num <= 1) or ((num % 2) == 0) then
      return false
    end
    var current: A = 3
    while (current * current) <= num do
      if (num % current) == 0 then
        return false
      end
      current = current + 2
    end
    true

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
