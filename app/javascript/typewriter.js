import Typewriter from "typewriter-effect/dist/core";

// https://github.com/tameemsafi/typewriterjs

const word = document.querySelector("#word");

new Typewriter(word, {
  strings: [
    '<span style="font-weight: bold;">unique</span>',
    '<span style="text-decoration: underline">memorable</span>',
    '<span style="font-style: italic;">phenomenal</span>',
  ],
  autoStart: true,
  pauseFor: 1600,
  deleteSpeed: 100,
  loop: true,
});
