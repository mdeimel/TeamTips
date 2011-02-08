// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
TT = {};

TT.changeWordWrap = function() {
  // Swap css for word wrap, and change link value
  var div = document.getElementById("tip_div");
  var link = document.getElementById("word_wrap_link");
  var classAttribute = "class";
  var style = div.getAttribute(classAttribute);
  // IE check
  if (style === undefined || style === null) {
    style = div.getAttribute("className");
    classAttribute = "className";
  }
  var word_wrap = style==="tip_div_wrap"?true:false;
  if (word_wrap) {
    div.setAttribute(classAttribute, "tip_div_no_wrap");
    link.innerHTML="Word Wrap";
  }
  else {
    div.setAttribute(classAttribute, "tip_div_wrap");
    link.innerHTML="No Word Wrap";
  }
}
