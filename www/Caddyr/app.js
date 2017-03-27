function humanFileSize(bytes, si) {
  var thresh = si ? 1000 : 1024;
  if(Math.abs(bytes) < thresh) {
    return bytes + ' B';
  }
  var units = si
    ? ['kB','MB','GB','TB','PB','EB','ZB','YB']
    : ['KiB','MiB','GiB','TiB','PiB','EiB','ZiB','YiB'];
  var u = -1;
  do {
    bytes /= thresh;
    ++u;
  } while(Math.abs(bytes) >= thresh && u < units.length - 1);
  return bytes.toFixed(1)+' '+units[u];
}

function extension(filename) {
  return (/[.]/.exec(filename)) ? /[^.]+$/.exec(filename) : "default";
}

function doSearch() {
  var searchText = document.getElementById('searchTerm').value;
  var targetTable = document.getElementById('dataTable');
  var targetTableColCount;

  //Loop through table rows
  for (var rowIndex = 0; rowIndex < targetTable.rows.length; rowIndex++) {

    var rowData = targetTable.rows.item(rowIndex).cells.item(1);
    rowData = rowData.getElementsByTagName('a')[0].innerHTML.toLowerCase();

    // If search term is not found in row data
    // then hide the row, else show
    if (rowData.indexOf(searchText) == -1)
      targetTable.rows.item(rowIndex).style.display = 'none';
    else
      targetTable.rows.item(rowIndex).style.display = 'table-row';
  }
}

function detectmob() {
 if( navigator.userAgent.match(/Android/i)
 || navigator.userAgent.match(/webOS/i)
 || navigator.userAgent.match(/iPhone/i)
 || navigator.userAgent.match(/iPad/i)
 || navigator.userAgent.match(/iPod/i)
 || navigator.userAgent.match(/BlackBerry/i)
 || navigator.userAgent.match(/Windows Phone/i)
 ){
    return true;
  }
 else {
    return false;
  }
}

document.addEventListener("DOMContentLoaded", function(event) {

  var LKname = document.getElementById("link-name");
  if (document.URL.indexOf("asc") != -1) {
    LKname.href="?sort=name&amp;order=desc";
  }else{
    LKname.href="?sort=name&amp;order=asc";
  }

  var LKtime = document.getElementById("link-time");
  if (document.URL.indexOf("asc") != -1) {
    LKtime.href="?sort=time&amp;order=desc";
  }else{
    LKtime.href="?sort=time&amp;order=asc";
  }

  var LKsize = document.getElementById("link-size");
  if (document.URL.indexOf("asc") != -1) {
    LKsize.href="?sort=size&amp;order=desc";
  }else{
    LKsize.href="?sort=size&amp;order=asc";
  }

  // if is on a mobile then play the video on a player
  if (!detectmob()) {
    [].forEach.call(document.querySelectorAll('.play'), function (el) {
      el.style.display = 'none';
    });
  }
});
