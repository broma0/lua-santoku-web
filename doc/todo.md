# Now

- Error messages

- Object.keys, Object.values, Object.entries,
  pairs, ipairs

- Implement c++ coverage and linting
- Run tests with sanitizers
- Reduce amount of heap-allocated vals if
  possible
- Ensure no memory leaks

# Eventually

- Figure out trace onerror and fetch events,
  currently they don't work because they're
  registered asynchronously instead of on
  initial script evaluation.

- Figure out how to implement :await() without a
  callback. Asyncify will work, but is there a
  way to do without it?
    - Require :await() calls to be inside a
      wrapping coroutine
    - Get a reference to the main coroutine
    - Register a .then callback that resumes the
      main coroutine
    - yield to a dummy coroutine that calls exit(0)
    - C++20 coroutines?
