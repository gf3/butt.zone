/* ------------------------------ Main Class ------------------------------ */
// Returns "instances" of itself which are actually functions.
function User ( username ) { var Parent, scope
  function Scope () {
    // Here is where you put your normal constructor junk
    this.username = username
    this.colours = [ 'green', 0xFF ]
  }

  // Magic
  function Proxy() {
    Scope.prototype.init.apply( scope, arguments )
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

User.prototype.init = function( username ) {
  this.username = username
  console.log( 'My name is now: ' + this.username + '.' )
}

User.prototype.lol = function() {
  console.log( '"' + this.username + '" is a silly name!' )
}

