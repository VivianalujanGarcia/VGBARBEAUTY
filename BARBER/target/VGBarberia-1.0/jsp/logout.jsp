<%
HttpSession sesion=request.getSession();
sesion.invalidate();
response.sendRedirect("../index.jsp");
%>