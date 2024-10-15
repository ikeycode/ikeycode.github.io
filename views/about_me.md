I'm Ikey Doherty, founder and lead of the [Serpent OS](https://serpentos.com) project.

I've worked exclusively on open source projects for the last two decades, both within the established industry and as a startup/competitor. My primary expertise incorporates the build and lifecycle management of open source operating systems, chiefly Linux®.
 
I have an extensive background in backend systems engineering roles, be they full delivery pipelines, software compliance, distributed build systems, etc.
For the last 6 months I've been working on a distributed build system to leverage token-authenticated agent systems in a scalable pipeline solution
to quickly and securely deploy software builds and updates for the Serpent OS project.

Most recently I've embraced the Rust programming language and continue to find new ways to integrate into existing software projects, such as Serpent OS for
our tooling, and lately the Thunderbird codebase for new components and libraries.

I've specialised the tooling of Serpent OS to enable the quick integration and improvement of the GNU GCC and LLVM Clang toolchains, having built Serpent OS with
`libc++` and `clang` by default, optionally employing GCC on a case by case basis. This allows us to investigate the best optimisation strategy in a simple, declarative
fashion. As a result, hardware specific optimisations, AVX2/AVX512 builds, 2-stage PGO, BOLT, etc, are all employed and trivially controlled by the recipe.
