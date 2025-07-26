# A small script for testing tcllib access.

package require sha256

# The input string
set input "La-Li-Lu-Le-Lo"

# Expected hash (SHA-256 of the input string)
# You can compute this in Python:
#   >>> hashlib.sha256(b"La-Li-Lu-Le-Lo").hexdigest()
set expected "ec1411d0fb75590958a22ea09767beaeeee311af796007ea7536d0e5dd22cfac"

# Compute actual hash
set actual [::sha2::sha256 -hex $input]

# Compare
if {$actual ne $expected} {
    error "Hash mismatch! Expected $expected but got $actual"
} else {
    puts "Hash matches!"
}
