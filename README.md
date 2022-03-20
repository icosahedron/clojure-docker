# Clojure in Docker

This is a Dockerfile for building a Clojure image with nREPL.

Build the image from the Docker file in this directory
```
docker build -t clojure-temp .
```

Run the container with your project directory mapped to /home/user/clojure in the container.
Puts an nREPL available on port 9999 of the docker container.

```
docker run -d -v "$PWD:/home/user/clojure" -p 9999:9999 clojure-temp
```

Attach your favorite editor or IDE to port 9999.

## Dynamically Loading Libraries in the REPL

You can dynamically add dependencies by hot loading them.  I've included
the [Practicalli](https://practical.li/clojure/) `deps.edn` in the configuration for doing so.  You just need to `require` the proper function, and then it becomes available.

```
(require '[clojure.tools.deps.alpha.repl :refer [add-libs]])
```

Once `add-libs` is available, add the dependency just like you would in
`deps.edn`.  (You can reload the `deps.edn` using [this technique](https://practical.li/clojure-staging/alternative-tools/clojure-tools/hotload-libraries.html#using-add-libs-with-project-configuration-file).)

Here is an example of including hiccup hot loaded.

```
(add-libs '{hiccup/hiccup {:mvn/version "2.0.0-alpha2"}})
Warning: failed to load the S3TransporterFactory class
Downloading: hiccup/hiccup/2.0.0-alpha2/hiccup-2.0.0-alpha2.pom from clojars
Downloading: hiccup/hiccup/2.0.0-alpha2/hiccup-2.0.0-alpha2.jar from clojars
=> (hiccup/hiccup)

(require '[hiccup.core :as hiccup])
=> nil

(hiccup/html [:div {:class "right-aligned"}])
=> "<div class=\"right-aligned\"></div>"
```

This does *not* add the libraries to the `deps.edn`.

## Terminal Output

If you want to create terminal output rather than just REPL output, you
can start the container in interactive mode and then attach to it.

`*out*` will go to the REPL, but `stdout` will go to the terminal.  (This is
useful to me developing my roguelike.)

```
docker run -d -it -v "$PWD:/home/user/clojure" -p 9999:9999 clojure-temp
<Some big hex number>
docker attach <Some big hex number>
```

Print to the terminal from inside container.

```
(.. System/out (println "\u001b[2J")) ; clear the screen
(.. System/out (println "Hello, world")) ; "Hello world" at current cursor position
```

Use `Ctrl-P, Ctrl-Q` to detach from the container.

## TODO

Add [Clerk](https://github.com/nextjournal/clerk) to the configuration by default.

Add a browser based terminal for terminal interaction

* xterm.js with websocket to container
* web server
* reset the repl state to new
