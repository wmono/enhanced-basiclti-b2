<%--
    basiclti - Building Block to provide support for Basic LTI
    Copyright (C) 2014  Stephen P Vickers

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

    Contact: stephen@spvsoftwareproducts.com
--%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@page contentType="text/html" pageEncoding="UTF-8"
        import="java.util.List,
                java.util.Map,
                blackboard.portal.data.Module,
                org.oscelot.blackboard.lti.Constants,
                org.oscelot.blackboard.lti.Tool,
                org.oscelot.blackboard.lti.LtiMessage,
                org.oscelot.blackboard.lti.ConfigMessage,
                org.oscelot.blackboard.lti.Utils,
                com.spvsoftwareproducts.blackboard.utils.B2Context"
        errorPage="../error.jsp"%>
<%
  B2Context b2Context = new B2Context(request);
  b2Context.setIgnoreContentContext(true);
  b2Context.setIgnoreCourseContext(true);
  String toolId = b2Context.getRequestParameter(Constants.TOOL_ID, "");
  LtiMessage message = new ConfigMessage(b2Context, toolId);
  String toolURL = message.tool.getLaunchUrl();
  message.signParameters(toolURL, message.tool.getLaunchGUID(), message.tool.getLaunchSecret());
  List<Map.Entry<String, String>> params = message.getParams();
  pageContext.setAttribute("bundle", b2Context.getResourceStrings());
%>
<html>
<head>
<script language="javascript" type="text/javascript">
function doOnLoad() {
  document.forms[0].submit();
}
window.onload=doOnLoad;
</script>
</head>
<body>
<p>${bundle['page.course_tool.tool.redirect.label']}</p>
<form action="<%=toolURL%>" method="post">
<%
  for (Map.Entry<String,String> entry : params) {
    String name = Utils.htmlSpecialChars(entry.getKey());
    String value = Utils.htmlSpecialChars(entry.getValue());
%>
   <input type="hidden" name="<%=name%>" value="<%=value%>">
<%
  }
%>
</form>
</body>
</html>
