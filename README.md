# dotnetthis

Shell Scripts to compile/run single C# files with `dotnet`

## Why this

We sometimes need one-off code running in our favorite language.

But we can't have that without a project and the setup takes too long.

With this, just write your code file and run directly,
or compile and share single file with the runner script (and config if needed). or edit scripts to your needs.

## How

Or in basics:

- Help: `./dotnetthis.sh`
- Compile: `./dotnetthis.sh compile FileName.cs [/out:Filename.exe]`
- Run: `./dotnetthis.sh run FileName.[dll/exe]`
- Compile&Run: `./dotnetthis.sh FileName (without extension)`
- Clean: `./dotnetthis.sh clean FileName (without extension)` ( removes dll, exe, and runtimeconfig.json(!) )

## Windows & WSL

You can run scripts on Windows with the help of WSL on any folder. Just open a console in one (or `cd` into one) and send a command to WSL. You may need to install `dotnet` inside.

I have Ubuntu installed in WSL, so for me the command is: `ubuntu -c ./dotnetthis.sh Filename`

Since it is cross-platform, compiled dll also runs on windows.

## Disclaimer

`clean` removes `Filename.runtimeconfig.json`. Please use carefuly.

`compile` creates `Filename.runtimeconfig.json` but if you move/share dll/exe without it, `run` will create `$HOME/.dotnet/csc-console-apps.runtimeconfig.json`

IDEs may not give you autocomplete context help as the file won't have links to them.
Be careful to write correct code.

I don't know if scripts can work to use external libraries. Honestly, I haven't tried that. It might be the next improvement to do.

## Development

You can say this work includes stolen assets :)
I have found compile and run scripts as response to this stackoverflow post:
https://stackoverflow.com/questions/46065777/is-it-possible-to-compile-a-single-c-sharp-code-file-with-the-net-core-roslyn-c

compile script is from @kinglionsz: https://stackoverflow.com/a/65283791/9512475

run script is from @ivan : https://stackoverflow.com/a/56133028/9512475

I am not a linux guru, so these were my jump starters. But they have few problems and they don't work together.

So I had to modify parts to suit my needs and created a 3rd one to merge the work.

What I got at the end was satifsying and I wanted to share it here for everyone's benefit (plus better than losing it among all projects on disk)

## Licencing:

I am not a licencing guru. Please tell me if the one here is permissive enough.
