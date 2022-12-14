// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("jquery");
require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("bootstrap");
require("@nathanvda/cocoon");

import $ from "jquery"
window.$ = $; // to get jQuery

require("utilities/answers");
require("utilities/questions");
require("utilities/votes");
require("channels");
