---
title: DispatchGroup, Combine, and UrlSession
date: 2022-06-28T11:00:20-04:00
tags: 
  - iOS
  - Swift
  - DispatchGroup
  - Combine
  - UrlSession
---

I ran into a bug a couple weeks ago at work that was quite interesting. We're using a DispatchGroup and `DispatchGroup.notify` to stop our pull to refresh animation once all the microservices come back with results.

Our QA team caught an issue where if you to a pull to refresh and then background the app it crashes. Of course you can't simulate the error, it has to be on a physical device. Also, while using a debug profile it doesn't crash, just hangs forever.

It took me a few days of experimenting and debugging but I finally figured out that the HTTP calls were being unceremoniously killed by the OS.

Our code looks something like this:

```swift
let group = DispatchGroup()

group.enter()
service1.fetch() {
    group.leave()
}

...

serviceN.fetch() { // service goes off and does async things
    group.leave()
}

group.notify(queue: DispatchQueue.main) {
    pullToRefreshCallback()
}
```

In debug mode when I paused the execution I could see my app was stuck down in pthreads land and that's when I figured it out. `group.leave()` for the failing service(s) was never called because the call was ended at the OS level. There was zero feedback that I could find to know that this happened.

I also couldn't find a method that would allow the `group.notify()` to timeout. I also couldn't find anything on UrlSession that would give me the proper feedback that something happened to my request.

So I turned to Combine:

```swift
subscription = publisher
            .timeout(.milliseconds(1_000), scheduler: DispatchQueue.global(qos: .userInitiated), options: nil, customError: { .timeout }) // 1
            .receive(on: DispatchQueue.main) // 2
            .collect(numberOfNetworkCalls) // 3
            .sink(
                receiveCompletion: { [weak self] error in
                    completionCallback(error) // 4
                    subscription?.cancel() // 5
                },
                receiveValue: { [weak self] services in
                    successCallback() // 6
                    subscription?.cancel()
                })

makeNetworkCall1. { _ in
	publisher.send(.networkCall1)
}

...
```

1. This timeout is key - when the app is backgrounded and comes back this calls the completion handler with the custom error `.timeout` otherwise we wouldn't know it failed.
2. I found out the hard way that the order of `.timeout()` and `.receive(on:)` is important, if `.timeout()` is second the publisher will use the scheduler specified there instead of `.receive(on:)` .
3. `.collect()` will wait until results of all our network calls are returned before declaring success
4. Handle the completion - whether a timeout or a normal completion
5. There's a slim chance that the timeout and success completion handlers can happen at the same time - explicitly ending the subscription helped with this
6. If we hit `receiveValue` then we gathered all the network calls and we can handle the network responses however we want
7. Now that the subscription is setup, make the network calls



I feel like this wasn't the best solution - anyone have any better ideas? 



Open Questions:

1. Why do the network calls not finish in the background? Even if I turn on background network at the app level it gets killed.
2. Is there any other way to get the feedback that the request was killed from UrlSession? The callbacks are never executed and nothing I can find on the UrlSession delegates was helpful.
3. Is there a way to shortcut a `group.notify()` after a certain amount of time? I tried this by starting a delayed async thread and sending `group.leave()` a bunch but it got angry about that too and threw a `SIGTRAP` at me.