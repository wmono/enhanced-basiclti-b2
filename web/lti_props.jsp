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
<%@page import="java.util.Map,
                java.util.List,
                blackboard.portal.data.Module,
                blackboard.portal.persist.ModuleDbLoader,
                blackboard.persist.Id,
                blackboard.persist.KeyNotFoundException,
                blackboard.persist.PersistenceException,
                com.spvsoftwareproducts.blackboard.utils.B2Context,
                org.oscelot.blackboard.lti.Constants,
                org.oscelot.blackboard.lti.Tool,
                org.oscelot.blackboard.lti.Utils,
                org.oscelot.blackboard.lti.LaunchMessage"%>
<%
  String moduleId = Utils.checkForModule(request);
  Module module = Utils.getModule(moduleId);
  B2Context b2Context = new B2Context(request);
  pageContext.setAttribute("bundle", b2Context.getResourceStrings());
  String toolId = b2Context.getSetting(false, true,
     Constants.TOOL_PARAMETER_PREFIX + "." + Constants.TOOL_ID,
     b2Context.getRequestParameter(Constants.TOOL_ID, ""));
  String idString = "";
  Tool tool = new Tool(b2Context, toolId);
  if (tool.getName().length() <= 0) {
    idString = toolId;
    toolId = b2Context.getSetting(false, true, Constants.TOOL_ID + "." + idString + "." + Constants.TOOL_PARAMETER_PREFIX + "." + Constants.TOOL_ID, "");
    tool = new Tool(b2Context, toolId);
  }
  String toolURL = tool.getLaunchUrl();
  LaunchMessage message = new LaunchMessage(b2Context, toolId, idString, module);
  message.signParameters(toolURL, tool.getLaunchGUID(), tool.getLaunchSecret());
  List<Map.Entry<String, String>> params = message.getParams();
%>
