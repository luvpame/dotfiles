---
title: "AI coding has made CI a bottleneck, so we reworked ours to keep up"
source_url: "https://linear.app/now/ci-bottleneck-reworked"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Now](https://linear.app/now.html)
2. [From the team](https://linear.app/now/team.html)

# AI coding has made CI a bottleneck, so we reworked ours to keep up

![Animated vertical lines accelerating and converging from left to right on a dark background](https://webassets.linear.app/images/ornj730p/production/ecfd20aa38173e85e7abd6202c318a7b079beba9-3904x1600.png?q=95&auto=format&dpr=2)

![Animated vertical lines accelerating and converging from left to right on a dark background](https://webassets.linear.app/images/ornj730p/production/adfdac39474fdc56e2ff8546d6501622144d3074-2352x1280.png?q=95&auto=format&dpr=2)

[Mufeez Amjad](https://linear.app/now/author/mufeez-amjad.html)·September 21, 2026

Earlier this year, I opened Linear to find that Tuomas, our CTO, had assigned an issue to me, titled “CI costs are high.” While I was at it, he also wanted me to make CI faster.

Agents have made it exponentially faster to ship code, but validating those changes hasn’t quite kept up at the same rate. Every PR still has to pass through CI, so as development accelerates, CI becomes a bottleneck, driving up infrastructure costs and leaving developers and agents waiting longer for feedback.

In our pursuit to make CI more performant at Linear, we optimized for how long a PR waits on CI and how much runner time it consumes. Despite our test suites almost *quadrupling* since the start of the year, we brought pull request wait time down from more than 6 minutes to just over 5, while cutting runner time per test roughly in half.

![Performance metrics chart showing test coverage increase (blue line) and machine time reduction (white line) from January through September.](https://webassets.linear.app/images/ornj730p/production/eda443893b72237b999b27ca5e953b82dfc33f9d-3904x2574.png?q=95&auto=format&dpr=2)

![Performance metrics chart showing test coverage increase (blue line) and machine time reduction (white line) from January through September.](https://webassets.linear.app/images/ornj730p/production/3eba33b44988c01d7577222aa3bb4725fab07889-2352x1887.png?q=95&auto=format&dpr=2)

This is test suite performance indexed to the first week of January. The white line, tracking machine time per test, spikes when we added test shards, which shorten the wait and costs more machine time, and again during checkout stalling issues

Broadly, we improved CI in four ways:

* Upgraded infrastructure and tooling
* Optimized the jobs that gate other work
* Reduced repeated setup
* Made test execution more efficient

Linear’s codebase is primarily TypeScript, but many of these optimizations apply across languages and toolchains.

### Upgraded infrastructure and tooling[⁠](https://linear.app/now/ci-bottleneck-reworked.html#upgraded-infrastructure-and-tooling)

Some of our earliest gains required almost no optimization of CI itself. Moving our workloads off GitHub Actions to third-party runners with faster CPUs, higher-performance storage, and better cache infrastructure gave us faster machines to run the same pipeline on. In a like-for-like comparison of the two days either side of the switch, jobs ran 34% faster on average, with some workloads like `tsc` dropping 52%.

Separately, modernizing our toolchain also paid off. Switching to `tsgo`, the native TypeScript compiler, cut the weekly median of the `tsc` check by 73%, large enough to move the bottleneck off of typechecking entirely.

#### Lint without the type checker[⁠](https://linear.app/now/ci-bottleneck-reworked.html#lint-without-the-type-checker)

Linting was another early target. A handful of our custom lint rules depended on TypeScript type information, either to enforce a restriction or apply an autofix. That meant every lint run had to build the full type graph before evaluating those rules, making linting one of our most memory-intensive CI jobs.

We rewrote the rules to use static analysis over the abstract syntax tree, identifying function-like constructs and guard patterns without type information. That let ESLint drop TypeScript entirely, reducing API lint time by 68%, and full-repository lint time by 55%. Memory usage dropped substantially as well.

Removing the dependency on type information also made our later move to [Oxlint](https://oxc.rs/docs/guide/usage/linter) much easier because rules that operate purely on syntax are straightforward to port. Oxlint itself reduced the CI runner-minutes spent on linting.

### Optimize the jobs that gate other work[⁠](https://linear.app/now/ci-bottleneck-reworked.html#optimize-the-jobs-that-gate-other-work)

With the underlying infrastructure and individual checks running faster, we zoomed out to look at CI as a system. That drew our attention to the small jobs that sat in front of everything else. Every run starts by checking which paths a PR touched and whether these tests have already passed for the same inputs. We gate on those checks at the job level so skipped work never reserves a runner, but that also puts them directly on the critical path. None of the eight API test shards can start until they finish, making even small delays disproportionately important.

#### Fetch only what each job needs[⁠](https://linear.app/now/ci-bottleneck-reworked.html#fetch-only-what-each-job-needs)

Several of our workflows start with a change-detection job that decides what runs next; for instance, it checks whether a diff contains a database migration and outputs a signal used to schedule the relevant database CI checks. These jobs were checking out the full working tree even though they needed only a small subset of it. We capped the fetch depth, which took the slowest of these gates from 94 seconds to 20, and removed checkout entirely from the jobs that never needed a working tree, reducing time spent on those from 27 seconds to 7. For commit push and merge-queue events, where we do have to diff paths, we found that a sparse, blobless checkout with limited history was enough, saving another 11 odd seconds.

![Performance distribution histogram: blue bars (After 8s median) and gray bars (Before 26s median), showing reduced load times after optimization.](https://webassets.linear.app/images/ornj730p/production/5c8801fa44f16dc10d015ee843c7ce9d06a329f8-3904x1992.png?q=95&auto=format&dpr=2)

![Performance distribution histogram: blue bars (After 8s median) and gray bars (Before 26s median), showing reduced load times after optimization.](https://webassets.linear.app/images/ornj730p/production/a64c14ac0bb92f61f832f7cb0962dd769cd1b39a-2352x1640.png?q=95&auto=format&dpr=2)

The median duration of the change-detection job fell from 26 to 8 seconds, p90 from 31 to 12 seconds, and the slowest run from 138 to 37 seconds.

#### Make checkout more resilient[⁠](https://linear.app/now/ci-bottleneck-reworked.html#make-checkout-more-resilient)

After we swapped the underlying runner infrastructure, we noticed that our checkout times (with `actions/checkout`) in our jobs had gotten longer and would sometimes hang. Because the third-party runners sit outside GitHub’s network, they rely on a direct IP link to reach GitHub. The provider traced the hangs to intermittent degradation on that link. Several of our workflows begin with a checkout, so a stalled fetch could delay the entire CI run.

To be resilient to the network instability, we replaced `actions/checkout` with a composite action of our own that retried with backoff, and sets `GIT_HTTP_LOW_SPEED_LIMIT` and `GIT_HTTP_LOW_SPEED_TIME` so a stalled connection aborts after about 30 seconds instead of hanging and also uses the checkout cache, which keeps a persistent git mirror on a sticky disk. The result was far fewer runs where a critical-path job sat idle waiting for checkout to finish.

#### Minimize what’s on the critical path[⁠](https://linear.app/now/ci-bottleneck-reworked.html#minimize-what's-on-the-critical-path)

Not every job on the critical path needed to be there. We were writing cache markers as part of the final check before merging, which meant a pull request could sit in the merge queue even after its tests had passed. We moved that write into a job that runs once the test shards finish but gates nothing, shaving 42 seconds from the merge path for every API pull request and merge-queue entry.

Together, these changes took roughly a minute off the required check for API pull requests on cache misses, while also reducing runner starts.

### Reduce repeated setup[⁠](https://linear.app/now/ci-bottleneck-reworked.html#reduce-repeated-setup)

From there, we turned to the setup cost repeated across every job, like booting a runner, installing packages, and provisioning build dependencies. That overhead means a job that does only seconds of useful work can end up consuming whole minutes of infrastructure time. Here are a few steps we took to work around that issue:

#### Preinstall shared dependencies in the CI image[⁠](https://linear.app/now/ci-bottleneck-reworked.html#preinstall-shared-dependencies-in-the-ci-image)

Our API test shards each spent 7 to 8 seconds installing the same Postgres client with apt on every run. We moved it into a small CI base image containing Node and the client, so each shard could start from an environment that was ready to run. We later added the required native build headers to the image after discovering that downloading them during setup could occasionally hang, shortening the tail.

#### Install only the dependencies each job needs[⁠](https://linear.app/now/ci-bottleneck-reworked.html#install-only-the-dependencies-each-job-needs)

Linear’s codebase is a monorepo managed as a pnpm workspace. Our API test workflow was installing the entire workspace even though it only needed the API package and its dependencies. Restricting the install to our API package cut pnpm install from 44-73 seconds to 16-18 seconds. We applied the same pattern to API-adjacent jobs, which were each installing the full repository and uploading a dependency cache that later runs almost never hit.

#### Don’t cache when it’s faster to rebuild[⁠](https://linear.app/now/ci-bottleneck-reworked.html#don't-cache-when-it's-faster-to-rebuild)

We also tested caching `node_modules` and found it was faster to rebuild. The cache key depended on a frequently changing lockfile, and even a cache hit took about 28 seconds to restore, compared with roughly 7.5 seconds for a filtered install. The cache was adding save time and variability without giving us any discernible advantage.

Together, these three changes reduced per-shard setup time by roughly 44%, from 110-140 seconds to 67-73 seconds.

![GitHub Actions workflow comparison showing test-api runs with step-by-step timing breakdown; left run (4m 57s) versus right run (3m 14s), demonstrating performance improvements across pipeline stages](https://webassets.linear.app/images/ornj730p/production/255f6d6753d4fc66527d057e07583e4d7a965eaf-3904x2427.png?q=95&auto=format&dpr=2)

![GitHub Actions workflow comparison showing test-api runs with step-by-step timing breakdown; left run (4m 57s) versus right run (3m 14s), demonstrating performance improvements across pipeline stages](https://webassets.linear.app/images/ornj730p/production/b41c17cca632f28720500237ddff79183c6e699c-2352x4512.png?q=95&auto=format&dpr=2)

p95 durations of a test shard

Beyond this, there were other forms of repeated setup we could avoid altogether.

#### Avoid replaying unchanged setup[⁠](https://linear.app/now/ci-bottleneck-reworked.html#avoid-replaying-unchanged-setup)

Some setup work only needs to be repeated when its inputs change. Our API containers, for example, were replaying the full database migration history on every run, even when a PR hadn’t changed the schema. For those cases, we switched to loading a generated schema snapshot and bootstrap file instead, cutting database setup from roughly 12 seconds to 1-2 seconds per container.

#### Batch short checks into fewer jobs[⁠](https://linear.app/now/ci-bottleneck-reworked.html#batch-short-checks-into-fewer-jobs)

Seven independent checks were each starting a runner, checking out the repository, and installing dependencies before doing only seconds of useful work. We consolidated them into two jobs, and then ran the seven tasks concurrently inside them. That reduced the number of times we paid the same setup overhead from seven to two. Based on June usage, the change saved roughly 87,000 runner-minutes per month, equivalent to 11.8% of our total CI usage.

![Before and after comparison of CI/CD pipeline batching optimization, showing test workflow steps with execution times and dependencies, with all tasks marked as successfully completed](https://webassets.linear.app/images/ornj730p/production/884c715d71f694b22f00103bea04a7f01935fc8b-3904x4020.png?q=95&auto=format&dpr=2)

![Before and after comparison of CI/CD pipeline batching optimization, showing test workflow steps with execution times and dependencies, with all tasks marked as successfully completed](https://webassets.linear.app/images/ornj730p/production/713a72257d6e99f1d112e42fde8c3f61f9d63b7a-2352x3693.png?q=95&auto=format&dpr=2)

### Make test execution more efficient[⁠](https://linear.app/now/ci-bottleneck-reworked.html#make-test-execution-more-efficient)

With the fixed cost of each test shard down, we could afford to parallelize the API suite more aggressively. It was the largest and one of the most frequently executed parts of our workflow, so improvements there had an outsized effect on merge time.

#### Balance work the way the test runner sees it[⁠](https://linear.app/now/ci-bottleneck-reworked.html#balance-work-the-way-the-test-runner-sees-it)

[Vitest](https://vitest.dev/), the test runner we use for our TypeScript test suites, distributes work by file rather than by the duration of individual tests. That meant a few unusually large test files could dominate a shard and effectively hold up completion of the entire suite, even when the other shards finished much earlier.

We split those large files into smaller, more focused files while preserving the structure of the tests, then evaluated different shard and runner configurations. We had already gone from three to four shards earlier in the year; moving to eight made the critical job roughly 19% faster and 19% cheaper in our initial benchmark. A week after the change, the slowest shard dropped from 5.25 minutes to 4.33 minutes.

#### Share module state only with strict isolation rules[⁠](https://linear.app/now/ci-bottleneck-reworked.html#share-module-state-only-with-strict-isolation-rules)

Vitest normally isolates every test file, which for us meant rebuilding the entity, GraphQL, and decorator graph in each test shard. We introduced an opt-in vitest project with `isolate: false`, allowing safe files to share a module registry within each worker.

![Module state caching optimization: Before (individual state per file) versus After (single shared state), reducing redundant rebuilds across worker processes](https://webassets.linear.app/images/ornj730p/production/a138adde6e657ae99f1855219262a0d381617c89-3904x1801.png?q=95&auto=format&dpr=2)

![Module state caching optimization: Before (individual state per file) versus After (single shared state), reducing redundant rebuilds across worker processes](https://webassets.linear.app/images/ornj730p/production/05b8b8ee77f21e5dd1cb6dd23b1d2128869b0814-2352x3200.png?q=95&auto=format&dpr=2)

This was our largest single performance improvement, worth roughly 17% in monthly savings at our volume. The slowest shard fell from roughly 300-379 seconds to about 195 seconds, while total API-shard runner time dropped from about 32.8 to 22 minutes per run.

It was also the optimization with the highest correctness risk. We made eligibility explicit with an opt-in comment on every file, and added the necessary teardown for shared state. A handful of files used fake timers or shared state in ways we couldn’t untangle safely, so we left them in the isolated project. And because agents now write the majority of our tests, we updated our respective agent skills to account for this performance opt-in as well, so generated tests follow the same constraints by default.

#### Sharding is limited by setup overhead[⁠](https://linear.app/now/ci-bottleneck-reworked.html#sharding-is-limited-by-setup-overhead)

Further sharding only pays off when the fixed cost per shard is low, since doubling the shard count also doubles the workflow time spent on setup. The setup optimizations we referred to earlier are what made eight shards practical. At 110-140 seconds per shard, eight shards would have spent 15-19 minutes of runner time on setup alone, more than the tests themselves. Setup is now around 40 seconds, so eight shards spend less total setup time than four did before, while parallelizing the tests twice as far.

![Test sharding optimization: increasing from 4 shards (8.3 min setup) to 8 shards (7.5 min setup) with better parallelization of test workloads](https://webassets.linear.app/images/ornj730p/production/ed8caac137a2a22007bf60bfbcc9255d9b8a2ee0-3904x1892.png?q=95&auto=format&dpr=2)

![Test sharding optimization: increasing from 4 shards (8.3 min setup) to 8 shards (7.5 min setup) with better parallelization of test workloads](https://webassets.linear.app/images/ornj730p/production/92bab9eae6426604ee5aa6bf2c9fe0b230e2aee9-2352x2376.png?q=95&auto=format&dpr=2)

Before setup optimizations, the test job used 4 shards and spent 8.3 minutes on setup. Afterward, we could run 8 shards with 7.5 minutes of setup.

### Improvements that compound across a system[⁠](https://linear.app/now/ci-bottleneck-reworked.html#improvements-that-compound-across-a-system)

Had we not made a deliberate effort to improve CI earlier this year, today’s test suite would take roughly 11 minutes, close to double what developers wait now. And the work doesn’t end here. It’s clear that our codebase will continue to grow; we’re currently adding roughly 2,000 tests a week. Keeping CI fast as that happens will be a continued effort, much of it using what we learned through this process to new bottlenecks.

![Breakdown of CI/CD performance improvements across pipeline stages, showing percentage time reductions ranging from -12% to -89% across toolchain, gating jobs, setup, and overall metrics](https://webassets.linear.app/images/ornj730p/production/2446b3f3252a7dc866815ef107980a27f7f0fdab-3904x2784.png?q=95&auto=format&dpr=2)

![Breakdown of CI/CD performance improvements across pipeline stages, showing percentage time reductions ranging from -12% to -89% across toolchain, gating jobs, setup, and overall metrics](https://webassets.linear.app/images/ornj730p/production/653fe666c8506212c6685a5a7be3ffffe502139e-2352x2392.png?q=95&auto=format&dpr=2)

[Mufeez Amjad](https://linear.app/now/author/mufeez-amjad.html)·September 21, 2026

Copy link
