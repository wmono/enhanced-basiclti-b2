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
        import="java.util.Map,
                java.util.HashMap,
                com.spvsoftwareproducts.blackboard.utils.B2Context,
                org.oscelot.blackboard.lti.ToolList,
                org.oscelot.blackboard.lti.Constants,
                org.oscelot.blackboard.lti.Utils"
        errorPage="../error.jsp"%>
<%@taglib uri="/bbNG" prefix="bbNG"%>
<bbNG:genericPage title="${bundle['page.system.launch.title']}" entitlement="system.admin.VIEW">
<%
  B2Context b2Context = new B2Context(request);
  String toolId = b2Context.getRequestParameter(Constants.TOOL_ID, Constants.DEFAULT_TOOL_ID);
  boolean isDomain = b2Context.getRequestParameter(Constants.ACTION, "").equals(Constants.DOMAIN_PARAMETER_PREFIX);
  String cancelUrl = null;
  String prefix = null;
  if (isDomain) {
    cancelUrl = "domains.jsp";
    prefix = Constants.DOMAIN_PARAMETER_PREFIX;
  } else {
    cancelUrl = "tools.jsp";
    prefix = Constants.TOOL_PARAMETER_PREFIX;
  }
  String query = Utils.getQuery(request);
  cancelUrl += "?" + query;
  String toolSettingPrefix = prefix + "." + toolId + ".";

  if (request.getMethod().equalsIgnoreCase("POST")) {
    b2Context.setSetting(Constants.TOOL_PARAMETER_PREFIX + "." + toolId,
       b2Context.getSetting(Constants.TOOL_PARAMETER_PREFIX + "." + toolId, Constants.DATA_FALSE));
    b2Context.setSetting(toolSettingPrefix + Constants.TOOL_OPEN_IN, b2Context.getRequestParameter(Constants.TOOL_OPEN_IN, Constants.DATA_FRAME));
    b2Context.setSetting(toolSettingPrefix + Constants.TOOL_WINDOW_NAME, b2Context.getRequestParameter(Constants.TOOL_WINDOW_NAME, ""));
    b2Context.setSetting(toolSettingPrefix + Constants.TOOL_SPLASH, b2Context.getRequestParameter(Constants.TOOL_SPLASH, Constants.DATA_FALSE));
    b2Context.setSetting(toolSettingPrefix + Constants.TOOL_SPLASHFORMAT, b2Context.getRequestParameter(Constants.TOOL_SPLASHFORMAT, "H"));
    b2Context.setSetting(toolSettingPrefix + Constants.TOOL_SPLASHTEXT, b2Context.getRequestParameter(Constants.TOOL_SPLASHTEXT, ""));
    b2Context.setSetting(toolSettingPrefix + Constants.TOOL_CUSTOM, b2Context.getRequestParameter(Constants.TOOL_CUSTOM, ""));
    b2Context.persistSettings();
    if (!toolId.equals(Constants.DEFAULT_TOOL_ID)) {
      ToolList toolList = new ToolList(b2Context, true, isDomain);
      toolList.setTool(toolId);
    }
    cancelUrl = b2Context.setReceiptOptions(cancelUrl,
       b2Context.getResourceString("page.receipt.success"), null);
    response.sendRedirect(cancelUrl);
    return;
  }

  Map<String,String> params = new HashMap<String,String>();

  Map<String,String> resourceStrings = b2Context.getResourceStrings();
  pageContext.setAttribute("bundle", resourceStrings);
  if (toolId.equals(Constants.DEFAULT_TOOL_ID)) {
    pageContext.setAttribute("title", b2Context.getResourceString("page.system.launch.default.title"));
    pageContext.setAttribute("instructions", b2Context.getResourceString("page.system.launch.default.instructions"));
  } else {
    pageContext.setAttribute("title", b2Context.getResourceString("page.system.launch.title") + ": " +
       b2Context.getSetting(toolSettingPrefix + Constants.TOOL_NAME));
    if (isDomain) {
      pageContext.setAttribute("instructions", b2Context.getResourceString("page.system.launch.domain.instructions"));
    } else {
      pageContext.setAttribute("instructions", b2Context.getResourceString("page.system.launch.tool.instructions"));
    }
  }
  params.put(Constants.TOOL_ID, toolId);
  params.put(Constants.TOOL_OPEN_IN, b2Context.getSetting(toolSettingPrefix + Constants.TOOL_OPEN_IN, Constants.DATA_FRAME));
  params.put(Constants.TOOL_WINDOW_NAME, b2Context.getSetting(toolSettingPrefix + Constants.TOOL_WINDOW_NAME, ""));
  params.put(Constants.TOOL_SPLASH, b2Context.getSetting(toolSettingPrefix + Constants.TOOL_SPLASH, Constants.DATA_FALSE));
  params.put(Constants.TOOL_SPLASHFORMAT, b2Context.getSetting(toolSettingPrefix + Constants.TOOL_SPLASHFORMAT));
  params.put(Constants.TOOL_SPLASHTEXT, b2Context.getSetting(toolSettingPrefix + Constants.TOOL_SPLASHTEXT));
  params.put(Constants.TOOL_CUSTOM, b2Context.getSetting(toolSettingPrefix + Constants.TOOL_CUSTOM));
  params.put(Constants.TOOL_OPEN_IN + params.get(Constants.TOOL_OPEN_IN), Constants.DATA_TRUE);
  params.put(Constants.TOOL_OPEN_IN + Constants.DATA_FRAME + "label",
     b2Context.getResourceString("page.system.launch.openin." + Constants.DATA_FRAME));
  params.put(Constants.TOOL_OPEN_IN + Constants.DATA_FRAME_NO_BREADCRUMBS + "label",
     b2Context.getResourceString("page.system.launch.openin." + Constants.DATA_FRAME_NO_BREADCRUMBS));
  params.put(Constants.TOOL_OPEN_IN + Constants.DATA_WINDOW + "label",
     b2Context.getResourceString("page.system.launch.openin." + Constants.DATA_WINDOW));
  params.put(Constants.TOOL_OPEN_IN + Constants.DATA_IFRAME + "label",
     b2Context.getResourceString("page.system.launch.openin." + Constants.DATA_IFRAME));
  pageContext.setAttribute("query", query);
  pageContext.setAttribute("params", params);
  pageContext.setAttribute("cancelUrl", cancelUrl);
%>
  <bbNG:pageHeader instructions="${instructions}">
    <bbNG:breadcrumbBar environment="SYS_ADMIN_PANEL" navItem="admin_plugin_manage">
      <bbNG:breadcrumb href="${cancelUrl}" title="${bundle['plugin.name']}" />
      <bbNG:breadcrumb title="${title}" />
    </bbNG:breadcrumbBar>
    <bbNG:pageTitleBar iconUrl="../images/lti.gif" showTitleBar="true" title="${title}"/>
  </bbNG:pageHeader>
  <bbNG:form action="launch.jsp?${query}" name="toolForm" method="post" onsubmit="return validateForm();">
  <input type="hidden" name="<%=Constants.TOOL_ID%>" value="<%=params.get(Constants.TOOL_ID)%>" />
  <input type="hidden" name="<%=Constants.ACTION%>" value="<%=prefix%>" />
  <bbNG:dataCollection markUnsavedChanges="true" showSubmitButtons="true">
    <bbNG:step hideNumber="false" title="${bundle['page.system.launch.step1.title']}" instructions="${bundle['page.system.launch.step1.instructions']}">
      <bbNG:dataElement isRequired="true" label="${bundle['page.system.launch.step1.openin.label']}">
        <bbNG:selectElement name="<%=Constants.TOOL_OPEN_IN%>" helpText="${bundle['page.system.launch.step1.openin.instructions']}">
          <bbNG:selectOptionElement isSelected="${params.openinF}" value="<%=Constants.DATA_FRAME%>" optionLabel="${params.openinFlabel}" />
          <bbNG:selectOptionElement isSelected="${params.openinFNB}" value="<%=Constants.DATA_FRAME_NO_BREADCRUMBS%>" optionLabel="${params.openinFNBlabel}" />
          <bbNG:selectOptionElement isSelected="${params.openinW}" value="<%=Constants.DATA_WINDOW%>" optionLabel="${params.openinWlabel}" />
          <bbNG:selectOptionElement isSelected="${params.openinI}" value="<%=Constants.DATA_IFRAME%>" optionLabel="${params.openinIlabel}" />
        </bbNG:selectElement>
      </bbNG:dataElement>
      <bbNG:dataElement isRequired="false" label="${bundle['page.system.launch.step1.windowname.label']}">
        <bbNG:textElement type="string" name="<%=Constants.TOOL_WINDOW_NAME%>" value="<%=params.get(Constants.TOOL_WINDOW_NAME)%>" size="20" helpText="${bundle['page.system.launch.step1.windowname.instructions']}" />
      </bbNG:dataElement>
      <bbNG:dataElement isRequired="true" label="${bundle['page.system.launch.step1.show.label']}">
        <bbNG:checkboxElement isSelected="${params.splash}" name="<%=Constants.TOOL_SPLASH%>" value="true" helpText="${bundle['page.system.launch.step1.show.instructions']}" />
      </bbNG:dataElement>
      <bbNG:dataElement isRequired="false" label="${bundle['page.system.launch.step1.text.label']}">
        <bbNG:textbox name="<%=Constants.TOOL_SPLASH%>" format="${params.splashtype}" text="${params.splashtext}" helpText="${bundle['page.system.launch.step1.text.instructions']}" rows="5" />
      </bbNG:dataElement>
    </bbNG:step>
    <bbNG:step hideNumber="false" title="${bundle['page.system.launch.step2.title']}" instructions="${bundle['page.system.launch.step2.instructions']}">
      <bbNG:dataElement isRequired="false" label="${bundle['page.system.launch.step2.custom.label']}">
        <textarea name="<%=Constants.TOOL_CUSTOM%>" cols="75" rows="5">${params.custom}</textarea>
        <bbNG:elementInstructions text="${bundle['page.system.launch.step2.custom.instructions']}" />
      </bbNG:dataElement>
    </bbNG:step>
    <bbNG:stepSubmit hideNumber="false" showCancelButton="true" cancelUrl="${cancelUrl}" />
  </bbNG:dataCollection>
  </bbNG:form>
</bbNG:genericPage>
