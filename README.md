# ghostintheguileshell

$$\mathcal{T}: \mathbb{N} \rightarrow \mathbb{N} \cong \{a_n\}_{n=0}^{\infty} = \{0,1,1,2,4,9,20,48,115,286,719,...\}$$

Implementation of OEIS sequence [A000081](https://oeis.org/A000081) - the number of rooted trees with n nodes (unlabeled rooted trees).

## Mathematical Definition

The sequence is uniquely defined by the generating function:

$$\exists! \mathcal{A}(x) \in \mathbb{C}[[x]] \ni \mathcal{A}(x) = x \cdot \exp\left(\sum_{k=1}^{\infty}\frac{\mathcal{A}(x^k)}{k}\right)$$

And computed using the recurrence relation:

$$\forall n \in \mathbb{N}^{+}, a_{n+1} = \frac{1}{n}\sum_{k=1}^{n}\left(\sum_{d|k}d \cdot a_d\right)a_{n-k+1}$$

Where $a_0 = 0$ and $a_1 = 1$.

## Requirements

- GNU Guile 3.0 or later

## Installation

```bash
# Install Guile (Debian/Ubuntu)
sudo apt-get install guile-3.0

# Or on other systems, see: https://www.gnu.org/software/guile/
```

## Usage

### Command Line Interface

Generate the first n terms of the sequence:

```bash
./ghost <n>
```

Example:
```bash
./ghost 20
# Output: Sequence T(n) for n = 0 to 19:
# {0,1,1,2,4,9,20,48,115,286,719,1842,4766,12486,32973,87811,235381,634847,1721159,4688676}
```

### As a Library

Load `ghost.scm` in your Guile program:

```scheme
(load "ghost.scm")

;; Compute T(n) for a specific n
(rooted-trees 10)  ; => 719

;; Generate first n terms
(generate-sequence 10)  ; => (0 1 1 2 4 9 20 48 115 286)

;; Get all divisors of a number
(divisors 12)  ; => (1 2 3 4 6 12)
```

## Testing

Run the test suite to verify the implementation:

```bash
guile test-ghost.scm
```

## Implementation Details

The implementation uses memoization to cache computed values, making it efficient for computing many terms of the sequence. The recurrence relation involves:

1. Computing divisor sums: For each k, sum d·a(d) over all divisors d of k
2. Applying the main recurrence to compute a(n+1) from previous terms

## License

See LICENSE file.
