use "../"
use "ponytest"
use "collections"
use "random"
use "time"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  new make() =>
    None

  fun tag tests(test: PonyTest) =>
    test(_TestPrimeTest)
    test(_TestPrimeTestExtended)
    test(_TestNextPrime)
    test(_TestPrimeFactorsStatic)
    test(_TestPrimeFactorsRandom)
    test(_TestPrimeIterator)

class _TestPrimeTest is UnitTest
  // everyone should know them
  let primes_expected: Array[USize] val = [2; 3; 5; 7; 11; 13; 17; 19; 23; 29; 31; 37; 41; 43; 47]

  fun name(): String => "prime/test"
  fun apply(helper: TestHelper) =>
    var primes: Array[USize] trn = []
    for n in Range[USize](0, 50) do
      if Prime.is_prime(n) then primes.push(n) end
    end
    helper.assert_array_eq[USize](primes_expected, consume val primes, "Prime.is_prime error!")

class _TestPrimeTestExtended is UnitTest
  // you don't have to learn these :)
  let primes_expected: Array[USize] val = [10007; 10009; 10037; 10039; 10061; 10067; 10069; 10079; 10091; 10093; 10099; 10103; 10111; 10133; 10139; 10141; 10151; 10159; 10163; 10169; 10177; 10181; 10193; 10211; 10223; 10243; 10247; 10253; 10259; 10267; 10271; 10273; 10289; 10301; 10303; 10313; 10321; 10331; 10333; 10337; 10343; 10357; 10369; 10391; 10399; 10427; 10429; 10433; 10453; 10457; 10459; 10463; 10477; 10487; 10499; 10501; 10513; 10529; 10531; 10559; 10567; 10589; 10597; 10601; 10607; 10613; 10627; 10631; 10639; 10651; 10657; 10663; 10667; 10687; 10691; 10709; 10711; 10723; 10729; 10733; 10739; 10753; 10771; 10781; 10789; 10799; 10831; 10837; 10847; 10853; 10859; 10861; 10867; 10883; 10889; 10891; 10903; 10909; 10937; 10939; 10949; 10957; 10973; 10979; 10987; 10993]

  fun name(): String => "prime/test/advanced"
  fun apply(helper: TestHelper) =>
    var primes: Array[USize] trn = []
    for n in Range[USize](10000, 11000) do
      if Prime.is_prime(n) then primes.push(n) end
    end
    helper.assert_array_eq[USize](primes_expected, consume val primes, "Prime.is_prime error!")

class _TestNextPrime is UnitTest
  fun name(): String => "prime/nextprime"
  fun apply(helper: TestHelper) =>
    for n in Range[USize](1, 100) do
      let from = n*100
      let next_prime = Prime.next_prime(from)
      for n' in Range[USize](from + 1, next_prime) do
        helper.assert_false(Prime.is_prime(n'), "Prime.next_prime error! " + n'.string() + " - " + next_prime.string())
      end
    end

class _TestPrimeFactorsStatic is UnitTest
  fun name(): String => "prime/factors/static"
  fun apply(helper: TestHelper) =>
    helper.assert_array_eq[USize](Prime.prime_factors(1), [])
    helper.assert_array_eq[USize](Prime.prime_factors(2), [as USize: 2])
    helper.assert_array_eq[USize](Prime.prime_factors(3), [as USize: 3])
    helper.assert_array_eq[USize](Prime.prime_factors(4), [as USize: 2; 2])
    helper.assert_array_eq[USize](Prime.prime_factors(162316), [as USize: 2; 2; 7; 11; 17; 31])
    helper.assert_array_eq[USize](Prime.prime_factors(6469693230), [as USize: 2; 3; 5; 7; 11; 13; 17; 19; 23; 29])

class _TestPrimeFactorsRandom is UnitTest
  fun name(): String => "prime/factors/random"

  fun apply(helper: TestHelper) =>
    let now = Time.now()
    let dice = Dice(XorOshiro128Plus(now._1.u64(), now._2.u64()))
    for x in Range[USize](0, 8) do
      let to: USize = dice(1, 4).usize()
      let iterator = PrimeIterator
      var primes: Array[USize] trn = []
      var composite: USize = 1
      for y in Range[USize](0, to) do
        var value = iterator.next()
        for z in Range[USize](0, dice(1, 6).usize()) do
          value = iterator.next()
        end
        for z in Range[USize](0, dice(1, 2).usize()) do
          primes.push(value)
          composite = composite * value
        end
      end
      helper.assert_array_eq[USize](Prime.prime_factors(composite), consume primes)
    end

class _TestPrimeIterator is UnitTest
  let primes_expected: Array[USize] box = [10007; 10009; 10037; 10039; 10061; 10067; 10069; 10079; 10091; 10093; 10099; 10103; 10111; 10133; 10139; 10141; 10151; 10159; 10163; 10169; 10177; 10181; 10193; 10211; 10223; 10243; 10247; 10253; 10259; 10267; 10271; 10273; 10289; 10301; 10303; 10313; 10321; 10331; 10333; 10337; 10343; 10357; 10369; 10391; 10399; 10427; 10429; 10433; 10453; 10457; 10459; 10463; 10477; 10487; 10499; 10501; 10513; 10529; 10531; 10559; 10567; 10589; 10597; 10601; 10607; 10613; 10627; 10631; 10639; 10651; 10657; 10663; 10667; 10687; 10691; 10709; 10711; 10723; 10729; 10733; 10739; 10753; 10771; 10781; 10789; 10799; 10831; 10837; 10847; 10853; 10859; 10861; 10867; 10883; 10889; 10891; 10903; 10909; 10937; 10939; 10949; 10957; 10973; 10979; 10987; 10993]

  fun name(): String => "prime/iterator"

  fun apply(helper: TestHelper) =>
    let iterator = PrimeIterator
    helper.assert_eq[USize](2, iterator.next(), "PrimeIterator error!")
    helper.assert_eq[USize](3, iterator.next(), "PrimeIterator error!")
    helper.assert_eq[USize](5, iterator.next(), "PrimeIterator error!")

    let iterator' = PrimeIterator.start_at(10000)
    let primes: Array[USize] = []
    var value = iterator'.next()
    while value < 11000 do
      primes.push(value = iterator'.next())
    end
    helper.assert_array_eq[USize](primes_expected, primes, "PrimeIterator error!")
