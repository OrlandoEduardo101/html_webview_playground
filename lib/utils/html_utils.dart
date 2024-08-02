String transformHtml(String html) {
    // Transform <li data-list="bullet"> to <ul> with <li>
    html = html.replaceAllMapped(
      RegExp(r'<li data-list="bullet">(.*?)<\/li>', dotAll: true),
      (match) => '<li style="list-style-type: disc;">${match.group(1)}</li>',
    );

    // Transform <li data-list="ordered"> to <ol> with <li>
    html = html.replaceAllMapped(
      RegExp(r'<li data-list="ordered">(.*?)<\/li>', dotAll: true),
      (match) => '<li style="list-style-type: decimal;">${match.group(1)}</li>',
    );

    // Replace <ol> containing bullet items to <ul>
    html = html.replaceAllMapped(
      RegExp(r'<ol>(.*?<li style="list-style-type: disc;">.*?<\/li>.*?)<\/ol>', dotAll: true),
      (match) => '<ul>${match.group(1)}</ul>',
    );

    // Replace <ol> containing ordered items to <ol>
    html = html.replaceAllMapped(
      RegExp(r'<ol>(.*?<li style="list-style-type: decimal;">.*?<\/li>.*?)<\/ol>', dotAll: true),
      (match) => '<ol>${match.group(1)}</ol>',
    );

    return html;
  }