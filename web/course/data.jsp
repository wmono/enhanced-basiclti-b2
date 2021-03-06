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
                java.util.List,
                java.util.Iterator,
                blackboard.platform.security.CourseRole,
                com.spvsoftwareproducts.blackboard.utils.B2Context,
                org.oscelot.blackboard.lti.Utils,
                org.oscelot.blackboard.lti.ToolList,
                org.oscelot.blackboard.lti.Constants"
        errorPage="../error.jsp"%>
<%@taglib uri="/bbNG" prefix="bbNG"%>
<bbNG:learningSystemPage title="${bundle['page.system.data.title']}" entitlement="course.content.MODIFY">
<%
  B2Context b2Context = new B2Context(request);
  String query = Utils.getQuery(request);
  String cancelUrl = "tools.jsp?" + query;
  String toolId = b2Context.getRequestParameter(Constants.TOOL_ID, Constants.DEFAULT_TOOL_ID);
  String toolSettingPrefix = Constants.TOOL_PARAMETER_PREFIX + "." + toolId + ".";
  boolean systemRolesOnly = !b2Context.getSetting(Constants.TOOL_PARAMETER_PREFIX + "." + Constants.TOOL_COURSE_ROLES, Constants.DATA_FALSE).equals(Constants.DATA_TRUE);
  List<CourseRole> roles = Utils.getCourseRoles(systemRolesOnly);

  if (request.getMethod().equalsIgnoreCase("POST")) {
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_CONTEXT_ID, b2Context.getRequestParameter(Constants.TOOL_CONTEXT_ID, Constants.DATA_FALSE));
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_CONTEXTIDTYPE, b2Context.getRequestParameter(Constants.TOOL_CONTEXTIDTYPE, Constants.DATA_BATCHUID));
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_CONTEXT_SOURCEDID, b2Context.getRequestParameter(Constants.TOOL_CONTEXT_SOURCEDID, Constants.DATA_FALSE));
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_CONTEXT_TITLE, b2Context.getRequestParameter(Constants.TOOL_CONTEXT_TITLE, Constants.DATA_FALSE));
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_USERID, b2Context.getRequestParameter(Constants.TOOL_USERID, Constants.DATA_NOTUSED));
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_USERIDTYPE, b2Context.getRequestParameter(Constants.TOOL_USERIDTYPE, Constants.DATA_PRIMARYKEY));
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_USER_SOURCEDID, b2Context.getRequestParameter(Constants.TOOL_USER_SOURCEDID, Constants.DATA_FALSE));
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_USERNAME, b2Context.getRequestParameter(Constants.TOOL_USERNAME, Constants.DATA_NOTUSED));
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_EMAIL, b2Context.getRequestParameter(Constants.TOOL_EMAIL, Constants.DATA_NOTUSED));
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_AVATAR, b2Context.getRequestParameter(Constants.TOOL_AVATAR, Constants.DATA_FALSE));
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_ROLES, b2Context.getRequestParameter(Constants.TOOL_ROLES, Constants.DATA_FALSE));
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_ENCRYPT_DATA, b2Context.getRequestParameter(Constants.TOOL_ENCRYPT_DATA, Constants.DATA_FALSE));
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_ENCRYPT_KEY, b2Context.getRequestParameter(Constants.TOOL_ENCRYPT_KEY, ""));
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_ENCRYPT_EMAIL_RANDOM_NAME, b2Context.getRequestParameter(Constants.TOOL_ENCRYPT_EMAIL_RANDOM_NAME, Constants.DATA_FALSE));
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_ENCRYPT_EMAIL_DOMAIN, b2Context.getRequestParameter(Constants.TOOL_ENCRYPT_EMAIL_DOMAIN, ""));
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_EXT_IROLES, b2Context.getRequestParameter(Constants.TOOL_EXT_IROLES, Constants.DATA_FALSE));
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_EXT_CROLES, b2Context.getRequestParameter(Constants.TOOL_EXT_CROLES, Constants.DATA_FALSE));
    for (Iterator<CourseRole> iter = roles.iterator(); iter.hasNext();) {
      CourseRole role = iter.next();
      b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_ROLE + "." + role.getIdentifier(), b2Context.getRequestParameterValues(Constants.TOOL_ROLE + role.getIdentifier(), ""));
    }
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_ADMINISTRATOR, b2Context.getRequestParameter(Constants.TOOL_ADMINISTRATOR, Constants.DATA_FALSE));
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_RESOURCE_URL, b2Context.getRequestParameter(Constants.TOOL_RESOURCE_URL, ""));
    b2Context.setSetting(false, true, toolSettingPrefix + Constants.TOOL_RESOURCE_SIGNATURE, b2Context.getRequestParameter(Constants.TOOL_RESOURCE_SIGNATURE, ""));
    b2Context.persistSettings(false, true);
    ToolList toolList = new ToolList(b2Context);
    toolList.setTool(toolId);
    cancelUrl = b2Context.setReceiptOptions(cancelUrl,
       b2Context.getResourceString("page.receipt.success"), null);
    response.sendRedirect(cancelUrl);
  }

  pageContext.setAttribute("courseId", b2Context.getRequestParameter("course_id", ""));
  Map<String,String> params = new HashMap<String,String>();

  pageContext.setAttribute("bundle", b2Context.getResourceStrings());
  if (toolId.equals(Constants.DEFAULT_TOOL_ID)) {
    pageContext.setAttribute("title", b2Context.getResourceString("page.system.data.default.title"));
    pageContext.setAttribute("instructions", b2Context.getResourceString("page.system.data.default.instructions"));
  } else {
    pageContext.setAttribute("title", b2Context.getResourceString("page.system.data.title") + ": " +
       b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_NAME));
    pageContext.setAttribute("instructions", b2Context.getResourceString("page.system.data.instructions"));
  }
  params.put(Constants.TOOL_ID, toolId);
  params.put(Constants.TOOL_CONTEXT_ID, b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_CONTEXT_ID, Constants.DATA_FALSE));
  params.put("contextidtype" + Constants.DATA_PRIMARYKEY, "false");
  params.put("contextidtype" + Constants.DATA_BATCHUID, "false");
  params.put("contextidtype" + Constants.DATA_COURSEID, "false");
  params.put("contextidtype" + b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_CONTEXTIDTYPE, Constants.DATA_BATCHUID), "true");
  params.put(Constants.TOOL_CONTEXT_SOURCEDID, b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_CONTEXT_SOURCEDID, Constants.DATA_FALSE));
  params.put(Constants.TOOL_CONTEXT_TITLE, b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_CONTEXT_TITLE, Constants.DATA_FALSE));
  params.put(Constants.TOOL_USER_SOURCEDID, b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_USER_SOURCEDID, Constants.DATA_FALSE));
  if (b2Context.getSetting(Constants.TOOL_PARAMETER_PREFIX + "." + Constants.TOOL_AVATAR, Constants.DATA_FALSE).equals(Constants.DATA_TRUE)) {
    pageContext.setAttribute("disableAvatar", "false");
    params.put(Constants.TOOL_AVATAR, b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_AVATAR, Constants.DATA_FALSE));
  } else {
    pageContext.setAttribute("disableAvatar", "true");
    params.put(Constants.TOOL_AVATAR, Constants.DATA_FALSE);
  }
  params.put(Constants.TOOL_ROLES, b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_ROLES, Constants.DATA_FALSE));
  params.put(Constants.TOOL_ENCRYPT_DATA, b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_ENCRYPT_DATA, Constants.DATA_FALSE));
  params.put(Constants.TOOL_ENCRYPT_KEY, b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_ENCRYPT_KEY, ""));
  params.put(Constants.TOOL_ENCRYPT_EMAIL_RANDOM_NAME, b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_ENCRYPT_EMAIL_RANDOM_NAME, Constants.DATA_FALSE));
  params.put(Constants.TOOL_ENCRYPT_EMAIL_DOMAIN, b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_ENCRYPT_EMAIL_DOMAIN, ""));
  params.put(Constants.TOOL_EXT_IROLES, b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_EXT_IROLES, Constants.DATA_FALSE));
  params.put(Constants.TOOL_EXT_CROLES, b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_EXT_CROLES, Constants.DATA_FALSE));
  for (Iterator<CourseRole> iter = roles.iterator(); iter.hasNext();) {
    CourseRole role = iter.next();
    params.put(Constants.TOOL_ROLE + role.getIdentifier(), b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_ROLE + "." + role.getIdentifier()));
  }
  params.put(Constants.TOOL_ADMINISTRATOR, b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_ADMINISTRATOR, Constants.DATA_FALSE));

  params.put("userid" + Constants.DATA_NOTUSED, "false");
  params.put("userid" + Constants.DATA_OPTIONAL, "false");
  params.put("userid" + Constants.DATA_MANDATORY, "false");
  params.put("userid" + b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_USERID, Constants.DATA_NOTUSED), "true");

  params.put("useridtype" + Constants.DATA_PRIMARYKEY, "false");
  params.put("useridtype" + Constants.DATA_BATCHUID, "false");
  params.put("useridtype" + Constants.DATA_USERNAME, "false");
  params.put("useridtype" + Constants.DATA_STUDENTID, "false");
  params.put("useridtype" + b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_USERIDTYPE, Constants.DATA_PRIMARYKEY), "true");

  params.put("username" + Constants.DATA_NOTUSED, "false");
  params.put("username" + Constants.DATA_OPTIONAL, "false");
  params.put("username" + Constants.DATA_MANDATORY, "false");
  params.put("username" + b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_USERNAME, Constants.DATA_NOTUSED), "true");

  params.put("email" + Constants.DATA_NOTUSED, "false");
  params.put("email" + Constants.DATA_OPTIONAL, "false");
  params.put("email" + Constants.DATA_MANDATORY, "false");
  params.put("email" + b2Context.getSetting(false, true, toolSettingPrefix + Constants.TOOL_EMAIL, Constants.DATA_NOTUSED), "true");

  pageContext.setAttribute("query", query);
  pageContext.setAttribute("params", params);
  pageContext.setAttribute("cancelUrl", cancelUrl);
%>
  <bbNG:pageHeader instructions="${instructions}">
    <bbNG:breadcrumbBar environment="SYS_ADMIN_PANEL" navItem="admin_plugin_manage">
      <bbNG:breadcrumb href="tools.jsp?${query}" title="${bundle['plugin.name']}" />
      <bbNG:breadcrumb title="${title}" />
    </bbNG:breadcrumbBar>
    <bbNG:pageTitleBar iconUrl="../images/lti.gif" showTitleBar="true" title="${title}"/>
  </bbNG:pageHeader>
  <bbNG:form action="data.jsp?${query}" name="toolForm" method="post" onsubmit="return validateForm();">
  <input type="hidden" name="<%=Constants.TOOL_ID%>" value="<%=params.get(Constants.TOOL_ID)%>" />
  <bbNG:dataCollection markUnsavedChanges="true" showSubmitButtons="true">
    <bbNG:step hideNumber="false" title="${bundle['page.system.data.step1.title']}" instructions="${bundle['page.system.data.step1.instructions']}">
      <bbNG:dataElement isRequired="true" label="${bundle['page.system.data.step1.contextid.label']}">
        <bbNG:checkboxElement isSelected="${params.contextid}" name="<%=Constants.TOOL_CONTEXT_ID%>" value="true" helpText="${bundle['page.system.data.step1.contextid.instructions']}" />
      </bbNG:dataElement>
      <bbNG:dataElement isRequired="true" label="${bundle['page.system.data.step2.contextidtype.label']}">
        <bbNG:selectElement name="<%=Constants.TOOL_CONTEXTIDTYPE%>" helpText="${bundle['page.system.data.step2.contextidtype.instructions']}">
          <bbNG:selectOptionElement isSelected="${params.contextidtypeP}" value="<%=Constants.DATA_PRIMARYKEY%>" optionLabel="${bundle['page.system.data.step2.contextidtype.primarykey']}" />
          <bbNG:selectOptionElement isSelected="${params.contextidtypeB}" value="<%=Constants.DATA_BATCHUID%>" optionLabel="${bundle['page.system.data.step2.contextidtype.batchuid']}" />
          <bbNG:selectOptionElement isSelected="${params.contextidtypeC}" value="<%=Constants.DATA_COURSEID%>" optionLabel="${bundle['page.system.data.step2.contextidtype.courseid']}" />
        </bbNG:selectElement>
      </bbNG:dataElement>
      <bbNG:dataElement isRequired="true" label="${bundle['page.system.data.step1.contextsourcedid.label']}">
        <bbNG:checkboxElement isSelected="${params.contextsourcedid}" name="<%=Constants.TOOL_CONTEXT_SOURCEDID%>" value="true" helpText="${bundle['page.system.data.step1.contextsourcedid.instructions']}" />
      </bbNG:dataElement>
      <bbNG:dataElement isRequired="true" label="${bundle['page.system.data.step1.contexttitle.label']}">
        <bbNG:checkboxElement isSelected="${params.contexttitle}" name="<%=Constants.TOOL_CONTEXT_TITLE%>" value="true" helpText="${bundle['page.system.data.step1.contexttitle.instructions']}" />
      </bbNG:dataElement>
    </bbNG:step>
    <bbNG:step hideNumber="false" title="${bundle['page.system.data.step2.title']}" instructions="${bundle['page.system.data.step2.instructions']}">
      <bbNG:dataElement isRequired="true" label="${bundle['page.system.data.step2.userid.label']}">
        <bbNG:selectElement name="<%=Constants.TOOL_USERID%>" helpText="${bundle['page.system.data.step2.userid.instructions']}">
          <bbNG:selectOptionElement isSelected="${params.useridN}" value="<%=Constants.DATA_NOTUSED%>" optionLabel="${bundle['page.system.data.select.notused']}" />
          <bbNG:selectOptionElement isSelected="${params.useridO}" value="<%=Constants.DATA_OPTIONAL%>" optionLabel="${bundle['page.system.data.select.optional']}" />
          <bbNG:selectOptionElement isSelected="${params.useridM}" value="<%=Constants.DATA_MANDATORY%>" optionLabel="${bundle['page.system.data.select.mandatory']}" />
        </bbNG:selectElement>
      </bbNG:dataElement>
      <bbNG:dataElement isRequired="true" label="${bundle['page.system.data.step2.useridtype.label']}">
        <bbNG:selectElement name="<%=Constants.TOOL_USERIDTYPE%>" helpText="${bundle['page.system.data.step2.useridtype.instructions']}">
          <bbNG:selectOptionElement isSelected="${params.useridtypeP}" value="<%=Constants.DATA_PRIMARYKEY%>" optionLabel="${bundle['page.system.data.step2.useridtype.primarykey']}" />
          <bbNG:selectOptionElement isSelected="${params.useridtypeB}" value="<%=Constants.DATA_BATCHUID%>" optionLabel="${bundle['page.system.data.step2.useridtype.batchuid']}" />
          <bbNG:selectOptionElement isSelected="${params.useridtypeN}" value="<%=Constants.DATA_USERNAME%>" optionLabel="${bundle['page.system.data.step2.useridtype.username']}" />
          <bbNG:selectOptionElement isSelected="${params.useridtypeS}" value="<%=Constants.DATA_STUDENTID%>" optionLabel="${bundle['page.system.data.step2.useridtype.studentid']}" />
        </bbNG:selectElement>
      </bbNG:dataElement>
      <bbNG:dataElement isRequired="true" label="${bundle['page.system.data.step2.usersourcedid.label']}">
        <bbNG:checkboxElement isSelected="${params.usersourcedid}" name="<%=Constants.TOOL_USER_SOURCEDID%>" value="true" helpText="${bundle['page.system.data.step2.usersourcedid.instructions']}" />
      </bbNG:dataElement>
      <bbNG:dataElement isRequired="true" label="${bundle['page.system.data.step2.username.label']}">
        <bbNG:selectElement name="<%=Constants.TOOL_USERNAME%>" helpText="${bundle['page.system.data.step2.username.instructions']}">
          <bbNG:selectOptionElement isSelected="${params.usernameN}" value="<%=Constants.DATA_NOTUSED%>" optionLabel="${bundle['page.system.data.select.notused']}" />
          <bbNG:selectOptionElement isSelected="${params.usernameO}" value="<%=Constants.DATA_OPTIONAL%>" optionLabel="${bundle['page.system.data.select.optional']}" />
          <bbNG:selectOptionElement isSelected="${params.usernameM}" value="<%=Constants.DATA_MANDATORY%>" optionLabel="${bundle['page.system.data.select.mandatory']}" />
        </bbNG:selectElement>
      </bbNG:dataElement>
      <bbNG:dataElement isRequired="true" label="${bundle['page.system.data.step2.email.label']}">
        <bbNG:selectElement name="<%=Constants.TOOL_EMAIL%>" helpText="${bundle['page.system.data.step2.email.instructions']}">
          <bbNG:selectOptionElement isSelected="${params.emailN}" value="<%=Constants.DATA_NOTUSED%>" optionLabel="${bundle['page.system.data.select.notused']}" />
          <bbNG:selectOptionElement isSelected="${params.emailO}" value="<%=Constants.DATA_OPTIONAL%>" optionLabel="${bundle['page.system.data.select.optional']}" />
          <bbNG:selectOptionElement isSelected="${params.emailM}" value="<%=Constants.DATA_MANDATORY%>" optionLabel="${bundle['page.system.data.select.mandatory']}" />
        </bbNG:selectElement>
      </bbNG:dataElement>
      <bbNG:dataElement isRequired="true" label="${bundle['page.system.data.step2.avatar.label']}">
        <bbNG:checkboxElement isSelected="${params.avatar}" name="<%=Constants.TOOL_AVATAR%>" value="true" helpText="${bundle['page.system.data.step2.avatar.instructions']}" isDisabled="${disableAvatar}" />
      </bbNG:dataElement>
      <bbNG:dataElement isRequired="true" label="${bundle['page.system.data.step2.roles.label']}">
        <bbNG:checkboxElement isSelected="${params.roles}" name="<%=Constants.TOOL_ROLES%>" value="true" helpText="${bundle['page.system.data.step2.roles.instructions']}" />
        <bbNG:dataElement isSubElement="true" subElementType="INDENTED_NESTED_LIST">
          <bbNG:dataElement isRequired="true" label="${bundle['page.system.data.step2.ext_iroles.label']}">
            <bbNG:checkboxElement isSelected="${params.ext_iroles}" name="<%=Constants.TOOL_EXT_IROLES%>" value="true" helpText="${bundle['page.system.data.step2.ext_iroles.instructions']}" />
          </bbNG:dataElement>
          <bbNG:dataElement isRequired="true" label="${bundle['page.system.data.step2.ext_croles.label']}">
            <bbNG:checkboxElement isSelected="${params.ext_croles}" name="<%=Constants.TOOL_EXT_CROLES%>" value="true" helpText="${bundle['page.system.data.step2.ext_croles.instructions']}" />
          </bbNG:dataElement>
        </bbNG:dataElement>
        <bbNG:dataElement isRequired="false" label="${bundle['page.system.data.step2.encryption.label']}">
            <bbNG:checkboxElement isSelected="${params.encrypt_data}" name="<%=Constants.TOOL_ENCRYPT_DATA%>" value="true" helpText="${bundle['page.system.data.step2.encryption.instructions']}" />
        </bbNG:dataElement>
        <bbNG:dataElement isRequired="false" label="${bundle['page.system.data.step2.encryption_key.label']}">
            <bbNG:textElement type="string" name="<%=Constants.TOOL_ENCRYPT_KEY%>" value="<%=params.get(Constants.TOOL_ENCRYPT_KEY)%>" size="80" helpText="${bundle['page.system.data.step2.encryption_key.instructions']}" />
        </bbNG:dataElement>
        <bbNG:dataElement isRequired="false" label="${bundle['page.system.data.step2.encryption_email_random_name.label']}">
            <bbNG:checkboxElement isSelected="${params.encrypt_email_random_name}" name="<%=Constants.TOOL_ENCRYPT_EMAIL_RANDOM_NAME%>" value="true" helpText="${bundle['page.system.data.step2.encryption_email_random_name.instructions']}" />
        </bbNG:dataElement>
        <bbNG:dataElement isRequired="false" label="${bundle['page.system.data.step2.encryption_email_domain.label']}">
            <bbNG:textElement type="string" name="<%=Constants.TOOL_ENCRYPT_EMAIL_DOMAIN%>" value="<%=params.get(Constants.TOOL_ENCRYPT_EMAIL_DOMAIN)%>" size="80" helpText="${bundle['page.system.data.step2.encryption_email_domain.instructions']}" />
        </bbNG:dataElement>
      </bbNG:dataElement>
    </bbNG:step>
    <bbNG:step hideNumber="false" title="${bundle['page.system.data.step3.title']}" instructions="${bundle['page.system.data.step3.instructions']}">
      <bbNG:dataElement isRequired="true" label="${bundle['page.system.data.step3.roles.label']}">
        <bbNG:settingsPageList collection="<%=roles%>" objectVar="role" className="CourseRole"
           description="${bundle['page.system.data.step3.roles.description']}" reorderable="false">
          <bbNG:listElement isRowHeader="true" label="${bundle['page.system.data.step3.roles.label']}" name="name">
<%
      String roleSetting = params.get("role" + role.getIdentifier());
      if (roleSetting != null) {
        pageContext.setAttribute("roleI", String.valueOf(roleSetting.contains("I")));
        pageContext.setAttribute("roleD", String.valueOf(roleSetting.contains("D")));
        pageContext.setAttribute("roleT", String.valueOf(roleSetting.contains("T")));
        pageContext.setAttribute("roleL", String.valueOf(roleSetting.contains("L")));
        pageContext.setAttribute("roleM", String.valueOf(roleSetting.contains("M")));
      }
%>
            ${role.courseName}
          </bbNG:listElement>
          <bbNG:listElement isRowHeader="false" name="I" label="${bundle['page.system.data.step3.roles.instructor']}">
            <bbNG:checkboxElement isSelected="${roleI}" name="role${role.identifier}" value="I" />
          </bbNG:listElement>
          <bbNG:listElement isRowHeader="false" name="D" label="${bundle['page.system.data.step3.roles.contentdeveloper']}">
            <bbNG:checkboxElement isSelected="${roleD}" name="role${role.identifier}" value="D" />
          </bbNG:listElement>
          <bbNG:listElement isRowHeader="false" name="T" label="${bundle['page.system.data.step3.roles.teachingassistant']}">
            <bbNG:checkboxElement isSelected="${roleT}" name="role${role.identifier}" value="T" />
          </bbNG:listElement>
          <bbNG:listElement isRowHeader="false" name="L" label="${bundle['page.system.data.step3.roles.learner']}">
            <bbNG:checkboxElement isSelected="${roleL}" name="role${role.identifier}" value="L" />
          </bbNG:listElement>
          <bbNG:listElement isRowHeader="false" name="M" label="${bundle['page.system.data.step3.roles.mentor']}">
            <bbNG:checkboxElement isSelected="${roleM}" name="role${role.identifier}" value="M" />
          </bbNG:listElement>
        </bbNG:settingsPageList>
      </bbNG:dataElement>
      <bbNG:dataElement isRequired="true" label="${bundle['page.system.data.step3.administrator.label']}">
        <bbNG:checkboxElement isSelected="${params.administrator}" name="<%=Constants.TOOL_ADMINISTRATOR%>" value="true" helpText="${bundle['page.system.data.step3.administrator.instructions']}" />
      </bbNG:dataElement>
    </bbNG:step>
    <bbNG:stepSubmit hideNumber="false" showCancelButton="true" cancelUrl="${cancelUrl}" />
  </bbNG:dataCollection>
  </bbNG:form>
</bbNG:learningSystemPage>
