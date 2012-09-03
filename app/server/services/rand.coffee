module.exports = ->
  gen = -> ((Math.random() * 16) | 0).toString 16

  # return random 16 digits
  "#{gen()+gen()+gen()+gen()+gen()+gen()+gen()+gen()+gen()+gen()+gen()+gen()+gen()+gen()+gen()+gen()}"
