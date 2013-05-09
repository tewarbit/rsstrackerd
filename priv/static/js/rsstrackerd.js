expandEntry = function(el, e) {
  if (hasClass(el, 'collapsed')) {
    removeClass(el, 'collapsed');  
    addClass(el, 'expanded');
    addClass(el, 'read');
    el.removeAttribute('onclick');

    var xhr = createXHR();
    // xhr.onreadystatechange = function() {
    //   if (xhr.readyState === 4) {
    //     //responseField.value = xhr.responseText;
    //     showPanel(xhr.responseText)
    //   }
    // }


    var feedId = el.getAttribute('feedid');
    
    xhr.open('POST', '/main/markread?feedid=' + feedId, true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    xhr.send();
  }

}

collapseEntry = function(el, e) {
    el = el.parentElement;
   if (hasClass(el, 'expanded')) {
    removeClass(el, 'expanded');  
    addClass(el, 'collapsed');
    el.setAttribute('onclick', 'expandEntry(this, event)');
    
    e.cancelBubble = true;
  } 
}

toggleView = function(el) {
  var s = el.innerHTML;
  var shouldExpand = (s.indexOf("collapsed") !== -1);
  if (shouldExpand) {
    el.innerHTML = "view: expanded";
  } else {
    el.innerHTML = "view: collapsed";
  }

  var entries = getElementsByClassName('entry');
  for (var i = entries.length - 1; i >= 0; i--) {
    if (shouldExpand) {
      removeClass(entries[i], 'collapsed');
      addClass(entries[i], 'expanded');
    } else {
      removeClass(entries[i], 'expanded');
      addClass(entries[i], 'collapsed');
    }
  };
}

function hasClass(ele,cls) {
    return ele.className.match(new RegExp('(\\s|^)'+cls+'(\\s|$)'));
}
function addClass(ele,cls) {
    if (!this.hasClass(ele,cls)) ele.className += " "+cls;
}
function removeClass(ele,cls) {
    if (hasClass(ele,cls)) {
        var reg = new RegExp('(\\s|^)'+cls+'(\\s|$)');
        ele.className=ele.className.replace(reg,' ');
    }
}