#!/usr/bin/env bb
(ns script
  (:require [clojure.string :as str]))

(require '[prelude :refer [$ strf wait-all]])

(defn sha-1 [^String s] 
  (->>
    (.getBytes s)
    (.digest (java.security.MessageDigest/getInstance "SHA"))
    (map #(format "%02X" %))
    (apply str)))

(defn find-in [pred coll]
  (if-not coll
    nil
    (let [x (first coll)]
      (if (pred x)
        x
        (recur pred (next coll))))))

(defn get-pwned [passw]
  (let [[_prefix remain] (map #(apply str %) (split-at 5 (sha-1 passw)))]
   (->>
     ($ (strf "curl -Ss https://api.pwnedpasswords.com/range/~{_prefix}"))
     (:out)
     (str/split-lines)
     (find-in #(str/includes? % remain)))))


(defn pwned [passw]
  (let [result (get-pwned passw)]
    (if result
      (second (str/split result #":"))
      "0")))


(defn decrypt-file [_path]
  (:out ($ (strf "gpg -d ~{_path}"))))

(defn strip-path [path]
  (str/join "/" (take-last 2 (str/split path #"\/"))))


(defn process [passw]
  (let [result (pwned (:passw passw))
        path (strip-path (:path passw))]
    (println (str path " has been found " result " times"))))

(wait-all (->> 
            ($ "find ~/.password-store/**/*.gpg")
            (:out)
            (str/split-lines)
            (map #(hash-map :path % :passw (decrypt-file %)))
            (map #(partial process %))))

nil
