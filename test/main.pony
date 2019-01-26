use "../"

actor Main
  new create(env: Env) =>
    var n: USize = 1
    while n < 100 do
      if Prime.is_prime(n) then
        env.out.print(n.string())
      end
      n = n + 1
    end
    env.out.print("")
    for prime in PrimeIterator do
      if prime > 100 then break end
      env.out.print("> " + prime.string())
    end
    env.out.print("")
    let n': USize = 1256485
    let iterator = PrimeIterator.start_at(n')
    env.out.print("The next prime after " + n'.string() + " is " + iterator.next().string())
    env.out.print("Then comes " + iterator.next().string())
