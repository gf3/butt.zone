This is a proof-of-concept for executable child instances in Javascript. This'll
only work in VMs that support the non-standard `__proto__` (so not IE). I've
tested it in [node](http://nodejs.org/).

### Implementation

``` javascript
/* ------------------------------ Main Class ------------------------------ */
// Returns "instances" of itself which are actually functions.
function User(username) {
  var Parent, scope

  function Scope() {
    // Here is where you put your normal constructor junk
    this.username = username
    this.colours = ['yellow', 0xFF]
  }

  // Magic
  function Proxy() {
    Scope.prototype.init.apply(scope, arguments)
  }
  Parent = arguments.callee
  function Dummy() {}
  Dummy.prototype = Parent.prototype
  Scope.prototype = new Dummy()
  scope = new Scope()
  Proxy.__proto__ = scope
  
  // Go time!
  return Proxy
}

User.prototype.init = function(username) {
  this.username = username
  console.log('My name is now: ' + this.username + '.')
}

User.prototype.lol = function() {
  console.log('"' + this.username + '" is a silly name!')
}

```

### Explanation

It might seem a little tricky at first glance, but it's pretty straight
forward. `Scope` is the context of the instances. `Parent` is a reference to the
"current" class (in this case it's `User`). `Dummy` is simply used for prototype
chaining (`Scope` is chained to `Parent`). `Proxy` is where the real magic
happens. `Proxy` is a normal function which, when executed, calls the
`Parent.prototype.init` function in the correct context. As well it's
`__proto__` is set to that of the current **instance**. This is the crucial
part as it allows `Proxy` to still act like a function and a plain object at
the same time.

### Demo

``` javascript
/* ------------------------------ Demo ------------------------------ */
var b = User('Ben')

console.log(b.username)   // Ben
console.log(b.colours)    // ['yellow', 255]

b.lol()                   // "Ben" is a silly name!
b('Benne')                // My name is now: Benne.
b.lol()                   // "Benne" is a silly name!
```

### Caveats

* Requires non-standard `__proto__`
* Cannot be used with `new` keyword
* Not very useful?

