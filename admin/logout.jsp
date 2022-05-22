<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Cookie c = new Cookie("login","");
        c.setMaxAge(0);
        response.addCookie(c);
        response.sendRedirect("index.jsp");
%>