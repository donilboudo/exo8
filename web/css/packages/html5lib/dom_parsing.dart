/**
 * This library contains extra APIs that aren't in the DOM, but are useful
 * when interacting with the parse tree.
 */
library dom_parsing;

import 'dart:math';
import 'package:utf/utf.dart' show codepointsToString;
import 'dom.dart';

/** A simple tree visitor for the DOM nodes. */
class TreeVisitor {
  visit(Node node) {
    switch (node.nodeType) {
      case Node.ELEMENT_NODE: return visitElement(node);
      case Node.TEXT_NODE: return visitText(node);
      case Node.COMMENT_NODE: return visitComment(node);
      case Node.DOCUMENT_FRAGMENT_NODE: return visitDocumentFragment(node);
      case Node.DOCUMENT_NODE: return visitDocument(node);
      case Node.DOCUMENT_TYPE_NODE: return visitDocumentType(node);
      default: throw new UnsupportedError('DOM node type ${node.nodeType}');
    }
  }

  visitChildren(Node node) {
    // Allow for mutations (remove works) while iterating.
    for (var child in node.nodes.toList()) visit(child);
  }

  /**
   * The fallback handler if the more specific visit method hasn't been
   * overriden. Only use this from a subclass of [TreeVisitor], otherwise
   * call [visit] instead.
   */
  visitNodeFallback(Node node) => visitChildren(node);

  visitDocument(Document node) => visitNodeFallback(node);

  visitDocumentType(DocumentType node) => visitNodeFallback(node);

  visitText(Text node) => visitNodeFallback(node);

  // TODO(jmesserly): visit attributes.
  visitElement(Element node) => visitNodeFallback(node);

  visitComment(Comment node) => visitNodeFallback(node);

  // Note: visits document by default because DocumentFragment is a Document.
  visitDocumentFragment(DocumentFragment node) => visitDocument(node);
}

/**
 * Converts the DOM tree into an HTML string with code markup suitable for
 * displaying the HTML's source code with CSS colors for different parts of the
 * markup. See also [CodeMarkupVisitor].
 */
String htmlToCodeMarkup(Node node) {
  return (new CodeMarkupVisitor()..visit(node)).toString();
}

/**
 * Converts the DOM tree into an HTML string with code markup suitable for
 * displaying the HTML's source code with CSS colors for different parts of the
 * markup. See also [htmlToCodeMarkup].
 */
class CodeMarkupVisitor extends TreeVisitor {
  final StringBuffer _str;

  CodeMarkupVisitor() : _str = new StringBuffer();

  String toString() => _str.toString();

  visitDocument(Document node) {
    _str.write("<pre>");
    visitChildren(node);
    _str.write("</pre>");
  }

  visitDocumentType(DocumentType node) {
    _str.write('<code class="markup doctype">&lt;!DOCTYPE ${node.tagName}>'
        '</code>');
  }

  visitText(Text node) {
    // TODO(jmesserly): would be nice to use _addOuterHtml directly.
    _str.write(node.outerHtml);
  }

  visitElement(Element node) {
    _str.write('&lt;<code class="markup element-name">${node.tagName}</code>');
    if (node.attributes.length > 0) {
      node.attributes.forEach((key, v) {
        v = htmlSerializeEscape(v, attributeMode: true);
        _str.write(' <code class="markup attribute-name">$key</code>'
            '=<code class="markup attribute-value">"$v"</code>');
      });
    }
    if (node.nodes.length > 0) {
      _str.write(">");
      visitChildren(node);
    } else if (isVoidElement(node.tagName)) {
      _str.write(">");
      return;
    }
    _str.write(
        '&lt;/<code class="markup element-name">${node.tagName}</code>>');
  }

  visitComment(Comment node) {
    var data = htmlSerializeEscape(node.data);
    _str.write('<code class="markup comment">&lt;!--${data}--></code>');
  }
}


// TODO(jmesserly): reconcile this with dart:web htmlEscape.
// This one might be more useful, as it is HTML5 spec compliant.
/**
 * Escapes [text] for use in the
 * [HTML fragment serialization algorithm][1]. In particular, as described
 * in the [specification][2]:
 *
 * - Replace any occurrence of the `&` character by the string `&amp;`.
 * - Replace any occurrences of the U+00A0 NO-BREAK SPACE character by the
 *   string `&nbsp;`.
 * - If the algorithm was invoked in [attributeMode], replace any occurrences of
 *   the `"` character by the string `&quot;`.
 * - If the algorithm was not invoked in [attributeMode], replace any
 *   occurrences of the `<` character by the string `&lt;`, and any occurrences
 *   of the `>` character by the string `&gt;`.
 *
 * [1]: http://www.whatwg.org/specs/web-apps/current-work/multipage/the-end.html#serializing-html-fragments
 * [2]: http://www.whatwg.org/specs/web-apps/current-work/multipage/the-end.html#escapingString
 */
String htmlSerializeEscape(String text, {bool attributeMode: false}) {
  // TODO(jmesserly): is it faster to build up a list of codepoints?
  // StringBuffer seems cleaner assuming Dart can unbox 1-char strings.
  StringBuffer result = null;
  for (int i = 0; i < text.length; i++) {
    var ch = text[i];
    String replace = null;
    switch (ch) {
      case '&': replace = '&amp;'; break;
      case '\u00A0'/*NO-BREAK SPACE*/: replace = '&nbsp;'; break;
      case '"': if (attributeMode) replace = '&quot;'; break;
      case '<': if (!attributeMode) replace = '&lt;'; break;
      case '>': if (!attributeMode) replace = '&gt;'; break;
    }
    if (replace != null) {
      if (result == null) result = new StringBuffer(text.substring(0, i));
      result.write(replace);
    } else if (result != null) {
      result.write(ch);
    }
  }

  return result != null ? result.toString() : text;
}


/**
 * Returns true if this tag name is a void element.
 * This method is useful to a pretty printer, because void elements must not
 * have an end tag.
 * See <http://dev.w3.org/html5/markup/syntax.html#void-elements> for more info.
 */
bool isVoidElement(String tagName) {
  switch (tagName) {
    case "area": case "base": case "br": case "col": case "command":
    case "embed": case "hr": case "img": case "input": case "keygen":
    case "link": case "meta": case "param": case "source": case "track":
    case "wbr":
      return true;
  }
  return false;
}
