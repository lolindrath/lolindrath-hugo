---
date: 2022-03-10T14:34:53-05:00
tags: 
  - iOS
  - Swift
  - SwiftLint
draft: true
---

# TextFieldStyle and SwiftLint

I ran into a problem today where [SwiftLint](https://github.com/realm/SwiftLint) was mad at [TextFieldStyle](https://swiftontap.com/textfieldstyle) because it has you implement the `public func _body` function which doesn't start with a lower case letter like the [identifier_name](https://realm.github.io/SwiftLint/identifier_name.html) rule wants.

The fix was to put this comment right above the function signature:

```swift
// swiftlint:disable:next identifier_name
func _body(configuration: TextField<Self._Label>) -> some View {
```

And here's the raw error that the compiler was throwing:

```
Identifier Name Violation: Function name should start with a lowercase character: '_body(configuration:)' (identifier_name)
```

