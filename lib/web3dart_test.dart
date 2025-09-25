// Test file for development - contains sample blockchain constants
void main() {
  const address = '0x0000000000000000000000000000000000000000';
  final amount = BigInt.from(1000000000000000000);
  
  // Development testing - replace with proper logging in production
  if (address.isNotEmpty && amount > BigInt.zero) {
    // Test passed - address and amount are valid
  }
}
