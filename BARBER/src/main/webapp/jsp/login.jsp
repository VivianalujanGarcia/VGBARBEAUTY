<%@page import="java.math.BigInteger"%>  
<%@page import="java.security.MessageDigest"%>  
<%@ include file="../jsp/conexion.jsp" %>

<%                                   
Statement st = null;
ResultSet rs = null;

/* Tomamos los parámetros del HTML */
String user = request.getParameter("usuario");
String password = request.getParameter("passw");

/* Instanciamos para crear nuestras sesiones */
HttpSession sesion = request.getSession();

try {
    // Creamos una consulta con seguridad para evitar inyección SQL (PreparedStatement)
    String query = "SELECT * FROM usuarios WHERE usuario = ? AND clave = ?";
    PreparedStatement ps = conn.prepareStatement(query);
    ps.setString(1, user);
    ps.setString(2, password);
    
    rs = ps.executeQuery();
    
    // Verificamos si el usuario existe y si el estado es "A" (activo)
    if (rs.next()) {
        String estado = rs.getString("estado").trim(); // Remover posibles espacios en blanco
        
        //out.println("<div class=\"alert alert-info\" role=\"alert\">Estado del usuario: " + estado + "</div>"); // Depuración

        if ("A".equalsIgnoreCase(estado)) {
            // Si el usuario está activo, se inicia sesión
            sesion.setAttribute("logueado", "1");
            sesion.setAttribute("user", rs.getString("usuario"));
            sesion.setAttribute("id", rs.getString("id"));
            sesion.setAttribute("dato", rs.getString("datos"));
            sesion.setAttribute("rol", rs.getString("rol"));
%>
            <div class="alert alert-success" role="alert">Ingresando...</div>
            
            <script>
                setTimeout(function() {
                    location.href = 'dashboard.jsp'; // Redirige después de 2 segundos
                }, 2000);
            </script>
<%
        } else {
            // Si el usuario está inactivo, mostramos un mensaje
            out.println("<div class=\"alert alert-danger\" role=\"alert\">Tu cuenta está inactiva. No puedes acceder.</div>");
            out.println("<script>setTimeout(function() { $('.alert-danger').fadeOut(); }, 3000);</script>");
        }
    } else {
        // Si el usuario no existe o las credenciales son incorrectas
        out.println("<div class=\"alert alert-danger\" role=\"alert\">Usuario o contraseña incorrectos.</div>");
        out.println("<script>setTimeout(function() { $('.alert-danger').fadeOut(); }, 3000);</script>");
    }
} catch (Exception e) {
    // En caso de error, mostrar el mensaje
    out.print("<div class=\"alert alert-danger\" role=\"alert\">Error al procesar la solicitud: " + e.getMessage() + "</div>");
} finally {
    // Cerrar conexiones
    try {
        if (rs != null) {
            rs.close();
        }
        if (st != null) {
            st.close();
        }
    } catch (Exception e) {
        out.print("<div class=\"alert alert-danger\" role=\"alert\">Error al cerrar la conexión: " + e.getMessage() + "</div>");
    }
}
%>
