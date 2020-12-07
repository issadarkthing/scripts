#!/usr/bin/env bb
(ns prelude
  (:require
    [clojure.string :as str]
    [clojure.java.shell :as shell]
    [clojure.core.async :as async]))


(defmacro strf 
  "string interpolation using ~{x} where x can be any valid expression or symbol"
  [^String string]
  (let [-re #"~\{(.*?)\}"
        fstr (clojure.string/replace string -re "%s")
        fargs (map #(read-string (second %)) (re-seq -re string))]
    `(format ~fstr ~@fargs)))

(defn expand-home
  "expands tilde to home directory of current user"
  [^String s]
  (if (.startsWith s "~")
    (str/replace-first s "~" (System/getProperty "user.home"))
    s))

(defn $ 
  "use a single string to execute shell command and its arguments"
  [^String cmd]
  (shell/sh "bash" "-c" cmd))


(defn wait-all 
  "wait-all takes sequence of long running functions and wait for all
  functions to complete, returns vector of values. 
  It does not wait sequentially which produces
  non-deterministic sequence."
  [fns] 
  (let [chans (map (fn [f] (async/go (f))) fns)
        fn-length (count fns)
        acc-chans (async/merge chans)]

    (loop [i fn-length result '()]
      (if (zero? i)
        result
        (recur (dec i) (cons (async/<!! acc-chans) result))))))
