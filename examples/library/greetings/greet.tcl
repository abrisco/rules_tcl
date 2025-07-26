# The greetings library

namespace eval greetings {
    proc greet {name} {
        puts "Hello $name"
    }

    package provide greetings 1.0
}
